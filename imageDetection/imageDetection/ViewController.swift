//
//  ViewController.swift
//  imageDetection
//
//  Created by Mykyta Popov on 15/09/2023.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
			fatalError("images not found")
		}
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
		configuration.detectionImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		if let imageAnchor = anchor as? ARImageAnchor, let name = imageAnchor.referenceImage.name {
			DispatchQueue.main.async {
				self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
				self.hud?.label.text = name
				self.hud?.hide(animated: true, afterDelay: 1)
				debugPrint(name)
			}
		}
	}
}
