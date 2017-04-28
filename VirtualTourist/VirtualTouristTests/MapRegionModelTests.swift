//
//  MapRegionModelTests.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import VirtualTourist

import MapKit

class MapRegionModelTests: XCTestCase {
    
    var sut: MapRegion!
    
    override func setUp() {
        super.setUp()
        sut = MapRegion()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_MapRegion_HasLatitude() {
        XCTAssertNotNil(sut.latitude)
    }
    
    func test_MapRegion_HasLongitude() {
        XCTAssertNotNil(sut.longitude)
    }
    
    func test_MapRegion_HasLatitudeDelta() {
        XCTAssertNotNil(sut.latitudeDelta)
    }
    
    func test_MapRegion_HasLongitudeDelta() {
        XCTAssertNotNil(sut.longitudeDelta)
    }
    
    func test_MapRegion_HasExpectedDefaultLatitude() {
        let expectedLatitude = 37.132839
        XCTAssertEqual(sut.latitude, expectedLatitude)
    }
    
    func test_MapRegion_HasExpectedDefaultLongitude() {
        let expectedLongitude = -95.785579
        XCTAssertEqual(sut.longitude, expectedLongitude)
    }
    
    func test_MapRegion_HasExpectedDefaultLatitudeDelta() {
        let expectedLatitudeDelta = 76.065168
        XCTAssertEqual(sut.latitudeDelta, expectedLatitudeDelta)
    }
    
    func test_MapRegion_HasExpectedDefaultLongitudeDelta() {
        let expectedLongitudeDelta = 61.276014
        XCTAssertEqual(sut.longitudeDelta, expectedLongitudeDelta)
    }
    
    func test_MapRegion_InitFromDictionary_CreatesExpectedMapRegion() {
        let testDictionary = ["latitude": 37.132839, "longitude": -95.785579, "latitudeDelta": 76.065168, "longitudeDelta": 61.276014]
        let testMapRegion = MapRegion(from: testDictionary)
        XCTAssertEqual(sut.latitude, testMapRegion.latitude)
        XCTAssertEqual(sut.longitude, testMapRegion.longitude)
        XCTAssertEqual(sut.latitudeDelta, testMapRegion.latitudeDelta)
        XCTAssertEqual(sut.longitudeDelta, testMapRegion.longitudeDelta)
    }
    
    func test_MapRegion_SetMapRegion_SetsExpectedMapRegion() {
        let latitude: CLLocationDegrees = 37.132839
        let longitude: CLLocationDegrees = -95.785579
        let latDelta: CLLocationDegrees = 76.065168
        let lonDelta: CLLocationDegrees = 61.276014
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let expectedRegion: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let testRegion = sut.makeMapRegion(sut)
        
        XCTAssertEqual(testRegion.center.latitude, expectedRegion.center.latitude)
        XCTAssertEqual(testRegion.center.longitude, expectedRegion.center.longitude)
        XCTAssertEqual(testRegion.span.latitudeDelta, expectedRegion.span.latitudeDelta)
        XCTAssertEqual(testRegion.span.longitudeDelta, expectedRegion.span.longitudeDelta)
    }
    
}
