//
//  ViewController.swift
//  NearMeApp(CoreLocation+ARKit)
//
//  Created by Mykyta Popov on 04/09/2023.
//

import UIKit
import CoreLocation
import MapKit

class SelectedPlacesViewController: UIViewController {
    
    var place: String!
	lazy private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = place
		setupLocationManager()
    }
	
	private func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		debugPrint(locationManager.location?.coordinate)
	}
}

extension SelectedPlacesViewController: CLLocationManagerDelegate {
	
}

