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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GADUnifiedNativeAdLoaderDelegate  {
  
  @IBOutlet weak var versionLabel: UILabel!
  
  @IBOutlet weak var recommendationsCollectionView: BVProductRecommendationsCollectionView!
  
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
    menuIcon?.addAttribute(NSAttributedString.Key.foregroundColor.rawValue, value: UIColor.white)
    return menuIcon!.image(with: CGSize(width: 20, height: 20))
  }()
  
  private lazy var cartIconImage : UIImage = {
    let menuIcon = FAKFontAwesome.shoppingCartIcon(withSize: 20)
    menuIcon?.addAttribute(NSAttributedString.Key.foregroundColor.rawValue, value: UIColor.white)
    return menuIcon!.image(with: CGSize(width: 20, height: 20))
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ProfileUtils.trackViewController(self)
    //Check for any new transactions UserDefaults. if so present alert view
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
  
  
    @objc func refresh(_ refreshControl: UIRefreshControl) {
    // clear any cached recommendations, and reload latest recommendations from API
    BVRecommendationsLoader.purgeRecommendationsCache()
    self.loadProducts()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let cartButton = self.navigationItem.rightBarButtonItems?[0]
    cartButton?.addBadge(number: CartManager.sharedInstance.numberOfItemsInCart(), withOffset: CGPoint.zero, andColor: UIColor.red, andFilled: true)
    
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
      }
    }
  }
  
  func initAdvertisement(){
    
    // only load the ad once, and when the cell is dequeued
    if adLoader == nil
    {
      
      adLoader = GADAdLoader(adUnitID: "/5705/bv-incubator/IncubatorEnduranceCycles", rootViewController: self, adTypes: [GADAdLoaderAdType.nativeContent], options: nil)
      adLoader?.delegate = self
      
      let request = DFPRequest()
      //request.testDevices = [kDFPSimulatorID]
      
      request.customTargeting = BVSDKManager.shared().getCustomTargeting() //+ whatever
      request.customTargeting!["cities"] = "Undefined"
      
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
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(HomeViewController.cartIconPressed)
    )
    
    buttonItems.append(cartButton)
    
    let settingsButton = UIBarButtonItem(
      image: self.gearIconImage,
      style: UIBarButtonItem.Style.plain,
      target: self,
      action: #selector(HomeViewController.historyIconPressed)
    )
    settingsButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
    
    buttonItems.append(settingsButton)
    
    if let path = Bundle.main.path(forResource: "config/DemoAppConfigs", ofType: "plist") {
      if FileManager.default.fileExists(atPath: path, isDirectory: nil) {
        let settingsButton = UIBarButtonItem(
          image: self.gearIconImage,
          style: UIBarButtonItem.Style.plain,
          target: self,
          action: #selector(HomeViewController.settingsIconPressed)
        )
        settingsButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        buttonItems.append(settingsButton)
      }
    }
    
    self.navigationItem.setRightBarButtonItems(buttonItems, animated: true)
    
  }
  
    @objc func historyIconPressed() {
        self.navigationController?.pushViewController(OrderHistoryViewController(), animated: true)
  }
    
    @objc func settingsIconPressed() {
    self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
  
    @objc func cartIconPressed(){
    self.navigationController?.pushViewController(CartViewController(), animated: true)
//    UIView.transition(with: self.view, duration: 10.5, options: [.transitionCurlUp], animations: {self.view.addSubview(self.spinner) }, completion: nil)
//    UIView.transition(from: self.view, to: self.view, duration: 4.0, options: [.transitionCurlUp], completion: nil)
//    self.navigationController?.pushViewController(CartViewController(), animated: true)
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
    let req = BVBulkProductRequest().sort(by: .productAverageOverallRating, monotonicSortOrderValue: .descending)
      .filter(on: .productTotalReviewCount, relationalFilterOperatorValue: .greaterThanOrEqualTo, value: "1")
      .filter(on: .productIsActive, relationalFilterOperatorValue: .equalTo, value: "true")
      .filter(on: .productIsDisabled, relationalFilterOperatorValue: .equalTo, value: "false")
    if (!omitStats){
      req.includeStatistics(.reviews)
    }
    
    req.sort(by: .reviewRating, monotonicSortOrderValue: .descending)
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
  }
  
  private func doneLoading(with error: Error) {
    self.spinner.removeFromSuperview()
    self.errorLabel.frame = self.recommendationsCollectionView.bounds
    self.recommendationsCollectionView.addSubview(self.errorLabel)
    print("Error: \(error.localizedDescription)")
    self.recommendationsCollectionView?.reloadData()
    self.refreshControl.endRefreshing()
  }
  
  func addBorderToBottomOfCell(cell : UIView){
    let bottomBorder: CALayer = CALayer()
    bottomBorder.borderColor = UIColor.groupTableViewBackground.cgColor
    bottomBorder.borderWidth = 1
    bottomBorder.frame = CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 1)
    cell.layer.addSublayer(bottomBorder)
    
  }
  
  // MARK: UICollectionViewDelegate / UICollectionViewDatasource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let type = CellType(rawValue: section)
    if type == .header || type == .advertisement{
      return MockDataManager.sharedInstance.currentConfig.isMock ? 1 : 0
    } else if type == .productRecommendationTop {
      
      if self.products != nil {
        if (self.products!.count >= numProductsAboveAd){
          return numProductsAboveAd // one for top banner, one for advertisement, one for location
        } else {
          return self.products!.count
        }
      }
      return 0
      
    } else if type == .productRecommendationBottom {
      
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
    return 5
  }
  
  func getRecommendationForIndexPath(_ indexPath: IndexPath) -> BVDisplayableProductContent {
    
    let indexOffset = (indexPath.section == 7) ? 4 : 0
    
    return self.products![indexPath.row + indexOffset]
  }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    switch CellType(rawValue: indexPath.section)! {
    case .header:
      return CGSize(
        width: self.view.bounds.width,
        height: HomeHeaderCollectionViewCell.preferredHeightForWidth(self.view.bounds.width)
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
      
    case .productRecommendationTop, .productRecommendationBottom:
      let padding = CGFloat(8)
      let extraHeightPadding = CGFloat(24)
      return CGSize(
        width: self.view.bounds.width/2 - padding*2,
        height: self.view.bounds.width/2 - padding*2 + extraHeightPadding
      )
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let type = CellType(rawValue: indexPath.section)!
    switch type {
    case .header:
      return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCollectionViewCell", for: indexPath) as! HomeHeaderCollectionViewCell
      
    case .recommendationHeader:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
      cell.textLbl?.text = "RECOMMENDED FOR YOU"
      return cell
      
    case .advertisement:
      self.initAdvertisement()
      return collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAdvertisementCollectionViewCell", for: indexPath) as! HomeAdvertisementCollectionViewCell
      
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
      
    case .recommendationHeader:
      return
      
    case .header:
      return
    default:
      return
    }
    
  }
  
  // MARK: GADNativeContentAdLoaderDelegate
  
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADUnifiedNativeAd) {
    
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
}

private enum CellType: Int {
  case header, recommendationHeader, productRecommendationTop, advertisement, productRecommendationBottom
}
