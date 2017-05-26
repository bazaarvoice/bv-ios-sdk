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


//multiple of 2
private let numProductsAboveAd = 4

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADNativeContentAdLoaderDelegate, BVLocationManagerDelegate {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var recommendationsCollectionView: BVProductRecommendationsCollectionView!
    
    private var productsToReview: [BVPIN]?
    private var products:[BVDisplayableProductContent]?
    private let spinner = Util.createSpinner()
    private let errorLabel = Util.createErrorLabel()
    private let refreshControl = UIRefreshControl()
    
    private var adLoader : GADAdLoader?
    
    private var currClientId : String?
    
    private var hasSeenNotificationsPrompt = false
    
    private var storeIdForAdTracking = "0" // track the deafult store id, in case we need to refresh and ad
    
    private lazy var gearIconImage : UIImage = {
        let menuIcon = FAKFontAwesome.gearIcon(withSize: 20)
        menuIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        return menuIcon!.image(with: CGSize(width: 20, height: 20))
    }()
    
    private lazy var cartIconImage : UIImage = {
        let menuIcon = FAKFontAwesome.shoppingCartIcon(withSize: 20)
        menuIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        return menuIcon!.image(with: CGSize(width: 20, height: 20))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileUtils.trackViewController(self)

        self.addBarButtonItems()
        
        self.view.backgroundColor = UIColor.white
        self.recommendationsCollectionView.backgroundColor = UIColor.clear
        
        recommendationsCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        recommendationsCollectionView.backgroundColor = UIColor.clear
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self
        
        recommendationsCollectionView.register(UINib(nibName: "HomeHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "HomeAdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeAdvertisementCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "DemoCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCarouselCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "PINCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PINCollectionViewCell")
        
        recommendationsCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        
        self.custimizeSearchUI(circleSearch)
        self.loadProducts()
        
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
            if currClientId != MockDataManager.sharedInstance.currentConfig.clientId {
                self.products?.removeAll() // client id changed, reload data
                self.loadProducts()
            }
        }else {
            recommendationsCollectionView.reloadSections(IndexSet(integer: CellType.location.rawValue))
        }
        
        currClientId = MockDataManager.sharedInstance.currentConfig.clientId
        
    }
    
    lazy private var circleSearch: CircleSearchView<BVDisplayableProductContent> = {
        let csv = CircleSearchView<BVDisplayableProductContent>(scrollView: self.recommendationsCollectionView, changeHandler: { (_, searchText, ressults, completion) in
            self.doConversationsSearch(searchText, completion: completion)
        }) { (_, results) in
            let vc = NewProductPageViewController(productId: results.identifier)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        csv.searchTableView.isHidden = true
        return csv
    }()
    
    
    private func doTextMatchSearch(_ searchText: String, completion: CircleSearchView<BVDisplayableProductContent>.SearchCompletionHandler) {
        
        var results = [CircleSearchResult<BVDisplayableProductContent>]()
        for prod in self.products! {
            if let name = prod.displayName {
                if name.lowercased().contains(searchText.lowercased()) {
                    results.append(CircleSearchResult(title: name, result: prod))
                }
            }
        }
        
        completion(results)
    }
    
    private func doConversationsSearch(_ searchText: String, completion: @escaping CircleSearchView<BVDisplayableProductContent>.SearchCompletionHandler) {
        
        let req = BVProductTextSearchRequest(searchText: searchText)
        req.includeStatistics(.reviews)
        req.load({[completion](res) in
            self.products = res.results
            self.recommendationsCollectionView.reloadData()
            var results = [CircleSearchResult<BVDisplayableProductContent>]()
            for prod in res.results {
                if let name = prod.displayName {
                    results.append(CircleSearchResult(title: name, result: prod))
                }
            }
            
            completion(results)
        }) { (errs) in
            
        }
    }
    
    private func custimizeSearchUI(_ circleSearch: CircleSearchView<BVDisplayableProductContent>) {
        
        circleSearch.searchTextField.placeholder = "Search for a product..."
        //UI Custimization
        circleSearch.minimumSearchLength = 3
        circleSearch.minKeyboardRestTimeToSearch = 1
        
        circleSearch.searchButton.backgroundColor = UIColor.init(red: 235 / 255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
        circleSearch.searchButton.tintColor = UIColor.bazaarvoiceNavy()
        circleSearch.cancelButton.backgroundColor = circleSearch.searchButton.backgroundColor
        circleSearch.searchTextField.backgroundColor = UIColor.white
        circleSearch.searchTextField.textColor = UIColor.darkGray
        circleSearch.cancelButton.setTitleColor(UIColor.bazaarvoiceNavy(), for: .normal)
    }

    
    func refresh(_ refreshControl: UIRefreshControl) {
        // clear any cached recommendations, and reload latest recommendations from API
        BVShopperProfileRequestCache.shared().removeAllCachedResponses()
        self.loadProducts()
        self.loadProductsToReview()
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
        
        let cartButton = self.navigationItem.rightBarButtonItems?[0]
        cartButton?.addBadge(number: CartManager.sharedInstance.numberOfItemsInCart(), withOffset: CGPoint.zero, andColor: UIColor.red, andFilled: true)
        
        if (self.products != nil && (self.products?.count)! > 0){

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
    
    func addBarButtonItems(){
        
        var buttonItems : [UIBarButtonItem] = []
        
        // Always add the cart button to index 0
        let cartButton = UIBarButtonItem(
            image: self.cartIconImage,
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(HomeViewController.cartIconPressed)
        )
        
        buttonItems.append(cartButton)
        
        if let path = Bundle.main.path(forResource: "config/DemoAppConfigs", ofType: "plist") {
            if FileManager.default.fileExists(atPath: path, isDirectory: nil) {
                let settingsButton = UIBarButtonItem(
                    image: self.gearIconImage,
                    style: UIBarButtonItemStyle.plain,
                    target: self,
                    action: #selector(HomeViewController.settingsIconPressed)
                )
                settingsButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -30)
                buttonItems.append(settingsButton)
            }
        }
        
        self.navigationItem.setRightBarButtonItems(buttonItems, animated: true)
        
    }
    
    
    func settingsIconPressed() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func cartIconPressed(){
        self.navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    func initLocationManager(){
        
        if (CLLocationManager.authorizationStatus() == .authorizedAlways){
            BVLocationManager.register(forLocationUpdates: self)
            if !MockDataManager.sharedInstance.currentConfig.locationKey.isEmpty {
                BVLocationManager.startLocationUpdates()
            } else {
                print("Not starting location manager due to missing BVSDKManager#apiKeyLocation. App will not recieve location events.")
            }
        } else {
            BVLocationManager.unregister(forLocationUpdates: self)
        }
        
    }
    
    func loadConversationsProducts(){
        
        _ = SweetAlert().showAlert("Error", subTitle: "Unable to load products for this API key setup.", style: .error)
        
    }
    
    
    func loadProducts() {
        self.recommendationsCollectionView.addSubview(self.spinner)
        self.errorLabel.removeFromSuperview()
        
        let shopperAdKey = MockDataManager.sharedInstance.currentConfig.shopperAdvertisingKey
        let canLoadRecommendations = MockDataManager.sharedInstance.currentConfig.isMock || (!shopperAdKey.isEmpty && shopperAdKey != "REPLACE_ME")
        if canLoadRecommendations {
            loadRecommendations()
        }else {
            loadConversations(omitStats: false)
        }
    }
    
    func loadConversations(omitStats : Bool) {
        let req = BVBulkProductRequest().addProductSort(.averageOverallRating, order: .descending)
            .add(.totalReviewCount, filterOperator: .greaterThanOrEqualTo, value: "10")
            .add(.isActive, filterOperator: .equalTo, value: "true")
            .add(.isDisabled, filterOperator: .equalTo, value: "false")
            if (!omitStats){
                req.includeStatistics(.reviews)
            }
        req.sortIncludedReviews(.rating, order: .descending)
        req.load({(response) in
            self.doneLoading(response.results)
        }){(errs) in
            
            if ((errs.first?.localizedDescription.lowercased().range(of: "must use non bulk filter value")) != nil &&
                omitStats == false){
                
                    print("WARNING: The API Key being used does not support the use of bulk requests, so included review statistics will not be included.")
                    self.loadConversations(omitStats: true)
                
            } else {
                self.doneLoading(with: errs.first!)
            }
        }
    }
    
    func loadRecommendations() {
        
        // add loading icon
        
        let request = BVRecommendationsRequest(limit: 20)
        self.recommendationsCollectionView.load(request, completionHandler: { (recommendations:[BVRecommendedProduct]) in
            self.doneLoading(recommendations)

        }) { (error) in
            self.doneLoading(with: error)
        }
        
    }
    
    private func doneLoading(_ results: [BVDisplayableProductContent]) {
        self.products = results
        self.spinner.removeFromSuperview()
        self.recommendationsCollectionView?.reloadData()
        self.refreshControl.endRefreshing()
        
        self.loadProductsToReview()
    }
    
    private func doneLoading(with error: Error) {
        self.spinner.removeFromSuperview()
        self.errorLabel.frame = self.recommendationsCollectionView.bounds
        self.recommendationsCollectionView.addSubview(self.errorLabel)
        print("Error: \(error.localizedDescription)")
        self.recommendationsCollectionView?.reloadData()
        self.refreshControl.endRefreshing()
        self.loadProductsToReview()
    }
    
    private func loadProductsToReview() {
        BVPINRequest.getPendingPINs({(pins) in
            self.updatePinSections(pins: pins)
        }){ (error) in
            print("ERROR: Unable to load products to reivew: " + error.localizedDescription)
            self.updatePinSections(pins: [])
        }
    }
    
    private func updatePinSections(pins: [BVPIN]) {
        let oCount = self.productsToReview?.count ?? 0
        
        let nCount = pins.count//self.productsToReview?.count ?? 0
        
        self.recommendationsCollectionView.performBatchUpdates({
            
            if (oCount == 0 && nCount == 0) || (oCount > 0 && nCount > 0) {
                self.recommendationsCollectionView.reloadSections(IndexSet(integer: CellType.pin.rawValue))
            }else if oCount == 0 && nCount > 0 {
                self.recommendationsCollectionView.insertItems(at: [IndexPath(item: 0, section: CellType.pinHeader.rawValue),
                                                                    IndexPath(item: 0, section: CellType.pin.rawValue)])
            }else if oCount > 0 && nCount == 0 {
                self.recommendationsCollectionView.deleteItems(at: [IndexPath(item: 0, section: CellType.pinHeader.rawValue),
                                                                    IndexPath(item: 0, section: CellType.pin.rawValue)])
            }
            self.productsToReview = pins
            
        }) {(done) in
            if nCount > 0 {
                self.queueFirstPINNotification(productID: self.productsToReview!.first!.identifier)
            }
        }
    }
    
    private func queueFirstPINNotification(productID: String) {
        BVProductReviewNotificationCenter.shared().queueReview(withProductId: productID)
    }
    
    func addBorderToBottomOfCell(cell : UIView){
        let bottomBorder: CALayer = CALayer()
        bottomBorder.borderColor = UIColor.groupTableViewBackground.cgColor
        bottomBorder.borderWidth = 1
        bottomBorder.frame = CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 1)
        cell.layer.addSublayer(bottomBorder)
        
    }
    
    func refreshLocationSelectionIfVisible(){
        
        let visibleRows = self.recommendationsCollectionView.indexPathsForVisibleItems
        for currIndexPath in visibleRows {
            
            if currIndexPath.section == CellType.location.rawValue {
                self.recommendationsCollectionView.reloadItems(at: [currIndexPath])
                break
            }
        }
        
        
    }
    
    // MARK: UICollectionViewDelegate / UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let type = CellType(rawValue: section)
        if type == .header || type == .advertisement{
            return MockDataManager.sharedInstance.currentConfig.isMock ? 1 : 0
        }else if type == .pinHeader {
            
            return (productsToReview?.count ?? 0 > 0) ? 1: 0
            
        } else if type == .pin {
            
            return productsToReview?.count ?? 0 > 0 ? 1: 0
            
        }else if type == .productRecommendationTop {
            
            if self.products != nil {
                if (self.products!.count >= numProductsAboveAd){
                    return numProductsAboveAd // one for top banner, one for advertisement, one for location
                } else {
                    return self.products!.count
                }
            }
            return 0
            
        }else if type == .productRecommendationBottom {
            
            if self.products != nil {
                if (self.products!.count >= numProductsAboveAd){
                    return self.products!.count - numProductsAboveAd // one for top banner, one for advertisement, one for location
                } else {
                    return 0
                }
            }
            
            return 0
        }
        
        return 1
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func getRecommendationForIndexPath(_ indexPath: IndexPath) -> BVDisplayableProductContent {
        
        let indexOffset = (indexPath.section == 7) ? 4 : 0
        
        return self.products![indexPath.row + indexOffset]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        switch CellType(rawValue: indexPath.section)! {
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
            
        case .recommendationHeader, .pinHeader:
            return CGSize(
                width: self.view.bounds.width,
                height: 22
            )
            
        case .advertisement:
            return CGSize(
                width: self.view.bounds.width,
                height: 200
            )
            
        case .productRecommendationTop, .productRecommendationBottom:
            let padding = CGFloat(8)
            let extraHeightPadding = CGFloat(24)
            return CGSize(
                width: self.view.bounds.width/2 - padding*2,
                height: self.view.bounds.width/2 - padding*2 + extraHeightPadding
            )
        case .pin:
            return CGSize(
                width: self.view.bounds.width,
                height: self.view.bounds.width/2
            )
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = CellType(rawValue: indexPath.section)!
        switch type {
        case .header:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as! HomeHeaderCollectionViewCell
            
        case .location:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
            return cell
            
        case .recommendationHeader, .pinHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
            if type == .pinHeader {
                cell.textLbl?.text = "Rate Your Recent Purchases"
            }else {
                cell.textLbl?.text = "RECOMMENDED FOR YOU"
            }
            return cell
            
        case .advertisement:
            self.initAdvertisement()
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAdvertisementCollectionViewCell", for: indexPath) as! HomeAdvertisementCollectionViewCell
            
        case .pin:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PINCollectionViewCell", for: indexPath) as! PINCollectionViewCell
            cell.productsToReview = productsToReview
            cell.productSelected = {(pin) in
                let vc = WriteReviewViewController(nibName: "WriteReviewViewController", bundle: nil, productId: pin.identifier)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCarouselCollectionViewCell", for: indexPath) as! DemoCarouselCollectionViewCell
            cell.product = getRecommendationForIndexPath(indexPath)
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch CellType(rawValue: indexPath.section)! {
        case .productRecommendationTop, .productRecommendationBottom:
            
            let productView = NewProductPageViewController( productId: self.getRecommendationForIndexPath(indexPath).identifier)
            
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
        case .pin:
            return
        default:
            return
        }
        
    }
    
    // MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        
        print("Received HomePage native ad")
        
        if recommendationsCollectionView.cellForItem(at: IndexPath(row: 0, section: CellType.advertisement.rawValue)) != nil {
            
            let nativeAdCell = recommendationsCollectionView.cellForItem(at: IndexPath(row: 0, section: CellType.advertisement.rawValue)) as! HomeAdvertisementCollectionViewCell
            
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

private enum CellType: Int {
    case header, location, pinHeader, pin, recommendationHeader, productRecommendationTop, advertisement,productRecommendationBottom
}
