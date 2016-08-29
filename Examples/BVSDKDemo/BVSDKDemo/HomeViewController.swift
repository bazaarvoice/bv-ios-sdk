//
//  HomeViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit
import BVSDK
import GoogleMobileAds
import FBSDKLoginKit

let ADVERT_INDEX_PATH = 7

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADNativeContentAdLoaderDelegate, BVLocationManagerDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var recommendationsCollectionView: BVProductRecommendationsCollectionView!
    
    private var recommendations:[BVRecommendedProduct]?
    private let spinner = Util.createSpinner()
    private let errorLabel = Util.createErrorLabel()
    private let refreshControl = UIRefreshControl()
    
    private var adLoader : GADAdLoader?
    
    private var currClientId : String?
    
    private var hasSeenNotificationsPrompt = false
    
    private var storeIdForAdTracking = "0" // track the deafult store id, in case we need to refresh and ad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       ProfileUtils.trackViewController(self)
        
        self.addSettingsButton()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.recommendationsCollectionView.backgroundColor = UIColor.clearColor()
        
        recommendationsCollectionView.layer.borderColor = UIColor.lightGrayColor().CGColor
        recommendationsCollectionView.backgroundColor = UIColor.clearColor()
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        
        recommendationsCollectionView.registerNib(UINib(nibName: "HomeHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
        
        recommendationsCollectionView.registerNib(UINib(nibName: "HomeAdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeAdvertisementCollectionViewCell")
        
        recommendationsCollectionView.registerNib(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        recommendationsCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "recommendationHeaderCell")
        recommendationsCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "locationCell")
        
        self.loadRecommendations()
        
        let versionString = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNum = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
        self.versionLabel.text = "v" + versionString! + "(" + buildNum! + ")"
        
        // Add in pull-to-refresh
        refreshControl.tintColor = UIColor.bazaarvoiceTeal()
        refreshControl.addTarget(self, action: Selector("refresh:"), forControlEvents: .ValueChanged)
        recommendationsCollectionView.addSubview(refreshControl)
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if currClientId != nil {
            if currClientId != BVSDKManager.sharedManager().clientId {
                self.recommendations?.removeAll() // client id changed, reload data
                self.loadRecommendations()
            }
        }
        
        currClientId = BVSDKManager.sharedManager().clientId
        
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // clear any cached recommendations, and reload latest recommendations from API
        BVShopperProfileRequestCache.sharedCache().removeAllCachedResponses()
        self.loadRecommendations()
    }
    
    func checkLocationAuthorization(){
        
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            
            if (!hasSeenNotificationsPrompt){
                
                // Only ask permission if we have not yet determined or asked the user
                let lvc = LocationPermissionViewController(nibName: "PermissionViewController", bundle:  nil)
                let nav = UINavigationController(rootViewController: lvc)
                self.navigationController?.presentViewController(nav, animated: true, completion: {
                    // completion, nothing to do
                    self.hasSeenNotificationsPrompt = true
                })
                
            }
            
            
        } else {
            
            // Initialize the location manager since the user has given preference to the CLLocationManager
            self.initLocationManager()

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.recommendations?.count > 0){
            self.refreshLocationSelectionIfVisible() // In case user changed location
        }
        
        // check that user is logged in to facebook
        if (ProfileUtils.isFacebookInstalled()) {
            // The app ID was set so we can authenticate the user
            if(FBSDKAccessToken.currentAccessToken() == nil) {
                let loginViewController = FacebookLoginViewController(nibName: "FacebookLoginViewController", bundle: nil)
                let nav = UINavigationController(rootViewController: loginViewController)
                self.presentViewController(nav, animated: true, completion: nil)
            }
            else {
                if let profile = FBSDKProfile.currentProfile() {
                    
                    ProfileUtils.trackFBLogin(profile.name)
                    if SITE_AUTH == 1 {
                        ProfileUtils.sharedInstance.setUserAuthString()
                    }

                }
                
                self.checkLocationAuthorization()
            }
            
            
        } else {
            
            self.checkLocationAuthorization()
            
        }
        
    }
    
    func initAdvertisement(){
        
        if let defaultStore = LocationPreferenceUtils.getDefaultStore() {
            
            if defaultStore.storeId != self.storeIdForAdTracking {
                // store changed so we'll want to reload an store-specific advertisement
                adLoader = nil
            }
            
            self.storeIdForAdTracking = defaultStore.storeId
        }
        
        // only load the ad once, and when the cell is dequeued
        if adLoader == nil
        {
            
            adLoader = GADAdLoader(adUnitID: "/5705/bv-incubator/IncubatorEnduranceCycles", rootViewController: self, adTypes: [kGADAdLoaderAdTypeNativeContent], options: nil)
            adLoader?.delegate = self
            
            let request = DFPRequest()
            //request.testDevices = [kDFPSimulatorID]

            request.customTargeting = BVSDKManager.sharedManager().getCustomTargeting() //+ whatever
            
            var targetingCity = "Undefined"
            if let defaultStore = LocationPreferenceUtils.getDefaultStore() {
                // Ads are targeted here based on the city the user has chosen in the location
                targetingCity = defaultStore.storeCity
            }
            
            request.customTargeting!["cities"] = targetingCity
            
            adLoader?.loadRequest(request)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.spinner.center = self.recommendationsCollectionView.center
    }
    
    func styleAndPushViewController(viewController: UIViewController) {
        
        viewController.navigationItem.titleView = self.dynamicType.createTitleLabel()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    class func createTitleLabel() -> UILabel {
     
        let titleLabel = UILabel(frame: CGRectMake(0,0,200,44))
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        return titleLabel
        
    }
    
    func getGearIconImage() -> UIImage {

        let menuIcon = FAKFontAwesome.gearIconWithSize(20)
        menuIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        return menuIcon.imageWithSize(CGSize(width: 20, height: 20))

    }
    
    func addSettingsButton() {
        
        if let path = NSBundle.mainBundle().pathForResource("config/DemoAppConfigs", ofType: "plist") {
            if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: self.getGearIconImage(),
                    style: UIBarButtonItemStyle.Plain,
                    target: self,
                    action: "settingsIconPressed"
                )
            }
        }
        
    }
    
    func settingsIconPressed() {

        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        
    }
    
    func initLocationManager(){
        
        if (CLLocationManager.authorizationStatus() == .AuthorizedAlways){
            BVLocationManager.registerForLocationUpdates(self)
            if !BVSDKManager.sharedManager().apiKeyLocation.isEmpty {
                BVLocationManager.startLocationUpdates()
            } else {
                print("Not starting location manager due to missing BVSDKManager#apiKeyLocation. App will not recieve location events.")
            }
        } else {
            BVLocationManager.unregisterForLocationUpdates(self)
        }
        
    }
    
    func loadRecommendations() {
        
        // add loading icon
        self.recommendationsCollectionView.addSubview(self.spinner)
            
        self.errorLabel.removeFromSuperview()
        
        let request = BVRecommendationsRequest(limit: 20)
        self.recommendationsCollectionView.loadRequest(request, completionHandler: { (recommendations:[BVRecommendedProduct]) in
            
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            
            self.recommendationsCollectionView?.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error:NSError) in
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.recommendationsCollectionView.bounds
            self.recommendationsCollectionView.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
            self.recommendationsCollectionView?.reloadData()
            self.refreshControl.endRefreshing()
            
        }
        
    }
    
    func addBorderToBottomOfCell(cell : UIView){
        
        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRectMake(0, CGRectGetHeight(cell.frame), CGRectGetWidth(cell.frame), 1)
        cell.layer.addSublayer(bottomBorder)
        
    }
    
    func refreshLocationSelectionIfVisible(){
        
        let visibleRows = self.recommendationsCollectionView.indexPathsForVisibleItems()
        for currIndexPath in visibleRows {
            
            if currIndexPath.cellType == .Location {
                self.recommendationsCollectionView.reloadItemsAtIndexPaths([currIndexPath])
                break
            }
        }

        
    }
    
    // MARK: UICollectionViewDelegate / UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.recommendations != nil && self.recommendations!.count > 0 {
            if (self.recommendations!.count > ADVERT_INDEX_PATH-2){
                return self.recommendations!.count + 4 // one for top banner, one for advertisement, one for location
            } else {
                return self.recommendations!.count
            }
            
        }
        else {
            return 0
        }
        
    }
    
    func getRecommendationForIndexPath(indexPath: NSIndexPath) -> BVRecommendedProduct {
        
        let indexOffset = (indexPath.row > ADVERT_INDEX_PATH) ? 4 : 1

        return self.recommendations![indexPath.row - indexOffset]
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.cellType {
        case .Header:
            return CGSize(
                width: self.view.bounds.width,
                height: HomeHeaderCollectionViewCell.preferredHeightForWidth(self.view.bounds.width)
            )
            
        case .Location:
            return CGSize(
                width: self.view.bounds.width,
                height: 44
            )
            
        case .RecommendationHeader:
            return CGSize(
                width: self.view.bounds.width,
                height: 22
            )
            
        case .Advertisement:
            return CGSize(
                width: self.view.bounds.width,
                height: 200
            )
            
        case .ProductRecommendation:
            let padding = CGFloat(8)
            let extraHeightPadding = CGFloat(24)
            return CGSize(
                width: self.view.bounds.width/2 - padding*2,
                height: self.view.bounds.width/2 - padding*2 + extraHeightPadding
            )
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.cellType {
        
        case .Header:
            
            return collectionView.dequeueReusableCellWithReuseIdentifier("HomeHeaderCollectionViewCell", forIndexPath: indexPath) as! HomeHeaderCollectionViewCell
        
        case .Location:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("locationCell", forIndexPath: indexPath)
            
            for view in cell.subviews {
                view.removeFromSuperview() // clean out the previous cells
            }
            
            let locationIconHW : CGFloat = 33.0
            let locationIcon = UIImageView(frame: CGRectMake(8, 0, locationIconHW, locationIconHW))
            locationIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.mapMarkerIconWithSize)
            cell.addSubview(locationIcon)
            
            cell.backgroundColor = UIColor.whiteColor()
            let label = UILabel(frame: CGRectMake(locationIconHW+16, 0, self.view.bounds.width-locationIconHW, locationIconHW))
            
            if let defaultStore = LocationPreferenceUtils.getDefaultStore() {
                label.text = "My Store: " + defaultStore.storeCity + ", " + defaultStore.storeState
            } else {
                label.text = "Set your default store location!"
            }
            
            label.baselineAdjustment = .AlignCenters
            label.textColor = UIColor.bazaarvoiceNavy()
            cell.addSubview(label)
            
            self.addBorderToBottomOfCell(cell)
            
            return cell
          
        case .RecommendationHeader:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("recommendationHeaderCell", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.whiteColor()
            let label = UILabel(frame: CGRectMake(8, 0, self.view.bounds.width, 30))
            label.baselineAdjustment = .AlignCenters
            label.text = "RECOMMENDED FOR YOU"
            label.textColor = UIColor.bazaarvoiceNavy()
            cell.addSubview(label)
            
            return cell
            
        case .Advertisement:
            
            self.initAdvertisement()
            
            return collectionView.dequeueReusableCellWithReuseIdentifier("HomeAdvertisementCollectionViewCell", forIndexPath: indexPath) as! HomeAdvertisementCollectionViewCell
        
        default:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCarouselCollectionViewCell", forIndexPath: indexPath) as! DemoCarouselCollectionViewCell
            
            cell.bvRecommendedProduct = getRecommendationForIndexPath(indexPath)
            
            return cell
            
        }
        
    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        switch indexPath.cellType {
        case .ProductRecommendation:
            
            let productView = NewProductPageViewController(
                nibName:"NewProductPageViewController",
                bundle: nil,
                product: self.getRecommendationForIndexPath(indexPath)
            )
            
            self.navigationController?.pushViewController(productView, animated: true)
        
        case .Advertisement:
            print("Advertisement clicked")

        case .Location:
            
            let locationSettingsVC = LocationSettings(nibName:"LocationSettings", bundle: nil)
            
            self.navigationController?.pushViewController(locationSettingsVC, animated: true)
            
            return
            
        case .RecommendationHeader:
            return
            
        case .Header:
            return
        }
        
    }
    
    // MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeContentAd nativeContentAd: GADNativeContentAd!) {
        
        print("Received HomePage native ad")
        
        if recommendationsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: ADVERT_INDEX_PATH, inSection: 0)) != nil {
        
            let nativeAdCell = recommendationsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: ADVERT_INDEX_PATH, inSection: 0)) as! HomeAdvertisementCollectionViewCell
            
            nativeAdCell.nativeContentAd = nativeContentAd
        }
    }
    
    func adLoader(adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive advertisement: " + error.localizedDescription)
        self.adLoader = nil

    }
    
    
    // MARK: BVLocationManagerDelegate
    
    func didBeginVisit(visit: BVVisit) {
        print("didBeginVisit ---> ", visit.description)
    }
    
    func didEndVisit(visit: BVVisit) {
        print("didEndVisit <---", visit.description)
    }
    
}



private enum CellType {
    case Header, Location, Advertisement, RecommendationHeader, ProductRecommendation
}

private extension NSIndexPath {
    var cellType : CellType {
        get {
            switch row {
                case 0: return .Header
                case 1: return .Location
                case 2: return .RecommendationHeader
                case ADVERT_INDEX_PATH: return .Advertisement
                default: return .ProductRecommendation
            }
        }
    }
}