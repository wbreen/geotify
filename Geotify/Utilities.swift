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
