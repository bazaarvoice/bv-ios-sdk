//
//  LocationSettings.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import MapKit
import FontAwesomeKit

class LocationSettings: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    private var storeLocations : [StoreLocation] = []
    private var defaultStore : StoreLocation?
    
    private var locationPickerView : LocationPickerView?
    
    private var deviceLocation : CLLocationCoordinate2D!
    
    private var locationManager : CLLocationManager?
    
    private var didRefreshUIOnLocationUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Available Locations"
        
        self.storeLocations = LocationPreferenceUtils.storeLocations!
        self.defaultStore = LocationPreferenceUtils.getDefaultStore()
    
        if defaultStore != nil {
            // remove default store from storeLocations array
            var count = 0
            for store in storeLocations {
                if store.storeId == defaultStore?.storeId{
                    self.storeLocations.removeAtIndex(count)
                    break
                }
                count += 1
            }
            
        }
        
        self.setUpLocationPicker()
        self.initLocation()
        
    }

    private func initLocation(){
        
        deviceLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways ||
            CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.requestAlwaysAuthorization()
            locationManager?.startUpdatingLocation()
            
        }
        
    }
    
    private func zoomMapTooLocation(location : CLLocationCoordinate2D){
        
        // Change map to zoom in on selected store
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude-0.015, location.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.locationPickerView!.mapView.setRegion(region, animated: true)
        
    }
    
    private func setUpLocationPicker(){
        
        self.locationPickerView = LocationPickerView(frame: self.view.bounds)
        self.view.addSubview(self.locationPickerView!)
        
        self.locationPickerView!.tableViewDataSource = self
        self.locationPickerView!.tableViewDelegate = self
        self.locationPickerView!.mapViewDelegate = self
        
        // Optional parameters
        self.locationPickerView!.delegate = self
        self.locationPickerView!.shouldAutoCenterOnUserLocation = true
        self.locationPickerView!.shouldCreateHideMapButton = true
        self.locationPickerView!.pullToExpandMapEnabled = true
        self.locationPickerView!.defaultMapHeight = 220.0          // larger than normal
        self.locationPickerView!.parallaxScrollFactor = 0.3        // little slower than normal.
        
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var store : StoreLocation!
        
        switch indexPath.section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            store = self.defaultStore!
        case LocationSettingsSections.OtherLocations.rawValue:
            store = self.storeLocations[indexPath.row]
        default:
            print("Error setting store for selected section! You're gonna crash!")
        }
        
        // Change map to zoom in on selected store
        self.zoomMapTooLocation(CLLocationCoordinate2D(latitude: Double(store.latitude)!, longitude: Double(store.longitude)!))
        
        // Reset check icons for all visible cells
        let visibleRows = self.locationPickerView?.tableView.indexPathsForVisibleRows
        for currIndexPath in visibleRows! {
            let cell = self.locationPickerView?.tableView.cellForRowAtIndexPath(currIndexPath) as! StoreLocationTableViewCell
            cell.setCheckOff()
        }
        
        // Set the cell tapped to the current cell (i.e. you can't tap a cell to turn the default off
        // you have to select another cell
        let cell = self.locationPickerView?.tableView.cellForRowAtIndexPath(indexPath) as! StoreLocationTableViewCell
        LocationPreferenceUtils.setDefaultStore(store)
        cell.setCheckOn()
            
        return
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            return self.defaultStore == nil ? 0 : 1
        case LocationSettingsSections.OtherLocations.rawValue:
            return storeLocations.count
        default:
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            return self.defaultStore == nil ? "" : "MY CURRENT STORE"
        case LocationSettingsSections.OtherLocations.rawValue:
            return "OTHER STORES"
        default:
            return ""
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = ""
        
        switch section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            title = "MY CURRENT STORE"
        case LocationSettingsSections.OtherLocations.rawValue:
            title = "OTHER STORES"
        default:
            title = ""
        }

        let frame = CGRectMake(0, 0, tableView.bounds.width, 22)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        
        let labelFrame = CGRectMake(8, 8, tableView.bounds.width, 22)
        let titleLabel = UILabel(frame: labelFrame)
        titleLabel.text = title
        titleLabel.textColor = UIColor.lightGrayColor()
        view.addSubview(titleLabel)
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.defaultStore == nil ? 0 : 11
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame = CGRectMake(0, 0, tableView.bounds.width, 11)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreLocationTableViewCell") as! StoreLocationTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        switch indexPath.section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            cell.storeLocation = defaultStore
            cell.setCheckOn()
            break
            
        case LocationSettingsSections.OtherLocations.rawValue:
            let store = self.storeLocations[indexPath.row]
            cell.storeLocation = store
            
            if LocationPreferenceUtils.isDefaultStore(store) {
                cell.setCheckOn()
            }
            
            break
       
        default:
            break
            
        }
        
        return cell
    }
    
    // MARK: LocationPickerViewDelegate
    
    func locationPicker(locationPicker: LocationPickerView!, tableViewDidLoad tableView: UITableView!) {
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nibConversationsCell = UINib(nibName: "StoreLocationTableViewCell", bundle: nil)
        self.locationPickerView?.tableView.registerNib(nibConversationsCell, forCellReuseIdentifier: "StoreLocationTableViewCell")
        
    }
    
    
    func locationPicker(locationPicker: LocationPickerView!, mapViewDidLoad mapView: MKMapView!) {
        
        mapView.showsUserLocation = true;
        locationPickerView!.mapView.showsUserLocation = true
        
        for store in self.storeLocations {
            
            // Drop a pin
            
            mapView.addAnnotation(makePinForStore(store))
            
        }
        
        if (self.defaultStore != nil) {
            mapView.addAnnotation(makePinForStore(self.defaultStore!))
            self.zoomMapTooLocation(CLLocationCoordinate2DMake(Double(defaultStore!.latitude)!, Double(defaultStore!.longitude)!))
        }
        
    }
    
    func makePinForStore(store : StoreLocation) -> MKPointAnnotation{
        
        let location = CLLocationCoordinate2DMake(Double(store.latitude)!, Double(store.longitude)!)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = store.storeName
        dropPin.subtitle = store.storeAddress
        return dropPin
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        
        // Add a bike/pin to the map
        let annotationReuseId = "Place"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView!.annotation = annotation
        }
        
        anView!.image = UIImage(named: "bike_map_pin")
        anView!.backgroundColor = UIColor.clearColor()
        anView!.canShowCallout = true
        return anView
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        deviceLocation = CLLocationCoordinate2D(latitude: (locationManager!.location?.coordinate.latitude)!, longitude: (locationManager!.location?.coordinate.longitude)!)
        
        // Only refresh the distances to stores the first time we get the location update, then ignore
        if didRefreshUIOnLocationUpdate { return }
        didRefreshUIOnLocationUpdate = true
        
        if (self.defaultStore != nil) {
            // calculate store distance for the default store
            let deviceCLLocation = CLLocation(latitude: deviceLocation.latitude, longitude: deviceLocation.longitude)
            let storeCLLocation = defaultStore!.getLocation()
            let storeDistance = LocationPreferenceUtils.distanceInMilesFromLocation(deviceCLLocation, locationB: storeCLLocation)
            self.defaultStore?.distainceInMilesFromCurrentLocation = storeDistance
        }
        
        var i = 0
        for store in self.storeLocations {
            // calculate the store distances for the other stores
            let deviceCLLocation = CLLocation(latitude: deviceLocation.latitude, longitude: deviceLocation.longitude)
            let storeCLLocation = store.getLocation()
            let storeDistance = LocationPreferenceUtils.distanceInMilesFromLocation(deviceCLLocation, locationB: storeCLLocation)
            self.storeLocations[i].distainceInMilesFromCurrentLocation = storeDistance
            i += 1
            
        }
        
        // sort the cells based on distance, ASC, then refresh the data
        self.storeLocations.sortInPlace({$0.distainceInMilesFromCurrentLocation < $1.distainceInMilesFromCurrentLocation})
        self.locationPickerView?.tableView.reloadData()
        
    }
}

enum LocationSettingsSections : Int {
    
    case DefaultLocation = 0, OtherLocations
    
}
