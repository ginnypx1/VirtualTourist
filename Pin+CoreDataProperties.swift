//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Ginny Pennekamp on 4/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var flickrPhotos: NSSet?

}

// MARK: Generated accessors for flickrPhotos
extension Pin {

    @objc(addFlickrPhotosObject:)
    @NSManaged public func addToFlickrPhotos(_ value: FlickrPhoto)

    @objc(removeFlickrPhotosObject:)
    @NSManaged public func removeFromFlickrPhotos(_ value: FlickrPhoto)

    @objc(addFlickrPhotos:)
    @NSManaged public func addToFlickrPhotos(_ values: NSSet)

    @objc(removeFlickrPhotos:)
    @NSManaged public func removeFromFlickrPhotos(_ values: NSSet)

}
