//
//  ViewController.swift
//  CurationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import CoreLocation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var curationsCollectionView: BVCurationsCollectionView!
    
    var curationsFeedItems:[BVCurationsFeedItem]?
    
    var locationManager: CLLocationManager!
    var hasRequestedCurations = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.curationsCollectionView.registerNib(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCell")
        
        self.curationsCollectionView.delegate = self
        self.curationsCollectionView.dataSource = self
        
        // create a location manager to get the user's current location, to personalize their curations content based on location
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = (curationsCollectionView.collectionViewLayout) as! UICollectionViewFlowLayout
        
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSizeMake(curationsCollectionView.bounds.size.width / 2, curationsCollectionView.bounds.size.width / 2)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    func fetchCurationsWithLocation(location: CLLocation?) {
        
        // only request curations content once for this demo view controller.
        if hasRequestedCurations == false {
            hasRequestedCurations = true
        }
        else {
            return;
        }
        
        let groups = ["__all__"]
        let feedRequest = BVCurationsFeedRequest(groups: groups)
        feedRequest.limit = 40
        feedRequest.hasPhoto = true
        feedRequest.withProductData = true
        
        // request curations data, taking the user's location into account
        if let locationObject = location {
            feedRequest.setLatitude(locationObject.coordinate.latitude, longitude: locationObject.coordinate.longitude)
        }
        
        self.curationsCollectionView.loadFeedWithRequest(feedRequest, withWidgetId: nil, completionHandler: { (feedItems) -> Void in
            // success
            // closure from request returned on main thread
            
            self.curationsFeedItems = feedItems as [BVCurationsFeedItem]
            self.curationsCollectionView.reloadData()
            
        }) { (error) -> Void in
            // error
            
            print("ERROR: Curations feed could not be retrieved. Error: " + error.localizedDescription)
        }
        
    }
    
    // MARK: UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.curationsFeedItems?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCell", forIndexPath: indexPath) as! DemoCollectionViewCell
        
        let feedItem : BVCurationsFeedItem = self.curationsFeedItems![indexPath.row]
        
        cell.feedItem = feedItem
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let feedItem : BVCurationsFeedItem = curationsFeedItems![indexPath.row]
        
        print("Selected: " + feedItem.description)
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
        if locations.count > 0 {
            let location:CLLocation = locations[locations.count-1] as CLLocation
            
            // Fetching curations data, using user's location
            self.fetchCurationsWithLocation(location)
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("error: \(error)")
    
        // Fetching curations data without user's location
        self.fetchCurationsWithLocation(nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        else if status == .Denied || status == .Restricted {
            // Fetching curations data without user's location, because we don't have location permission
            self.fetchCurationsWithLocation(nil)
        }
        
    }
}