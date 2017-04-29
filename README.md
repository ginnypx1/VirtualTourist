# Virtual Tourist

"Virtual Tourist" :earth_americas: :camera: is an iOS application developed as part of the Udacity iOS Development Nanodegree program. It uses MapKit, URLSession networking, JSON Serialization, Reachability, the Flickr API, and UICollectionViews to allow the user to pin any location in the world and save an album of photos from that location.

## Install

To check out my version of "Virtual Tourist":

1. Clone or download my repository:
` $ https://github.com/ginnypx1/VirtualTourist.git `

2. Enter the "Virtual Tourist" directory:
` $ cd /VirtualTourist-master/ `

3. Open "Virtual Tourist" in XCode:
` $ open VirtualTourist.xcodeproj `

## Instructions

The "Virtual Tourist" user will first be presented with a map. They can zoom in or move to anywhere in the world, and add a location with a long press.

Once the user taps on the pin for this location, they will be taken to a second view, showing them both a map of that location, and recent images taken at that location from Flickr. A user can then tap any photo to remove it from the collection, and the photo will be replaced by a new one from Flickr. Once the user is done editing their photo album, they can simply hit the **<** button to return to the map view and add more locations.

A user can delete any locations by tapping on the **Edit** button in the top-right hand corner of the map view.

## Technical Information

"Virtual Tourist" uses the Flicker API to collect the photos, Core Data to store the information about the pins and the photo albums, and User Defaults to store information about the user's map view preferences.
