//
//  VirtualTouristSlowTests.swift
//  VirtualTouristSlowTests
//
//  Created by Ginny Pennekamp on 4/29/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import VirtualTourist

class VirtualTouristSlowTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    var urlUnderTest: FlickrRequest!
    
    override func setUp() {
        super.setUp()
        urlUnderTest = FlickrRequest()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
}
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func test_ValidCallToFlickrAPI_GetsHTTPStatusCode200() {
        let methodParameters: [String: Any] = [
            FlickrRequest.FlickrParameterKeys.Latitude: 51.508118,
            FlickrRequest.FlickrParameterKeys.Longitude: -0.070831,
            FlickrRequest.FlickrParameterKeys.ResultsPage: 1]
        let url = urlUnderTest.buildURL(fromParameters: methodParameters)
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Asynchronous test: faster fail
    func test_CallToFlickrAPI_Completes() {
        let methodParameters: [String: Any] = [
            FlickrRequest.FlickrParameterKeys.Latitude: 51.508118,
            FlickrRequest.FlickrParameterKeys.Longitude: -0.070831,
            FlickrRequest.FlickrParameterKeys.ResultsPage: 1]
        let url = urlUnderTest.buildURL(fromParameters: methodParameters)
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        let dataTask = sessionUnderTest.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
