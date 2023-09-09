//
//  ViewController.swift
//  NearMeApp(CoreLocation+ARKit)
//
//  Created by Mykyta Popov on 04/09/2023.
//

import UIKit
import CoreLocation
import MapKit
import ARKit_CoreLocation

class SelectedPlacesViewController: UIViewController {
    
    var place: String!
	lazy private var locationManager = CLLocationManager()
	private let sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = place
		
		setupLocationManager()
		setupSceneLocationView()
		getLocalPlaces()
    }
	
	private func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	
	private func setupSceneLocationView() {
		sceneLocationView.run()
		view.addSubview(sceneLocationView)
		sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			sceneLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			sceneLocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			sceneLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sceneLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
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
					let image = UIImage(named: "pin") ?? UIImage()
					let annotationNode = LocationAnnotationNode(location: placeLocation, image: image)
					annotationNode.scaleRelativeToDistance = false
					DispatchQueue.main.async {
						self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
					}
				}
			}
		}
	}
}

extension SelectedPlacesViewController: CLLocationManagerDelegate {
	
}

