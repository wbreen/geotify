//
//  Utilities.swift
//  Geotify
//
//  Created by William Breen on 10/26/16.
//  Copyright © 2016 William Breen. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return}
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        setRegion(region, animated: true)
    }
}

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
