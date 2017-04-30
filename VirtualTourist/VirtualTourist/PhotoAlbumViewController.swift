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
    @IBOutlet weak var noImagesLabel: UILabel!
    
    // MARK: - Properties
    
    var pin: Pin!
    
    var isEditingPhotoAlbum: Bool = false
    
    // API call
    var flickrClient = FlickrClient()
    
    // fetched results controller
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var fetchedResultsController: NSFetchedResultsController<FlickrPhoto> = { () -> NSFetchedResultsController<FlickrPhoto> in
        let fetchRequest = NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto")
        fetchRequest.sortDescriptors = []
        let predicate = NSPredicate(format: "pin = %@", argumentArray: [self.pin])
        fetchRequest.predicate = predicate
        
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
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide noImagesLabel
        noImagesLabel.isHidden = true
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
            print("Error performing initial fetch for album photos.")
        }
    }
    
    // MARK: - Configure Button
    
    func configureButton() {
        if isEditingPhotoAlbum {
            collectionButton.setTitle("Remove Selected Pictures", for: .normal)
        } else {
            collectionButton.setTitle("New Collection", for: .normal)
        }
    }
    
    // MARK: - Create Map
    
    func createMap() {
        // make map region
        let mapRegionDict = ["latitude": pin.latitude, "longitude": pin.longitude, "latitudeDelta": 0.25, "longitudeDelta": 0.25]
        let mapRegion = MapRegion(from: mapRegionDict)
        let region = mapRegion.makeMapRegion(mapRegion)
        mapView.setRegion(region, animated: true)
        
        // add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
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
        // if the cell is "selected", grey it out to mark it for deletion
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
                    // return on main thread
                    guard let imageData = data, let image = UIImage(data: imageData) else {
                        print("Image data could not be extracted")
                        return
                    }
                    let photoIndexPath = IndexPath(item: indexPath.row, section: 0)
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                        as? PhotoViewCell {
                        cell.update(with: image)
                    }
                }
            }
        }
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
        
        // move to selectedIndexes array
        if let index = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: index)
        } else {
            selectedIndexes.append(indexPath)
        }
        // reconfigure the cell
        configureCell(cell, atIndexPath: indexPath)
        configureButton()
    }
    
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .update:
            updatedIndexPaths.append(indexPath!)
            break
        case .move:
            print("Move an item. We don't expect to see this in this app.")
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
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
        // show activity indicator, disable NewCollection button
        activityIndicator.startAnimating()
        collectionButton.isEnabled = false

        // start flickr request
        flickrClient.fetchImagesWithLatitudeAndLongitude(latitude: pin.latitude, longitude: pin.longitude) { (data: AnyObject?, error: NSError?) -> Void in
            // returned from JSON parsing on main thread
            if error != nil {
                // stop indicator, enable button and display an alert
                print("There was an error getting the images: \(String(describing: error))")
                self.activityIndicator.stopAnimating()
                if isInternetAvailable() == false {
                    Alerts.displayInternetConnectionAlert(from: self)
                } else {
                    Alerts.displayStandardAlert(from: self)
                }
                self.collectionButton.isEnabled = true
            } else {
                // save the photo data to the pin
                guard let data = data else {
                    print("No data was returned.")
                    return
                }
                let photoURLs = self.flickrClient.extractAllPhotoURLStrings(fromJSONDictionary: data)
                
                if !photoURLs.isEmpty {
                    print("There were \(photoURLs.count) photos returned.")
                    for url in photoURLs {
                        self.delegate.stack.addFlickrPhotoToDatabase(urlString: url, pin: self.pin, fetchedResultsController: self.fetchedResultsController)
                        self.activityIndicator.stopAnimating()
                        self.collectionButton.isEnabled = true
                    }
                } else {
                    self.noImagesLabel.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.collectionButton.isEnabled = true
                }
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
            
            // save the data
            do {
                try self.delegate.stack.saveContext()
            } catch {
                print("New collection changes could not be saved.")
            }
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
        // disable button
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
        // reset button title
        configureButton()
        // save the data
        do {
            try self.delegate.stack.saveContext()
        } catch {
            print("New collection changes could not be saved.")
        }
    }
    
}
