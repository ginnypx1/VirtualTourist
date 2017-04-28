//
//  FlickrConvienence.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient {
    
    // MARK: - Parse JSON Data
    
    func parseJSONDataWithCompletionHandler(_ data: Data, completionHandlerForData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        print("3. Parsing JSON...")
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForData(nil, NSError(domain: "parseJSONDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        OperationQueue.main.addOperation {
            completionHandlerForData(parsedResult, nil)
        }
    }
    
    // MARK: - Extract All Photos from JSON
    
    func extractAllPhotoURLStrings(fromJSONDictionary jsonDictionary: AnyObject) -> [String] {
        print("4. Extracting list of all photos from JSON")
        
        var allPhotoStrings = [String]()
        
        guard let photos = jsonDictionary[FlickrRequest.FlickrResponseKeys.Photos] as? [String: Any],
            let photosArray = photos[FlickrRequest.FlickrResponseKeys.Photo] as? [[String: Any]] else {
                print("The proper keys are not in the provided JSON array.")
                return []
        }
        
        for photoDict in photosArray {
            if let photoURLString = photoDict["url_m"] as? String {
                allPhotoStrings.append(photoURLString)
            }
        }
        return allPhotoStrings
    }
    
}
