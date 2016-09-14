//
//  LocationSettings.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import MapKit
import FontAwesomeKit
import BVSDK

class LocationSettings: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    private var stores : [BVStore] = []
    
    private var userDefaultStore : BVStore?
    private var initialStoreIdOnLoad : String?
    
    private let spinner = Util.createSpinner()
    
    private var locationPickerView : LocationPickerView?
    
    private var deviceLocation : CLLocationCoordinate2D!
    
    private var locationManager : CLLocationManager?
    
    private var didRefreshUIOnLocationUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Stores"
        
        self.loadStoresAsync()
        
    }

    override func viewWillDisappear(animated: Bool) {
        // If the default store changed, queue up a notification for the newly set store.
        let cachedStore = LocationPreferenceUtils.getDefaultStore()
        if userDefaultStore != nil && initialStoreIdOnLoad != nil && initialStoreIdOnLoad != cachedStore?.identifier {
            BVReviewNotificationCenter.sharedCenter().queueStoreReview(initialStoreIdOnLoad!)
        }
    }
    
    private func loadStoresAsync(){
        
        self.setUpLocationPicker()
        
        self.spinner.center = (self.locationPickerView?.center)!
        self.locationPickerView?.addSubview(self.spinner)
        
        let request = BVBulkStoreItemsRequest(20, offset: 0)
        request.includeStatistics(.Reviews)
        request.load({ (storesResponse) in
            
            // success
            self.stores = storesResponse.results
            self.userDefaultStore = self.getDefaultStore()
            self.initialStoreIdOnLoad = self.userDefaultStore?.identifier
            
            self.spinner.removeFromSuperview()
            
            if self.userDefaultStore != nil {
                // remove default store from the stores API response
                var count = 0
                for store in self.stores {
                    if store.identifier == self.userDefaultStore?.identifier{
                        self.stores.removeAtIndex(count)
                        break
                    }
                    
                    count += 1
                }
                
            }
            
            self.initLocation()
            
            if (self.locationPickerView != nil){
                self.locationPickerView?.tableView.reloadData()
                self.locationPickerView?.tableView.hidden = false
            }
            
            }) { (error) in
            
            // fail
            self.spinner.removeFromSuperview()
            SweetAlert().showAlert("Error Loading Stores!", subTitle:error.description, style: .Error)
                
            if (self.locationPickerView != nil){
                self.locationPickerView?.tableView.hidden = true
            }
        }
        
    }
    
    private func getDefaultStore() -> BVStore? {
        
        if let cachedStore = LocationPreferenceUtils.getDefaultStore() {
            var defaultStore : BVStore?
            
            for store in self.stores {
                if cachedStore.identifier == store.identifier {
                    defaultStore = store
                    break
                }
            }
            
            return defaultStore
        }
        
        return nil
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
        
        var store : BVStore!
        
        switch indexPath.section {
            case LocationSettingsSections.DefaultLocation.rawValue:
                store = self.userDefaultStore
            case LocationSettingsSections.OtherLocations.rawValue:
                store = self.stores[indexPath.row]
            default:
                print("Error setting store for selected section! You're gonna crash!")
        }
        
        // Change map to zoom in on selected store
        if (store.hasGeoLoation()){
            self.zoomMapTooLocation(CLLocationCoordinate2D(latitude: Double(store.storeLocation!.latitude!)!, longitude: Double(store.storeLocation!.longitude!)!))
        }
        // Reset check icons for all visible cells
        let visibleRows = self.locationPickerView?.tableView.indexPathsForVisibleRows
        for currIndexPath in visibleRows! {
            let cell = self.locationPickerView?.tableView.cellForRowAtIndexPath(currIndexPath) as! StoreLocationTableViewCell
            cell.setCheckOff()
        }
        
        // Set the cell tapped to the current cell (i.e. you can't tap a cell to turn the default off
        // you have to select another cell
        let cell = self.locationPickerView?.tableView.cellForRowAtIndexPath(indexPath) as! StoreLocationTableViewCell
        LocationPreferenceUtils.setDefaultStore(CachableDefaultStore(store: store))
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
            return self.userDefaultStore == nil ? 0 : 1
        case LocationSettingsSections.OtherLocations.rawValue:
            return self.stores.count
        default:
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case LocationSettingsSections.DefaultLocation.rawValue:
            return self.userDefaultStore == nil ? "" : "MY CURRENT STORE"
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
        return self.userDefaultStore == nil ? 0 : 11
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
            cell.store = self.userDefaultStore
            if LocationPreferenceUtils.isDefaultStoreId(cell.store.identifier) {
                cell.setCheckOn()
            }
            break
            
        case LocationSettingsSections.OtherLocations.rawValue:
            let currStore = self.stores[indexPath.row]
            cell.store = currStore
            
            if LocationPreferenceUtils.isDefaultStoreId(currStore.identifier) {
                cell.setCheckOn()
            }
            
            break
       
        default:
            break
            
        }
        
        // hook up the closure on the cell to check if the user taps the reviews
        // utilize closure to get the product the user tapped the "Shop Now" button on.
        cell.onNumReviewsLabelTapped = { (selectedStore) -> Void in

            let totalReviewCount : Int = selectedStore.reviewStatistics != nil ? (selectedStore.reviewStatistics?.totalReviewCount?.integerValue)! : 0
            
            let storeReviewsVC = StoreReviewsViewController(nibName: "StoreReviewsViewController", bundle: nil, store: selectedStore, totalReviewCount: totalReviewCount)
            self.navigationController?.pushViewController(storeReviewsVC, animated: true)
        
        }

        return cell
    }
    
    // MARK: LocationPickerViewDelegate
    
    func locationPicker(locationPicker: LocationPickerView!, tableViewDidLoad tableView: UITableView!) {
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nibConversationsCell = UINib(nibName: "StoreLocationTableViewCell", bundle: nil)
        self.locationPickerView?.tableView.registerNib(nibConversationsCell, forCellReuseIdentifier: "StoreLocationTableViewCell")
        self.locationPickerView!.tableView.rowHeight = UITableViewAutomaticDimension
        self.locationPickerView!.tableView.estimatedRowHeight = 215
        
        tableView.hidden = true
    }
    
    
    func locationPicker(locationPicker: LocationPickerView!, mapViewDidLoad mapView: MKMapView!) {
        
        mapView.showsUserLocation = true;
        locationPickerView!.mapView.showsUserLocation = true
        
        for store in self.stores {
            
            // Drop a pin
            if store.hasGeoLoation() {
                mapView.addAnnotation(makePinForStore(store))
            }
            
        }
        
        if (self.userDefaultStore != nil && self.userDefaultStore!.hasGeoLoation()) {
            mapView.addAnnotation(makePinForStore(self.userDefaultStore!))
            self.zoomMapTooLocation(CLLocationCoordinate2DMake(Double(self.userDefaultStore!.storeLocation!.latitude!)!, Double(self.userDefaultStore!.storeLocation!.longitude!)!))
        }
        
    }
    
    func makePinForStore(store : BVStore) -> MKPointAnnotation{
        
        let location = CLLocationCoordinate2DMake(Double(store.storeLocation!.latitude!)!, Double(store.storeLocation!.longitude!)!)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = store.productDescription
        dropPin.subtitle = store.storeLocation?.address
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
        
        if (self.userDefaultStore != nil) {
            // calculate store distance for the default store
            let deviceCLLocation = CLLocation(latitude: deviceLocation.latitude, longitude: deviceLocation.longitude)
            self.userDefaultStore?.deviceLocation = deviceCLLocation
        }
        
        var i = 0
        for _ in self.stores {
            // calculate the store distances for the other stores
            let deviceCLLocation = CLLocation(latitude: deviceLocation.latitude, longitude: deviceLocation.longitude)
            
            // TODO: What happens if the store doesn't have location?
            self.stores[i].deviceLocation = deviceCLLocation
            
            i += 1
            
        }
        
        // sort the cells based on distance, ASC, then refresh the data
        self.stores.sortInPlace({$0.distanceInMetersFromCurrentLocation() < $1.distanceInMetersFromCurrentLocation()})
        
        if (self.stores.count > 0){
            self.locationPickerView?.tableView.reloadData()
        }
        
    }
}

enum LocationSettingsSections : Int {
    
    case DefaultLocation = 0, OtherLocations
    
}
