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
    
    // url: "https://poly.googleapis.com/v1/assets/5vbJ5vildOq?key=AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ
    let poly = Poly()
    let polyApiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
    let polyBaseUrl = "https://poly.googleapis.com/v1/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        poly.apiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
//        getObject3D()
        getObjectFromPoly()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
//        sceneView.delegate = self
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = sceneView.session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)
        coachingOverlay.center = view.center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func getObject3D() {
        poly.list(assetsWithKeywords: ["person"]) { (assets, totalCount, nextPage, error) in
            print(totalCount)
            guard let assets = assets else {
                return
            }
            if assets.count > 0 {
                let thumb = assets[0].thumbnail?.url ?? ""
                self.imgLib.sd_setImage(with: URL(string: thumb))
                let assetId = assets[0].identifier ?? ""
                print(thumb)
                let urlStr = "https://poly.googleapis.com/downloads/fp/1613512927953715/bIIkTuSZWWC/49I8Enepruo/model.obj"
                if let url = URL(string: urlStr) {
                    print("url: \(url)")
                    let mdlAsset = MDLAsset(url: url)
                    print(mdlAsset)
                    //                    let object = asset.object(at: 0)
                    
                    //                    let node = SCNNode.init(mdlObject: object)
                    //                    print(node)
                    //                    self.sceneView.scene.rootNode.addChildNode(node)
                    
                    //                    let a = MDLAsset(url: url)
                    mdlAsset.loadTextures()
                    print(mdlAsset)
                    self.sceneView.scene = SCNScene(mdlAsset: mdlAsset)
                    
                    
                }
            }
            
            
        }
        
        
    }
    
    func getObjectFromPoly() {
        poly.list(assetsWithKeywords: ["person"]) { (assets, totalCount, nextPage, error) in
            guard let assets = assets else {
                return
            }
            if assets.count > 0 {
                let assetId = assets[0].identifier
                let urlStr = "\(self.polyBaseUrl)\(assetId)?key=\(self.polyApiKey)"
                let url = URL(string: urlStr)!
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if error != nil || data == nil {
                        print("Client error!")
                        return
                    }
                    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                        print("Server error!")
                        return
                    }
                   
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [String : Any]
                        let formats = json["formats"]
                        let root = formats["root"]
                        
                        print(obj ?? "")
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
                
                task.resume()
            }
            
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        //        anchorplane.notifications.runplane.post()
    }
}

//extension ViewController: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        <#code#>
//    }
//}
