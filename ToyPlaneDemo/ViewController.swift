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
class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let poly = Poly()
    override func viewDidLoad() {
        super.viewDidLoad()
        poly.apiKey = "AIzaSyDP06_ZC4j0Nyj6I9VcsIJUrijpg0cLQtQ"
        getObject3D()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = sceneView.session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)
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
            let thumb = assets[0].thumbnail?.url
            let assetId = assets[0].identifier ?? ""
            print(thumb)
            let urlStr = assets[0].formats?[0].resources?[0].url ?? ""
            if let url = URL(string: urlStr) {
                let asset = MDLAsset(url: url)
                print(asset)
                let object = asset.object(at: 0)
                
                let node = SCNNode.init(mdlObject: object)
                print(node)
                self.sceneView.scene.rootNode.addChildNode(node)
                
                
            }
            
        }
        
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
//        anchorplane.notifications.runplane.post()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a custom object to visualize the plane geometry and extent.
//        let plane = Plane(anchor: planeAnchor, in: sceneView)
//
//        // Add the visualization to the ARKit-managed node so that it tracks
//        // changes in the plane anchor as plane estimation continues.
//        node.addChildNode(plane)
    }
}
