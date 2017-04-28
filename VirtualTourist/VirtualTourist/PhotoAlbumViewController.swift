//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Ginny Pennekamp on 4/28/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import SystemConfiguration

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionButton: UIButton!
    
    // MARK: - Properties
    
    var pin: Pin!
    
    // API call
    var flickrClient = FlickrClient()
    
    // fetched results controller
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController<FlickrPhoto> = { () -> NSFetchedResultsController<FlickrPhoto> in
        let fetchRequest = NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var selectedIndexes = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
    // activity indicator
    var activityIndicator: UIActivityIndicatorView!
    
    var isEditingPhotoAlbum: Bool = false
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add activity indicator
        addActivityIndicator()
        // set up custom flow
        fitCollectionFlowToSize(self.view.frame.size)
        
        // create map
        createMap()
        
        // start the fetched results controller
        do {
            try fetchedResultsController.performFetch()
            // if empty, download images
            if self.fetchedResultsController.fetchedObjects?.count == 0 {
                fetchImages()
            }
        } catch {
            print("Error performing initial fetch")
        }
    }
    
    // MARK: - Configure Collection Button
    
    func configureButton() {
        if isEditingPhotoAlbum {
            collectionButton.setTitle("Remove Selected Pictures",for: .normal)
        } else {
            collectionButton.setTitle("New Collection",for: .normal)
        }
    }
    
    // MARK: - Create Map
    
    func createMap() {
        // set region
        let latitude: CLLocationDegrees = pin.latitude
        let longitude: CLLocationDegrees = pin.longitude
        let latDelta: CLLocationDegrees = 0.25
        let lonDelta: CLLocationDegrees = 0.25
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    func configureCell(_ cell: PhotoViewCell, atIndexPath indexPath: IndexPath) {
        // If the cell is "selected", it is grayed out, or marked for deletion
        if let _ = selectedIndexes.index(of: indexPath) {
            cell.imageView.alpha = 0.5
            self.isEditingPhotoAlbum = true
        } else {
            cell.imageView.alpha = 1.0
            self.isEditingPhotoAlbum = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
        
        if self.fetchedResultsController.fetchedObjects?.count != 0 {
            let flickrPhoto = self.fetchedResultsController.object(at: indexPath) as FlickrPhoto
            if flickrPhoto.imageData != nil {
                // make an image from the core data store
                let photo = UIImage(data: flickrPhoto.imageData! as Data)
                cell.update(with: photo)
            } else {
                // download and store the image
                flickrClient.fetchImage(for: flickrPhoto) { (data: Data?) -> Void in
                    print("6. Fetching image data for photo...")
                    // return on main thread
                    guard let imageData = data, let image = UIImage(data: imageData) else {
                        print("Image data could not be extracted")
                        return
                    }
                    let photoIndexPath = IndexPath(item: indexPath.row, section: 0)
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                        as? PhotoViewCell {
                        cell.update(with: image)
                        print("7. displaying photo")
                    }
                }
            }
        }
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in collectionView(_:didSelectItemAtIndexPath)")
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
        
        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
        if let index = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: index)
        } else {
            selectedIndexes.append(indexPath)
        }
        // Then reconfigure the cell
        configureCell(cell, atIndexPath: indexPath)
        configureButton()
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
        
        print("in controllerWillChangeContent")
    }
    
    // The method may be called multiple times, once for each object added, deleted, or changed.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            print("Insert an item")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            print("Delete an item")
            deletedIndexPaths.append(indexPath!)
            break
        case .update:
            print("Update an item.")
            updatedIndexPaths.append(indexPath!)
            break
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
            //default:
            //break
        }
    }
    
    // This method is invoked after all of the changed objects in the current batch have been collected
    // into the three index path arrays (insert, delete, and upate). We now need to loop through the
    // arrays and perform the changes.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
        
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
    
    // MARK: - Fetch Images from Flickr
    
    func fetchImages() {
        activityIndicator.startAnimating()
        collectionButton.isEnabled = false
        
        print("1. Starting request for photos...")
        
        flickrClient.fetchImagesWithLatitudeAndLongitude(latitude: pin.latitude, longitude: pin.longitude) { (data: AnyObject?, error: NSError?) -> Void in
            // returned from JSON parsing on main thread
            
            if error != nil {
                print("There was an error getting the images: \(String(describing: error))")
                self.activityIndicator.stopAnimating()
                if isInternetAvailable() == false {
                    Alerts.displayInternetConnectionAlert(from: self)
                } else {
                    Alerts.displayStandardAlert(from: self)
                }
                self.collectionButton.isEnabled = true
            } else {
                guard let data = data else {
                    print("No data was returned.")
                    return
                }
                let photoURLs = self.flickrClient.extractAllPhotoURLStrings(fromJSONDictionary: data)
                
                if !photoURLs.isEmpty {
                    print("5. There were \(photoURLs.count) photos returned.")
                    for url in photoURLs {
                        self.delegate.stack.addFlickrPhotoToDatabase(urlString: url, fetchedResultsController: self.fetchedResultsController)
                        self.activityIndicator.stopAnimating()
                        self.collectionButton.isEnabled = true
                    }
                } else {
                    print("No photos were returned.")
                    self.activityIndicator.stopAnimating()
                    self.collectionButton.isEnabled = true
                }
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    // MARK: - Remove Selected Photos
    
    func deleteAllFlickrPhotos() {
        for photo in self.fetchedResultsController.fetchedObjects! {
            delegate.stack.context.delete(photo)
        }
    }
    
    func deleteSelectedFlickrPhotos() {
        var photosToDelete: [FlickrPhoto] = []
        for indexPath in selectedIndexes {
            photosToDelete.append(fetchedResultsController.object(at: indexPath))
        }
        for photo in photosToDelete {
            delegate.stack.context.delete(photo)
        }
        selectedIndexes = [IndexPath]()
    }
    
    // MARK: - Import New Photos or Delete
    
    @IBAction func importNewPhotos(_ sender: Any) {
        print("Button pressed.")
        
        collectionButton.isEnabled = false
        
        if isEditingPhotoAlbum {
            // delete selected photos
            deleteSelectedFlickrPhotos()
            isEditingPhotoAlbum = false
            collectionButton.isEnabled = true
        } else {
            // delete all photos and fetch new
            deleteAllFlickrPhotos()
            fetchImages()
        }
        
        configureButton()
        
        do {
            try delegate.stack.saveContext()
        } catch {
            print("New collection changes could not be saved.")
        }
    }
    
}
