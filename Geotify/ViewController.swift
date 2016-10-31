//
//  ViewController.swift
//  Geotify
//
//  Created by William Breen on 10/19/16.
//  Copyright © 2016 William Breen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var viewController: ViewController? = nil
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        
        self.mapView.delegate = self
        
        let geotifications = GeotificationsDB.instance.getGeotifications()
        for geotification in geotifications {
            addToMap(geotification: geotification)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    @IBAction func zoomToCurrentLocation(_ sender: UIBarButtonItem) {
        mapView.zoomToUserLocation()
    }
    
    //need a reference to be able to update the mapView
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addGeotificationViewController = navigationController.viewControllers.first as! AddGeotificationTableViewController
        addGeotificationViewController.viewController = self
    }

    func addToMap(geotification: Geotification){
        //drop the pin
        mapView.addAnnotation(geotification)
        
        //add radius circle
        mapView.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let removeButton = UIButton(type: .custom)
        removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        removeButton.setImage(UIImage(named: "Delete")!, for: .normal)
        view.leftCalloutAccessoryView = removeButton
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //remove the pin
        let geotification = view.annotation as! Geotification
        mapView.removeAnnotation(view.annotation!)
        
        //remove the matching overlay
        let overlays = mapView.overlays
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else {continue}
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius { mapView.remove(circleOverlay)
                break
        }
    }
        
    GeotificationsDB.instance.deleteGeotification(aId: geotification.id!)
        
    // stop monitoting this geofence
    for region in locationManager.monitoredRegions {
        guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == String(describing: geotification.note) else {continue}
        locationManager.stopMonitoring(for: circularRegion)
    }
}

}


