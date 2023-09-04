//
//  PlacesTableViewController.swift
//  NearMeApp(CoreLocation+ARKit)
//
//  Created by Mykyta Popov on 04/09/2023.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    private let places = [
        "Cofee",
        "Bars",
        "Fast food",
        "Banks",
        "Hospitals",
        "Gas station"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let place = places[indexPath.row]
        
        if let destinationViewController = segue.destination as? ViewController {
            destinationViewController.place = place
        }
    }
}
