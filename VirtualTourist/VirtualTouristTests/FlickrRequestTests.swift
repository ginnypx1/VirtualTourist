//
//  FlickrRequestTests.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/29/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import VirtualTourist

class FlickrRequestTests: XCTestCase {
    
    var sut: FlickrRequest!
    
    override func setUp() {
        super.setUp()
        sut = FlickrRequest()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    // MARK: - Test Properties
    
    func test_FlickrRequest_HasFlickrURL() {
        XCTAssertNotNil(FlickrRequest.FlickrURL.self)
    }
    
    func test_FlickrRequest_HasFlickrParameterKeys() {
        XCTAssertNotNil(FlickrRequest.FlickrParameterKeys.self)
    }
    
    func test_FlickrRequest_HasFlickrParameterValues() {
        XCTAssertNotNil(FlickrRequest.FlickrParameterValues.self)
    }
    
    func test_FlickrRequest_HasFlickrResponseKeys() {
        XCTAssertNotNil(FlickrRequest.FlickrResponseKeys.self)
    }
    
    func test_FlickrRequest_HasFlickrResponseValues() {
        XCTAssertNotNil(FlickrRequest.FlickrResponseValues.self)
    }
    
    // MARK: - Test Property Values
    
    func test_FlickrRequest_FlickerURL_HasExpectedScheme() {
        let expectedScheme = "https"
        XCTAssertEqual(FlickrRequest.FlickrURL.Scheme, expectedScheme)
    }
    
    func test_FlickrRequest_FlickerURL_HasExpectedHost() {
        let expectedHost = "api.flickr.com"
        XCTAssertEqual(FlickrRequest.FlickrURL.Host, expectedHost)
    }
    
    func test_FlickrRequest_FlickerURL_HasExpectedPath() {
        let expectedPath = "/services/rest"
        XCTAssertEqual(FlickrRequest.FlickrURL.Path, expectedPath)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasMethod() {
        let expectedMethod = "method"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.Method, expectedMethod)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasAPIKey() {
        let expectedAPIKey = "api_key"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.APIKey, expectedAPIKey)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasExtras() {
        let expectedExtras = "extras"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.Extras, expectedExtras)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasFormat() {
        let expectedFormat = "format"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.Format, expectedFormat)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasNoJSONCallback() {
        let expectedNoJSONCallback = "nojsoncallback"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.NoJSONCallback, expectedNoJSONCallback)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasSafeSearch() {
        let expectedSafeSearch = "safe_search"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.SafeSearch, expectedSafeSearch)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasLatitude() {
        let expectedLatitude = "lat"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.Latitude, expectedLatitude)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasLongitude() {
        let expectedLongitude = "lon"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.Longitude, expectedLongitude)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasResultsPerPage() {
        let expectedResultsPerPage = "per_page"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.ResultsPerPage, expectedResultsPerPage)
    }
    
    func test_FlickrRequest_FlickerParameterKeys_HasResultsPage() {
        let expectedResultsPage = "page"
        XCTAssertEqual(FlickrRequest.FlickrParameterKeys.ResultsPage, expectedResultsPage)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasAPIKey() {
        let expectedAPI = YOUR_API_KEY
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.APIKey, expectedAPI)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasSearchMethod() {
        let expectedSearchMethod = "flickr.photos.search"
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.SearchMethod, expectedSearchMethod)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasResponseFormat() {
        let expectedResponseFormat = "json"
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.ResponseFormat, expectedResponseFormat)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasDisableJSONCallback() {
        let expectedDisableJSONCallback = "1"
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.DisableJSONCallback, expectedDisableJSONCallback)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasMediumURL() {
        let expectedMediumURL = "url_m"
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.MediumURL, expectedMediumURL)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasUseSafeSearch() {
        let expectedUseSafeSearch = "1"
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.UseSafeSearch, expectedUseSafeSearch)
    }
    
    func test_FlickrRequest_FlickerParameterValues_HasDesiredNumberOfResults() {
        let expectedDesiredNumberOfResults = 21
        XCTAssertEqual(FlickrRequest.FlickrParameterValues.DesiredNumberOfResults, expectedDesiredNumberOfResults)
    }
    
    func test_FlickrRequest_FlickerResponseKeys_HasStatus() {
        let expectedStatus = "stat"
        XCTAssertEqual(FlickrRequest.FlickrResponseKeys.Status, expectedStatus)
    }
    
    func test_FlickrRequest_FlickerResponseKeys_HasPhotos() {
        let expectedPhotos = "photos"
        XCTAssertEqual(FlickrRequest.FlickrResponseKeys.Photos, expectedPhotos)
    }
    
    func test_FlickrRequest_FlickerResponseKeys_HasPhoto() {
        let expectedPhoto = "photo"
        XCTAssertEqual(FlickrRequest.FlickrResponseKeys.Photo, expectedPhoto)
    }
    
    func test_FlickrRequest_FlickerResponseKeys_HasMediumURL() {
        let expectedMediumURL = "url_m"
        XCTAssertEqual(FlickrRequest.FlickrResponseKeys.MediumURL, expectedMediumURL)
    }
    
    func test_FlickrRequest_FlickerResponseValues_HasOKStatus() {
        let expectedOKStatus = "ok"
        XCTAssertEqual(FlickrRequest.FlickrResponseValues.OKStatus, expectedOKStatus)
    }
    
    // MARK: - Test BuildURL
    
    func test_FlickrRequest_BuildURL_BuildsExpectedURL() {
        let methodParameters: [String: Any] = [
            FlickrRequest.FlickrParameterKeys.Latitude: 51.508118,
            FlickrRequest.FlickrParameterKeys.Longitude: -0.070831,
            FlickrRequest.FlickrParameterKeys.ResultsPage: 1]
        let requestURL = sut.buildURL(fromParameters: methodParameters)
        let expectedURLString = "https://api.flickr.com/services/rest?method=flickr.photos.search&format=json&api_key=1fe8b590a9c09e7751093b5a3aaff4cc&per_page=21&safe_search=1&extras=url_m&nojsoncallback=1&lat=51.508118&lon=-0.070831&page=1"
        let expectedURL = URL(string: expectedURLString)
        XCTAssertEqual(requestURL, expectedURL)
    }

    
}
