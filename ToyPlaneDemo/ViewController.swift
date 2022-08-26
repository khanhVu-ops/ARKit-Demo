//
//  ViewController.swift
//  ToyPlaneDemo
//
//  Created by KhanhVu on 8/11/22.
//

import UIKit
import RealityKit
import Poly
import ARKit
import SceneKit
import SceneKit.ModelIO
import SDWebImage
class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cltvListObject: UICollectionView!
    var session: ARSession {
        return sceneView.session
    }
    var listObject3D = [Object3DModel]()
    var listLabelDetect = ["Cat", "Flower", "Lion", "Laptop", "Mouse", "Dog", "Phone"]
    let coachingOverlay = ARCoachingOverlayView()
    let poly = Poly()
//    var fileUrl: [String] = []
    var objPathURL: URL?
    var mtlPathURL: URL?
    var totalFilesDownloaded = 0
    var focusSquare = FocusSquare()
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    override func viewDidLoad() {
        super.viewDidLoad()
        poly.apiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
        setupCoachingOverlay()
        cltvListObject.register(UINib(nibName: "ObjectCLTVC", bundle: nil), forCellWithReuseIdentifier: "ObjectCLTVC")
        cltvListObject.delegate = self
        cltvListObject.dataSource = self
        sceneView.scene.rootNode.addChildNode(focusSquare)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.automaticImageScaleEstimationEnabled = true
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        getListObjectFromPoly()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
        }
    }
    
    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
//        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        setActivatesAutomatically()
        
        // Most of the virtual objects in this sample require a horizontal surface,
        // therefore coach the user to find a horizontal plane.
        setGoal()
    }
    
    /// - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }

    /// - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
    
    func getListObjectFromPoly() {
        for label in listLabelDetect {
            getObjectFromPoly(keyword: label)
        }
    }
    
    func getObjectFromPoly(keyword: String) {
     
        poly.list(assetsWithKeywords: [keyword]) { [weak self] (assets, totalCount, nextPage, error) in
            guard let assets = assets else {
                return
            }
            if assets.count > 0 {
                guard let asset = self?.checkKeywordMatch(keyword: keyword, assets: assets) else {
                    return
                }
                
                
                print(asset.identifier)
                
                for format in 0..<asset.formats!.count {
                    if asset.formats?[format].formatType == "OBJ" {
                        let imgName = asset.thumbnail?.url ?? ""
                        let assetId = asset.identifier 
                        let objURL = asset.formats?[format].root?.url ?? ""
                        let mtlURL = asset.formats?[format].resources?[0].url ?? ""
                        self?.listObject3D.append(Object3DModel(thumbnail: imgName, displayName: keyword, assetId: assetId, objURL: objURL, mtlURL: mtlURL))
//                                self?.downloadFromUrl()
                        DispatchQueue.main.async {
                            self?.cltvListObject.reloadData()
                        }
                        break
                    }
                }
            }
            
        }
    }
    
    func checkKeywordMatch(keyword: String, assets: [PolyAssetModel]) -> PolyAssetModel? {
        for asset in assets {
            if asset.displayName == keyword {
                return asset
            }
        }
        
        for asset in assets {
            if asset.displayName?.contains(keyword) == true {
                return asset
            }
        }
        
        for asset in assets {
            if asset.assetDescription?.contains(keyword) == true {
                return asset
            }
        }
        return nil
    }
    
    func downloadFromUrl(object: Object3DModel) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        let fileURL = [object.objURL, object.mtlURL]
        for file in fileURL {
            guard let url = URL(string: file ?? "") else {
                return
            }
           
            let downloadTask = session.downloadTask(with: url)
            
            downloadTask.resume()
        }
    }
    
    
    func loadObjectToScene() {
        guard let objPathURL = objPathURL else {
            return
        }
        let mdlAsset = MDLAsset(url: objPathURL)
        mdlAsset.loadTextures()
        let node = SCNNode(mdlObject: mdlAsset.object(at: 0))
        node.scale = SCNVector3Make(0.1, 0.1, 0.01)
        node.position = SCNVector3Make(1, 0, 2)
        
//        let rotate = SCNAction.repeatForever(SCNAction.rotate(by: -.pi, around: SCNVector3Make(1, 0, 0), duration: 3))
//        node.runAction(rotate)

        sceneView.scene.rootNode.addChildNode(node)
    }
    
   
 
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]
        let finalPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(downloadTask.originalRequest?.url?.lastPathComponent ?? "").path
        let fileManager = FileManager.default

        var success = false
        var error: Error?
        if fileManager.fileExists(atPath: finalPath) {
            do {
                try fileManager.removeItem(atPath: finalPath)
                success = true
            } catch let e {
                success = false
                error = e
          
            }
        }
        
        let finalPathURL = URL(fileURLWithPath: finalPath)
        do {
            try fileManager.moveItem(at: location, to: finalPathURL)
            success = true
            
            if let error = error {
                success = false
            }
        } catch {
            print("Failed to download file. \(error.localizedDescription )")
        }
        if success == true {
            totalFilesDownloaded += 1
            if finalPathURL.lastPathComponent.contains("obj") {
                objPathURL = finalPathURL
            } else if finalPathURL.lastPathComponent.contains("mtl") {
                mtlPathURL = finalPathURL
            }

            // If we've downloaded both files, let's add the asset to our scene.
            if totalFilesDownloaded % 2 == 0{
                loadObjectToScene()
            }

        }
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare(isObjectVisible: false)
            
            // If the object selection menu is open, update availability of items
            
        }
    }
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        <#code#>
//    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listObject3D.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltvListObject.dequeueReusableCell(withReuseIdentifier: "ObjectCLTVC", for: indexPath) as! ObjectCLTVC
        cell.configure(model: listObject3D[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: cltvListObject.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.downloadFromUrl(object: listObject3D[indexPath.row])
//        cltvListObject.deselectItem(at: indexPath, animated: true)
    }
}
extension ARSCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD3<Float> type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }

    // - Tag: GetRaycastQuery
    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }
    
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
