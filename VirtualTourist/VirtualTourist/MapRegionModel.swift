//
//  MapRegionModel.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import MapKit

struct MapRegion {
    var latitude: Double
    var longitude: Double
    var latitudeDelta: Double
    var longitudeDelta: Double
    
    init() {
        self.latitude = 37.132839
        self.longitude = -95.785579
        self.latitudeDelta = 76.065168
        self.longitudeDelta = 61.276014
    }
    
    init(from dictionary: [String: Double]) {
        if let lat = dictionary["latitude"] {
            self.latitude = lat
        } else {
            self.latitude = 37.132839
        }
        if let lon = dictionary["longitude"] {
            self.longitude = lon
        } else {
            self.longitude = -95.785579
        }
        if let latDelta = dictionary["latitudeDelta"] {
            self.latitudeDelta = latDelta
        } else {
            self.latitudeDelta = 76.065168
        }
        if let lonDelta = dictionary["longitudeDelta"] {
            self.longitudeDelta = lonDelta
        } else {
            self.longitudeDelta = 61.276014
        }
    }
    
    func makeMapRegion(_ mapRegion: MapRegion) -> MKCoordinateRegion {
        let latitude: CLLocationDegrees = mapRegion.latitude
        let longitude: CLLocationDegrees = mapRegion.longitude
        let latDelta: CLLocationDegrees = mapRegion.latitudeDelta
        let lonDelta: CLLocationDegrees = mapRegion.longitudeDelta
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        return region
    }
}
