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
    
    @IBOutlet weak var imgLib: UIImageView!
    let coachingOverlay = ARCoachingOverlayView()
    // url: "https://poly.googleapis.com/v1/assets/5vbJ5vildOq?key=AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ
    let poly = Poly()
    var fileUrl: [String] = []
    var objPathURL: URL?
    var mtlPathURL: URL?
    var totalFilesDownloaded = 0
    var boxNode: SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        poly.apiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
//        setupCoachingOverlay()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
//        sceneView.delegate = self
        
        getObjectFromPoly()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
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
    func getObjectFromPoly() {
        poly.list(assetsWithKeywords: ["Cat"]) { [weak self] (assets, totalCount, nextPage, error) in
            guard let assets = assets else {
                return
            }
            if assets.count > 0 {
                for asset in assets {
                    if asset.displayName == "Fox" {
                        for format in 0..<asset.formats!.count {
                            if asset.formats?[format].formatType == "OBJ" {
                                
                                self?.objPathURL = URL(string: asset.formats?[format].root?.url ?? "")
                                self?.mtlPathURL = URL(string: asset.formats?[format].resources?[0].url ?? "")
                                
                                self?.fileUrl.append(asset.formats?[format].root?.url ?? "")
                                self?.fileUrl.append(asset.formats?[format].resources?[0].url ?? "")
                                guard let urlImg = URL(string: asset.thumbnail?.url ?? "") else {
                                    return
                                }
                                print(asset.identifier)
                                self?.imgLib.sd_setImage(with: urlImg)
                                self?.downloadFromUrl()
                                break
                            }
                        }
                        break
                    }
                }
                
            }
            
        }
    }
    
    func downloadFromUrl() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        for file in fileUrl {
            guard let url = URL(string: file) else {
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
        node.scale = SCNVector3Make(0.15, 0.15, 0.15)
        node.position = SCNVector3Make(0, -0.2, -0.8)
        
        let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3Make(0, 1, 0), duration: 3))
        node.runAction(rotate)

        sceneView.scene.rootNode.addChildNode(node)
    }
    
   
    @IBAction func playTapped(_ sender: Any) {
        //        anchorplane.notifications.runplane.post()
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
//            if let error = error {
//                assert(success, "removeItemAtPath error: \(error)")
//            }
        }

        let finalPathURL = URL(fileURLWithPath: finalPath)
        do {
            try fileManager.moveItem(at: location, to: finalPathURL)
            success = true
            
            if let error = error {
                success = false
                assert(success, "moveItemAtURL error: \(error)")
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
            if totalFilesDownloaded == 2 {
                loadObjectToScene()
            }

        }
    }
    
}

extension ViewController: ARCoachingOverlayViewDelegate {
//    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        upperControlsView.isHidden = true
//    }
//
//    /// - Tag: PresentUI
//    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        upperControlsView.isHidden = false
//    }
//
//    /// - Tag: StartOver
//    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
//        restartExperience()
//    }

}
