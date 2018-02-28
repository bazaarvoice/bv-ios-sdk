//
//  NewProductPageViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
import UIKit
import BVSDK
import HCSStarRatingView
import FontAwesomeKit
import GoogleMobileAds
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



class NewProductPageViewController: BVProductDisplayPageViewController, UITableViewDelegate, UITableViewDataSource, GADNativeContentAdLoaderDelegate {
  
  enum ProductDetailSection : Int {
    case ratings = 0
    case questions
    case curations
    case curationsAddPhoto
    case curationsPhotoMap
    case recommendations
    
    
    static func count() -> Int {
      return 7
    }
  }
  
  @IBOutlet weak var tableView : UITableView!
  @IBOutlet weak var productName : UILabel!
  @IBOutlet weak var productPrice : UILabel!
  @IBOutlet weak var productStars : HCSStarRatingView!
  @IBOutlet weak var productImage : UIImageView!
  @IBOutlet weak var productImageHeight : NSLayoutConstraint!
  @IBOutlet weak var addToCartButton: UIButton!
  
  private var totalReviewCount, totalQuestionCount, totalAnswerCount : Int?
  
  private var adLoader : GADAdLoader?
  private var nativeContentAd : GADNativeContentAd?
  
  private let productId : String
  
  private var defaultStoreId = "0"
  
  private var curationsCell : NewProductCurationsTableViewCell!
  
  private lazy var cartIconImage : UIImage = {
    let menuIcon = FAKFontAwesome.shoppingCartIcon(withSize: 20)
    menuIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
    return menuIcon!.image(with: CGSize(width: 20, height: 20))
  }()
  
  init(productId: String) {
    
    self.productId = productId
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ProfileUtils.trackViewController(self)
    
    // load a native content ad
    self.loadNativeAd()
    
    // get # of ratings & reviews, and # of questions & answers
    self.loadConversationsStats()
    
    self.navigationItem.titleView = HomeViewController.createTitleLabel()
    
    self.addBarButtonItems()
    self.styleAddToCartButton()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 40
    tableView.contentInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: 40,
      right: 0
    )
    
    let nibRecsCell = UINib(nibName: "NewProductRecsTableViewCell", bundle: nil)
    tableView.register(nibRecsCell, forCellReuseIdentifier: "NewProductRecsTableViewCell")
    
    let nibCurationsRecsCell = UINib(nibName: "NewProductCurationsTableViewCell", bundle: nil)
    tableView.register(nibCurationsRecsCell, forCellReuseIdentifier: "NewProductCurationsTableViewCell")
    
    let nibConversationsCell = UINib(nibName: "ProductPageButtonCell", bundle: nil)
    tableView.register(nibConversationsCell, forCellReuseIdentifier: "ProductPageButtonCell")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    self.updateCartBadgeCount()
  }
  
  private func addBarButtonItems(){
    
    var buttonItems : [UIBarButtonItem] = []
    
    // Always add the cart button to index 0
    let cartButton = UIBarButtonItem(
      image: self.cartIconImage,
      style: UIBarButtonItemStyle.plain,
      target: self,
      action: #selector(HomeViewController.cartIconPressed)
    )
    
    buttonItems.append(cartButton)
    
    if self.navigationController?.viewControllers.count > 2 {
      let homeBarButton = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(NewProductPageViewController.homeButtonPressed))
      homeBarButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -30)
      buttonItems.append(homeBarButton)
      
    }
    
    self.navigationItem.setRightBarButtonItems(buttonItems, animated: true)
    
  }
  
  func cartIconPressed(){
    self.navigationController?.pushViewController(CartViewController(), animated: true)
  }
  
  private func updateCartBadgeCount(){
    let cartButton = self.navigationItem.rightBarButtonItems?[0]
    cartButton?.addBadge(number: CartManager.sharedInstance.numberOfItemsInCart(), withOffset: CGPoint.zero, andColor: UIColor.red, andFilled: true)
  }
  
  private func styleAddToCartButton(){
    self.addToCartButton.titleLabel?.textAlignment = .center
    self.addToCartButton.layer.cornerRadius = 4
    self.addToCartButton.layer.backgroundColor = UIColor.bazaarvoiceNavy().cgColor
    self.addToCartButton.setTitleColor(UIColor.white, for: .normal)
  }
  
  func loadConversationsStats() {
    
    let request = BVProductDisplayPageRequest(productId: productId)
      .includeStatistics(.reviews)
      .includeStatistics(.questions)
    
    request.load({ (response) in
      
      let product = response.result
      
      self.product = product
      
      self.productName.text = product?.name
      self.totalReviewCount = product?.reviewStatistics?.totalReviewCount as? Int ?? 0
      self.totalQuestionCount = product?.qaStatistics?.totalQuestionCount as? Int ?? 0
      self.totalAnswerCount = product?.qaStatistics?.totalAnswerCount as? Int ?? 0
      if let url  = product?.imageUrl {
        self.productImage.sd_setImage(with: URL(string: url))
      }
      self.tableView.reloadData()
      
    }) { (errors) in
      
      print("An error occurred: \(errors)")
      
    }
    
  }
  
  func loadNativeAd() {
    
    adLoader = GADAdLoader(
      adUnitID: "/5705/bv-incubator/EnduranceCyclesSale",
      rootViewController: self,
      adTypes: [ GADAdLoaderAdType.nativeContent ],
      options: nil
    )
    adLoader!.delegate = self
    
    let request = DFPRequest()
    request.customTargeting = BVSDKManager.shared().getCustomTargeting()
    adLoader!.load(request)
    
  }
  
  
  @IBAction func addToCartPressed(_ sender: AnyObject) {
    CartManager.sharedInstance.addProduct(product: self.product)
    self.updateCartBadgeCount()
  }
  
  func homeButtonPressed() {
    
    _ = self.navigationController?.popToRootViewController(animated: true)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.updateProductImageHeight()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.updateProductImageHeight()
  }
  
  func updateProductImageHeight() {
    
    let maxHeight = self.view.bounds.height * 0.3
    let minHeight = maxHeight / 2
    
    let contentOffset = self.tableView.contentOffset.y < 0 ? 0 : self.tableView.contentOffset.y
    
    if(tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)) {
      // maximum shrinkage
      self.setPriceShrinkPercentage(1.0)
      return;
    }
    
    var destinationHeight = (maxHeight - (contentOffset))
    if destinationHeight < minHeight {
      destinationHeight = minHeight
    }
    
    productImageHeight.constant = destinationHeight
    
    let percentageShrink = (maxHeight-destinationHeight) / (maxHeight-minHeight)
    self.setPriceShrinkPercentage(percentageShrink)
  }
  
  func setPriceShrinkPercentage(_ percentageShrink: CGFloat) {
    let fontSize = 20 - (20 * percentageShrink)
    
    productPrice.font = UIFont(name: productPrice.font.fontName, size: fontSize)
    productPrice.textColor = productPrice.textColor.withAlphaComponent(1.0 - percentageShrink)
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return ProductDetailSection.count()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    self.updateProductImageHeight()
    
  }
  
  func sdkIsConfiguredFor(_ product: ProductDetailSection) -> Bool {
    // if we're in demo mode, we are configured for everything
    let config = MockDataManager.sharedInstance.currentConfig!
    
    if (config.curationsKey == "REPLACE_ME"
      && config.conversationsKey == "REPLACE_ME"
      && config.shopperAdvertisingKey == "REPLACE_ME") {
      return true
    }
    
    // check which product we're configured to use
    switch product {
    case .ratings, .questions:
      return config.conversationsKey != "REPLACE_ME"
    case .curations, .curationsAddPhoto, .curationsPhotoMap:
      return config.curationsKey != "REPLACE_ME"
    case .recommendations:
      return config.shopperAdvertisingKey != "REPLACE_ME"
    }
    
  }
  
  
  // MARK: UITableViewDatasource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
      
    case ProductDetailSection.ratings.rawValue:
      return sdkIsConfiguredFor(.ratings) ? 1 : 0
      
    case ProductDetailSection.questions.rawValue:
      return sdkIsConfiguredFor(.questions) ? 1 : 0
      
    case ProductDetailSection.recommendations.rawValue:
      return sdkIsConfiguredFor(.recommendations) ? 1 : 0
      
    case ProductDetailSection.curations.rawValue:
      return sdkIsConfiguredFor(.curations) ? 1 : 0
      
    case ProductDetailSection.curationsAddPhoto.rawValue:
      return sdkIsConfiguredFor(.curationsAddPhoto) ? 1 : 0
      
    case ProductDetailSection.curationsPhotoMap.rawValue:
      return sdkIsConfiguredFor(.curationsAddPhoto) ? 1 : 0
      
    default:
      return 0
      
    }
    
  }
  
  
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return CGFloat.leastNormalMagnitude
    
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    if section == ProductDetailSection.ratings.rawValue ||
      section == ProductDetailSection.curations.rawValue ||
      section == ProductDetailSection.curationsAddPhoto.rawValue ||
      section == ProductDetailSection.questions.rawValue{
      return CGFloat.leastNormalMagnitude
    }
    else {
      return 18
    }
    
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return UITableViewAutomaticDimension
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.recommendations.rawValue {
      
      let recsCell = tableView.dequeueReusableCell(withIdentifier: "NewProductRecsTableViewCell") as! NewProductRecsTableViewCell
      
      recsCell.referenceProduct = self.product
      recsCell.parentViewController = self
      
      recsCell.onProductRecTapped = {
        (selectedProduct) -> Void in
        
        let productView = NewProductPageViewController(productId: selectedProduct.productId)
        
        self.navigationController?.pushViewController(productView, animated: true)
        
      }
      
      return recsCell
      
    }
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.curations.rawValue {
      
      curationsCell = tableView.dequeueReusableCell(withIdentifier: "NewProductCurationsTableViewCell") as! NewProductCurationsTableViewCell
      
      curationsCell.product = self.product
      
      curationsCell.onFeedItemTapped = {
        (selectedIndex, feedItems) -> Void in
        // navigate to lightbox
        let targetVC = CurationsFeedMasterViewController()
        targetVC.socialFeedItems = feedItems
        targetVC.startIndex = selectedIndex
        self.navigationController?.pushViewController(targetVC, animated: true)
      }
      
      return curationsCell
      
    }
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.ratings.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
      
      cell.button.removeTarget(nil, action: nil, for: .allEvents)
      cell.button.addTarget(self, action: #selector(NewProductPageViewController.ratingsButtonPressed), for: .touchUpInside)
      cell.setCustomLeftIcon(FAKFontAwesome.commentsIcon(withSize:))
      cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
      
      if let count = totalReviewCount {
        
        cell.button.setTitle("\(count) Reviews", for: UIControlState())
        
      }
      
      return cell
      
    }
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.questions.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
      
      cell.button.removeTarget(nil, action: nil, for: .allEvents)
      cell.button.addTarget(self, action: #selector(NewProductPageViewController.questionsButtonPressed), for: .touchUpInside)
      cell.setCustomLeftIcon(FAKFontAwesome.questionCircleIcon(withSize:))
      cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
      
      if let count = totalQuestionCount, let answerCount = totalAnswerCount {
        
        cell.button.setTitle("\(count) Questions, \(answerCount) Answers", for: UIControlState())
        
      }
      
      return cell
      
    }
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.curationsAddPhoto.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
      
      cell.button.removeTarget(nil, action: nil, for: .allEvents)
      cell.button.addTarget(self, action: #selector(NewProductPageViewController.curationsAddPhotoPressed), for: .touchUpInside)
      cell.setCustomLeftIcon(FAKFontAwesome.cameraRetroIcon(withSize:))
      cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
      cell.button.setTitle("Add your photo!", for: UIControlState())
      
      return cell
      
    }
    
    if (indexPath as NSIndexPath).section == ProductDetailSection.curationsPhotoMap.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPageButtonCell") as! ProductPageButtonCell
      
      cell.button.removeTarget(nil, action: nil, for: .allEvents)
      cell.button.addTarget(self, action: #selector(NewProductPageViewController.curationsViewPhotoMapPressed), for: .touchUpInside)
      cell.setCustomLeftIcon(FAKFontAwesome.locationArrowIcon(withSize:))
      cell.setCustomRightIcon(FAKFontAwesome.chevronRightIcon(withSize:))
      cell.button.setTitle("Photos by Location", for: UIControlState())
      
      return cell
      
    }
    
    // should not get here...
    return cell
    
  }
  
  func ratingsButtonPressed() {
    
    if totalReviewCount == nil {
      totalReviewCount = 0
    }
    
    if let p = product {
      let ratingsVC = RatingsAndReviewsViewController(
        nibName: "RatingsAndReviewsViewController",
        bundle: nil,
        product: p,
        totalReviewCount: totalReviewCount!)
      
      self.navigationController?.pushViewController(ratingsVC, animated: true)
    }
    
  }
  
  func questionsButtonPressed() {
    
    let questionsVC = QuestionAnswerViewController(
      nibName: "QuestionAnswerViewController",
      bundle: nil,
      product: product!
    )
    self.navigationController?.pushViewController(questionsVC, animated: true)
    
  }
  
  func curationsAddPhotoPressed() {
    let shareRequest = BVCurationsAddPostRequest(
      groups: CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS,
      withAuthorAlias: "anonymous",
      withToken: "anonymous_nickname",
      withText: ""
    )
    
    let submitPhotoVC = DemoCustomPostViewController(
      shareRequest: shareRequest,
      placeholderText: "Say Hey!"
    )
    
    submitPhotoVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    self.present(submitPhotoVC, animated: true, completion: nil)
  }
  
  func curationsViewPhotoMapPressed() {
    
    if curationsCell.curationsCarousel.feedItems.count > 0 {
      let curationsPhotoMapVC = CurationsPhotoMapViewController(nibName: "CurationsPhotoMapViewController", bundle: nil)
      curationsPhotoMapVC.curationsFeed = curationsCell!.curationsCarousel.feedItems
      
      self.navigationController?.pushViewController(curationsPhotoMapVC, animated: true)
    } else {
      _ = SweetAlert().showAlert("Empty Curations Feed!", subTitle: "There are no items to display at this time.", style: .warning)
    }
    
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    self.tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  //MARK: GADNativeContentAdLoaderDelegate
  
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
    self.nativeContentAd = nativeContentAd
    self.tableView.reloadData()
  }
  
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("failed to load ad!")
    print("error: \(error)")
  }
  
}
