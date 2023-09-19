//
//  ViewController.swift
//  interactionWithARObjects
//
//  Created by Mykyta Popov on 18/09/2023.
//

import UIKit
import SceneKit
import ARKit
import MBProgressHUD

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.label.text = "Detecting plane"
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func registerGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(tap))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func tap(_ recognizer: UITapGestureRecognizer) {
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        
        guard let hitTestResult = hitTestResults.first,
                let chairScene = SCNScene(named: "chair.dae"),
                let chairNode = chairScene.rootNode.childNode(withName: "chair",
                                                      recursively: true)  else { return }
        let column = hitTestResult.worldTransform.columns.3
        chairNode.position = SCNVector3(column.x, column.y, column.z)
        
        self.sceneView.scene.rootNode.addChildNode(chairNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async {
                self.hud?.label.text = "Plane detected!"
                self.hud?.hide(animated: true, afterDelay: 1)
            }
        }
    }
}
