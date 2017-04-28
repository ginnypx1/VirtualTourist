//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinLabel: UILabel!
    
    // MARK: - Properties
    
    var mapIsEditing: Bool = false
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create Edit button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMap))
        // hide deletePinLabel
        deletePinLabel.isHidden = true
        
        // allow user to add an annotation with long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(gesture:)))
        longPress.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPress)
        
        // retrieve saved map region
        retrieveSavedMapRegion()
        // retrieve map pins
        retrieveMapPins()
        
    }
    
    // MARK: - Retrieve Pins and Set Map
    
    func retrieveMapPins() {
        // Create a fetchrequest
        let pinFetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        do {
            // fetch pins
            let allPins = try self.delegate.stack.context.fetch(pinFetchRequest)
            // add pins to map
            print("All Pins count: \(allPins.count)")
            for pin in allPins {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                mapView.addAnnotation(annotation)
            }
        } catch {
            fatalError("Failed to fetch pins: \(error)")
        }
    }
    
    func addPinToDatabase(latitude: Double, longitude: Double) {
        let newPin = Pin(latitude: latitude, longitude: longitude, context: self.delegate.stack.context)
        print("Created new pin: \(String(describing: newPin))")
    }
    
    
    // MARK: - Drop Pin
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            // save new pin into database
            self.addPinToDatabase(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            // create new map annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - Select Pin
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // grab the pin
        guard let annotation = view.annotation else {
            print("No annotation could be found")
            return
        }
        
        // extract the latitude and longitude
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        
        // segue to PhotoAlbum, or delete pin based on editing state
        if mapIsEditing {
            // find the pin at this location
            let pinFetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
            let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", argumentArray: [annotation.coordinate.latitude, annotation.coordinate.longitude])
            pinFetchRequest.predicate = predicate
            // delete the pin in the stack and on the map
            do {
                let selectedPin = try self.context.fetch(pinFetchRequest)
                self.delegate.stack.context.delete(selectedPin[0])
                print("Pin Deleted: \(selectedPin)")
                self.mapView.removeAnnotation(annotation)
            } catch {
                print("The selected pin could not be retrieved.")
            }
        } else {
            print("Will segue to photo album for pin: \(latitude), \(longitude)")
            // TODO: Segue to photoAlbum view, already init API call
        }
        
        // allow the user to tap on the same pin next time
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    // MARK: - Grab Map Region
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // retrive map region info from view
        let latitude = mapView.region.center.latitude
        let longitude = mapView.region.center.longitude
        let latitudeDelta = mapView.region.span.latitudeDelta
        let longitudeDelta = mapView.region.span.longitudeDelta
        
        // save this region info into userDefaults
        let regionDictionary: [String:Double] = ["latitude": latitude, "longitude": longitude, "latitudeDelta": latitudeDelta, "longitudeDelta": longitudeDelta]
        UserDefaults.standard.set(regionDictionary, forKey: "region")
    }
    
    // MARK: - Set Region
    
    func retrieveSavedMapRegion() {
        var mapRegion = MapRegion()
        // retrieve region from user defaults
        if let savedRegion = UserDefaults.standard.object(forKey: "region") as? [String: Double] {
            mapRegion = MapRegion(from: savedRegion)
        }
        let region = mapRegion.makeMapRegion(mapRegion)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Edit Map
    
    func editMap(_ sender: UIBarButtonItem) {
        if mapIsEditing {
            sender.title = "Edit"
            deletePinLabel.isHidden = true
            mapIsEditing = false
        } else {
            sender.title = "Done"
            deletePinLabel.isHidden = false
            mapIsEditing = true
        }
    }
}

