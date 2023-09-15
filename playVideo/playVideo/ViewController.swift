//
//  ViewController.swift
//  playVideo
//
//  Created by Mykyta Popov on 15/09/2023.
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
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
		
		addGestureRecognizers()
    }
	
	private func addGestureRecognizers() {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
		sceneView.addGestureRecognizer(gesture)
	}
	
	@objc private func tap(_ sender: UITapGestureRecognizer) {
		guard let currentFrame = sceneView.session.currentFrame else { return }
		
		let videoNode = SKVideoNode(fileNamed: "big_buck_bunny.mp4")
		videoNode.play()
		
		let skScene = SKScene(size: CGSize(width: 640, height: 480))
		skScene.addChild(videoNode)
		
		videoNode.position = CGPoint(x: skScene.size.width / 2,
									 y: skScene.size.height / 2)
		videoNode.size = skScene.size
		
		let tvPlane = SCNPlane(width: 1.0, height: 0.75)
		tvPlane.firstMaterial?.diffuse.contents = skScene
		tvPlane.firstMaterial?.isDoubleSided = true
		
		let tvPlaneNode = SCNNode(geometry: tvPlane)
		
		var translation = matrix_identity_float4x4
		translation.columns.3.z = -2.0
		
		tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
		tvPlaneNode.eulerAngles = SCNVector3(Double.pi, 0, 0)
		
		sceneView.scene.rootNode.addChildNode(tvPlaneNode)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
