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
		getLocalPlaces()
    }
	
	private func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	
	private func getLocalPlaces() {
		guard let location = locationManager.location?.coordinate else { return }
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = place
		
		var region = MKCoordinateRegion()
		region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
		request.region = region
		
		let search = MKLocalSearch(request: request)
		search.start { response, error in
			if let error = error {
				debugPrint(error.localizedDescription)
			} else if let response = response {
				response.mapItems.forEach {
					let placeLocation = $0.placemark.location
					debugPrint($0.placemark)
				}
			}
		}
	}
}

extension SelectedPlacesViewController: CLLocationManagerDelegate {
	
}

