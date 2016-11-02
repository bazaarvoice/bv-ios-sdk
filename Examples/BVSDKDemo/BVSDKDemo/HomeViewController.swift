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
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        
        self.view.backgroundColor = UIColor.white
        self.recommendationsCollectionView.backgroundColor = UIColor.clear
        
        recommendationsCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        recommendationsCollectionView.backgroundColor = UIColor.clear
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        
        recommendationsCollectionView.register(UINib(nibName: "HomeHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "HomeAdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeAdvertisementCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        recommendationsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "recommendationHeaderCell")
        recommendationsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "locationCell")
        
        self.loadRecommendations()
        
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNum = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        self.versionLabel.text = "v" + versionString! + "(" + buildNum! + ")"
        
        // Add in pull-to-refresh
        refreshControl.tintColor = UIColor.bazaarvoiceTeal()
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), for: .valueChanged)
        recommendationsCollectionView.addSubview(refreshControl)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currClientId != nil {
            if currClientId != BVSDKManager.shared().clientId {
                self.recommendations?.removeAll() // client id changed, reload data
                self.loadRecommendations()
            }
        }
        
        currClientId = BVSDKManager.shared().clientId
        
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        // clear any cached recommendations, and reload latest recommendations from API
        BVShopperProfileRequestCache.shared().removeAllCachedResponses()
        self.loadRecommendations()
    }
    
    func checkLocationAuthorization(){
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            
            if (!hasSeenNotificationsPrompt){
                
                // Only ask permission if we have not yet determined or asked the user
                let lvc = LocationPermissionViewController(nibName: "PermissionViewController", bundle:  nil)
                let nav = UINavigationController(rootViewController: lvc)
                self.navigationController?.present(nav, animated: true, completion: {
                    // completion, nothing to do
                    self.hasSeenNotificationsPrompt = true
                })
                
            }
            
            
        } else {
            
            // Initialize the location manager since the user has given preference to the CLLocationManager
            self.initLocationManager()

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.recommendations?.count > 0){
            self.refreshLocationSelectionIfVisible() // In case user changed location
        }
        
        // check that user is logged in to facebook
        if (ProfileUtils.isFacebookInstalled()) {
            // The app ID was set so we can authenticate the user
            if(FBSDKAccessToken.current() == nil) {
                let loginViewController = FacebookLoginViewController(nibName: "FacebookLoginViewController", bundle: nil)
                let nav = UINavigationController(rootViewController: loginViewController)
                self.present(nav, animated: true, completion: nil)
            }
            else {
                if let profile = FBSDKProfile.current() {
                    
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
            
            if defaultStore.identifier != self.storeIdForAdTracking {
                // store changed so we'll want to reload an store-specific advertisement
                adLoader = nil
            }
            
            self.storeIdForAdTracking = defaultStore.identifier
        }
        
        // only load the ad once, and when the cell is dequeued
        if adLoader == nil
        {
            
            adLoader = GADAdLoader(adUnitID: "/5705/bv-incubator/IncubatorEnduranceCycles", rootViewController: self, adTypes: [kGADAdLoaderAdTypeNativeContent], options: nil)
            adLoader?.delegate = self
            
            let request = DFPRequest()
            //request.testDevices = [kDFPSimulatorID]

            request.customTargeting = BVSDKManager.shared().getCustomTargeting() //+ whatever
            
            var targetingCity = "Undefined"
            if let defaultCachedStore = LocationPreferenceUtils.getDefaultStore() {
                // Ads are targeted here based on the city the user has chosen in the location
                targetingCity = defaultCachedStore.city
            }
            
            request.customTargeting!["cities"] = targetingCity
            
            adLoader?.load(request)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.spinner.center = self.recommendationsCollectionView.center
    }
    
    func styleAndPushViewController(_ viewController: UIViewController) {
        
        viewController.navigationItem.titleView = type(of: self).createTitleLabel()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    class func createTitleLabel() -> UILabel {
     
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        return titleLabel
        
    }
    
    func getGearIconImage() -> UIImage {

        let menuIcon = FAKFontAwesome.gearIcon(withSize: 20)
        menuIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        return menuIcon!.image(with: CGSize(width: 20, height: 20))

    }
    
    func addSettingsButton() {
        
        if let path = Bundle.main.path(forResource: "config/DemoAppConfigs", ofType: "plist") {
            if FileManager.default.fileExists(atPath: path, isDirectory: nil) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: self.getGearIconImage(),
                    style: UIBarButtonItemStyle.plain,
                    target: self,
                    action: #selector(HomeViewController.settingsIconPressed)
                )
            }
        }
        
    }
    
    func settingsIconPressed() {

        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        
    }
    
    func initLocationManager(){
        
        if (CLLocationManager.authorizationStatus() == .authorizedAlways){
            BVLocationManager.register(forLocationUpdates: self)
            if !BVSDKManager.shared().apiKeyLocation.isEmpty {
                BVLocationManager.startLocationUpdates()
            } else {
                print("Not starting location manager due to missing BVSDKManager#apiKeyLocation. App will not recieve location events.")
            }
        } else {
            BVLocationManager.unregister(forLocationUpdates: self)
        }
        
    }
    
    func loadRecommendations() {
        
        // add loading icon
        self.recommendationsCollectionView.addSubview(self.spinner)
            
        self.errorLabel.removeFromSuperview()
        
        let request = BVRecommendationsRequest(limit: 20)
        self.recommendationsCollectionView.load(request, completionHandler: { (recommendations:[BVRecommendedProduct]) in
            
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            
            self.recommendationsCollectionView?.reloadData()
            self.refreshControl.endRefreshing()
            
        }) { (error) in
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.recommendationsCollectionView.bounds
            self.recommendationsCollectionView.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
            self.recommendationsCollectionView?.reloadData()
            self.refreshControl.endRefreshing()
            
        }
        
    }
    
    func addBorderToBottomOfCell(_ cell : UIView){
        
        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.groupTableViewBackground.cgColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 1)
        cell.layer.addSublayer(bottomBorder)
        
    }
    
    func refreshLocationSelectionIfVisible(){
        
        let visibleRows = self.recommendationsCollectionView.indexPathsForVisibleItems
        for currIndexPath in visibleRows {
            
            if currIndexPath.cellType == .location {
                self.recommendationsCollectionView.reloadItems(at: [currIndexPath])
                break
            }
        }

        
    }
    
    // MARK: UICollectionViewDelegate / UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func getRecommendationForIndexPath(_ indexPath: IndexPath) -> BVRecommendedProduct {
        
        let indexOffset = ((indexPath as NSIndexPath).row > ADVERT_INDEX_PATH) ? 4 : 1

        return self.recommendations![(indexPath as NSIndexPath).row - indexOffset]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        switch indexPath.cellType {
        case .header:
            return CGSize(
                width: self.view.bounds.width,
                height: HomeHeaderCollectionViewCell.preferredHeightForWidth(self.view.bounds.width)
            )
            
        case .location:
            return CGSize(
                width: self.view.bounds.width,
                height: 44
            )
            
        case .recommendationHeader:
            return CGSize(
                width: self.view.bounds.width,
                height: 22
            )
            
        case .advertisement:
            return CGSize(
                width: self.view.bounds.width,
                height: 200
            )
            
        case .productRecommendation:
            let padding = CGFloat(8)
            let extraHeightPadding = CGFloat(24)
            return CGSize(
                width: self.view.bounds.width/2 - padding*2,
                height: self.view.bounds.width/2 - padding*2 + extraHeightPadding
            )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.cellType {
        
        case .header:
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as! HomeHeaderCollectionViewCell
        
        case .location:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath)
            
            for view in cell.subviews {
                view.removeFromSuperview() // clean out the previous cells
            }
            
            let locationIconHW : CGFloat = 33.0
            let locationIcon = UIImageView(frame: CGRect(x: 8, y: 0, width: locationIconHW, height: locationIconHW))
            locationIcon.image = Util.getFontAwesomeIconImage(FAKFontAwesome.mapMarkerIcon(withSize:))
            cell.addSubview(locationIcon)
            
            cell.backgroundColor = UIColor.white
            let label = UILabel(frame: CGRect(x: locationIconHW+16, y: 0, width: self.view.bounds.width-locationIconHW, height: locationIconHW))
            
            if let defaultCachedStore = LocationPreferenceUtils.getDefaultStore() {
                label.text = "My Store: " + defaultCachedStore.city + ", " + defaultCachedStore.state
            } else {
                label.text = "Set your default store location!"
            }
            
            label.baselineAdjustment = .alignCenters
            label.textColor = UIColor.bazaarvoiceNavy()
            cell.addSubview(label)
            
            self.addBorderToBottomOfCell(cell)
            
            return cell
          
        case .recommendationHeader:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendationHeaderCell", for: indexPath)
            cell.backgroundColor = UIColor.white
            let label = UILabel(frame: CGRect(x: 8, y: 0, width: self.view.bounds.width, height: 30))
            label.baselineAdjustment = .alignCenters
            label.text = "RECOMMENDED FOR YOU"
            label.textColor = UIColor.bazaarvoiceNavy()
            cell.addSubview(label)
            
            return cell
            
        case .advertisement:
            
            self.initAdvertisement()
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAdvertisementCollectionViewCell", for: indexPath) as! HomeAdvertisementCollectionViewCell
        
        default:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCarouselCollectionViewCell", for: indexPath) as! DemoCarouselCollectionViewCell
            
            cell.bvRecommendedProduct = getRecommendationForIndexPath(indexPath)
            
            return cell
            
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch indexPath.cellType {
        case .productRecommendation:
            
            let productView = NewProductPageViewController(
                nibName:"NewProductPageViewController",
                bundle: nil,
                product: self.getRecommendationForIndexPath(indexPath)
            )
            
            self.navigationController?.pushViewController(productView, animated: true)
        
        case .advertisement:
            print("Advertisement clicked")

        case .location:
            
            let locationSettingsVC = LocationSettings(nibName:"LocationSettings", bundle: nil)
            
            self.navigationController?.pushViewController(locationSettingsVC, animated: true)
            
            return
            
        case .recommendationHeader:
            return
            
        case .header:
            return
        }
        
    }
    
    // MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        
        print("Received HomePage native ad")
        
        if recommendationsCollectionView.cellForItem(at: IndexPath(row: ADVERT_INDEX_PATH, section: 0)) != nil {
        
            let nativeAdCell = recommendationsCollectionView.cellForItem(at: IndexPath(row: ADVERT_INDEX_PATH, section: 0)) as! HomeAdvertisementCollectionViewCell
            
            nativeAdCell.nativeContentAd = nativeContentAd
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive advertisement: " + error.localizedDescription)
        self.adLoader = nil

    }
    
    
    // MARK: BVLocationManagerDelegate
    
    func didBegin(_ visit: BVVisit) {
        print("didBeginVisit ---> ", visit.description)
    }
    
    func didEnd(_ visit: BVVisit) {
        print("didEndVisit <---", visit.description)
    }
    
}



private enum CellType {
    case header, location, advertisement, recommendationHeader, productRecommendation
}

private extension IndexPath {
    var cellType : CellType {
        get {
            switch row {
                case 0: return .header
                case 1: return .location
                case 2: return .recommendationHeader
                case ADVERT_INDEX_PATH: return .advertisement
                default: return .productRecommendation
            }
        }
    }
}
