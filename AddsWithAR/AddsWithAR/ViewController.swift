//
//  ViewController.swift
//  AddsWithAR
//
//  Created by Mykyta Popov on 16/10/2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARImageAnchor {
            guard let phoneScene = SCNScene(named: "Phone_01.scn"),
                  let phoneNode = phoneScene.rootNode.childNode(withName: "parentNode", recursively: true) else {
                fatalError("scene not found")
            }
            let columns = anchor.transform.columns.3
            phoneNode.position = SCNVector3(columns.x, columns.y, columns.z)
            sceneView.scene.rootNode.addChildNode(phoneNode)
            
            let rotationAction = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1)
            let action = SCNAction.repeatForever(rotationAction)
            phoneNode.runAction(action)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        guard let refImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources",
                                                               bundle: nil) else { fatalError() }
        configuration.detectionImages = refImages
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
