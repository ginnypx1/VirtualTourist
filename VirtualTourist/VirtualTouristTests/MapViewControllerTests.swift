//
//  MapViewControllerTests.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import VirtualTourist

class MapViewControllerTests: XCTestCase {
    
    var sut: MapViewController!
    
    override func setUp() {
        super.setUp()
        // set up MapView, call ViewDidLoad
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        sut = storyboard
            .instantiateViewController(
                withIdentifier: "MapViewController")
            as! MapViewController
        _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test Properties
    
    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }
    
    func test_HasDeletePinLabel() {
        XCTAssertNotNil(sut.deletePinLabel)
    }
    
    func test_HasEditButton() {
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }
    
    // MARK: - Test Initial Variables
    
    func test_HasDeletePinLabel_IsInitiallyHidden() {
        XCTAssertTrue(sut.deletePinLabel.isHidden)
    }
    
    func test_mapIsEditing_IsInitiallyFalse() {
        XCTAssertFalse(sut.mapIsEditing)
    }
    
    func test_EditButton_TitleIsInitiallyEdit() {
        XCTAssertEqual("Edit", sut.navigationItem.rightBarButtonItem?.title)
    }
    
    // MARK: Test EditMap()
    
    func test_EditMap_RevealsDeletePinLabel() {
        sut.editMap(sut.navigationItem.rightBarButtonItem!)
        XCTAssertFalse(sut.deletePinLabel.isHidden)
    }
    
    func test_EditMap_ChangesEditButtonTitleToDone() {
        sut.editMap(sut.navigationItem.rightBarButtonItem!)
        XCTAssertEqual("Done", sut.navigationItem.rightBarButtonItem?.title)
    }
    
    func test_EditMap_ChangesMapIsEditingToTrue() {
        sut.editMap(sut.navigationItem.rightBarButtonItem!)
        XCTAssertTrue(sut.mapIsEditing)
    }
    
}
