//
//  AddGeotificationTableViewController.swift
//  Geotify
//
//  Created by William Breen on 10/19/16.
//  Copyright © 2016 William Breen. All rights reserved.
//

import UIKit
import MapKit

class AddGeotificationTableViewController: UITableViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var entryOrExitSegmentControl: UISegmentedControl!
    
    var viewController: ViewController? = nil
    
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func zoomToCurrentLocation(_ sender: UIBarButtonItem) {
        mapView.zoomToUserLocation()
    }

    @IBAction func addGeotification(_ sender: UIBarButtonItem) {
        guard let radius = Double(radiusTextField.text!) else{
            showAlert(withTitle: "Geotify", message: "radius is not an integer")
            return
        }
        if radius < 0.0 || radius > 100000.0 {
            showAlert(withTitle: "Geotify", message: "radius is an invalid integer")
            return
        }
        
        let note = noteTextField.text!
        if note == "" {
            showAlert(withTitle: "Geotify", message: "bad note field")
            return
        }
        
        let onEntry = (entryOrExitSegmentControl.selectedSegmentIndex == 0)
        
        let geotification = Geotification(id: 1, coordinate: mapView.centerCoordinate, radius: radius, note: note, onEntry: onEntry)
        
        //tell the main map about the new geotification
        viewController?.addToMap(geotification: geotification)
        viewController?.locationManager.startMonitoring(for: geotification.region())
        
        //add it to the database
        if let id = GeotificationsDB.instance.add(geotification: geotification) {
            geotification.id = id   //remember the id given to us
        }
        
        //clear the text fields
        radiusTextField.text = ""
        noteTextField.text = ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


}
