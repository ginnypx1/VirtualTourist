//
//  FlickrPhoto+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import CoreData


public class FlickrPhoto: NSManagedObject {

    convenience init(urlString: String, imageData: Data? = nil, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "FlickrPhoto", in: context) {
            self.init(entity: ent, insertInto: context)
            self.urlString = urlString
            self.imageData = imageData as NSData?
        } else {
            fatalError("Unable to find FlickrPhoto Entity!")
        }
    }
}
