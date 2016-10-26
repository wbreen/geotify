//
//  Geotification.swift
//  Geotify
//
//  Created by William Breen on 10/26/16.
//  Copyright © 2016 William Breen. All rights reserved.
//

import CoreLocation
import MapKit

class Geotification: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var note: String
    var onEntry: Bool
    
    var title: String? {
        if note.isEmpty {
            return "noNote"
        }
        return note
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, note: String, onEntry: Bool){
        self.coordinate = coordinate
        self.radius = radius
        self.note = note
        self.onEntry = onEntry
    }
    
    func region() -> CLCircularRegion {
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: String(describing: note))
        region.notifyOnEntry = onEntry
        region.notifyOnExit = !onEntry
        return region
    }
}
