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
