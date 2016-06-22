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


class NewProductPageViewController: UIViewController, BVDelegate, UITableViewDelegate, UITableViewDataSource, GADNativeContentAdLoaderDelegate {

    enum ProductDetailSection : Int {
        case Ratings = 0
        case Questions
        case Curations
        case CurationsAddPhoto
        case Recommendations
        
        
        static func count() -> Int {
            return 5
        }
    }
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productPrice : UILabel!
    @IBOutlet weak var productStars : HCSStarRatingView!
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var productImageHeight : NSLayoutConstraint!
    
    var totalReviewCount, totalQuestionCount, totalAnswerCount : Int?
    
    var adLoader : GADAdLoader?
    var nativeContentAd : GADNativeContentAd?

    let selectedProduct : BVProduct
    
    init(nibName: String?, bundle: NSBundle?, product: BVProduct) {
        
        selectedProduct = product
        super.init(nibName: nibName, bundle: bundle)
        
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
        
        productName.text = selectedProduct.productName
        productPrice.text = selectedProduct.price
        productImage.sd_setImageWithURL(NSURL(string: selectedProduct.imageURL))
        productStars.value = CGFloat(selectedProduct.averageRating.floatValue)

        self.navigationItem.titleView = HomeViewController.createTitleLabel()
        
        if self.navigationController?.viewControllers.count > 2 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .Done, target: self, action: "homeButtonPressed")
        }
        
        
        print("Loading reviews for product \(selectedProduct.description)")
        
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
        tableView.registerNib(nibRecsCell, forCellReuseIdentifier: "NewProductRecsTableViewCell")
        
        let nibCurationsRecsCell = UINib(nibName: "NewProductCurationsTableViewCell", bundle: nil)
        tableView.registerNib(nibCurationsRecsCell, forCellReuseIdentifier: "NewProductCurationsTableViewCell")
        
        let nibConversationsCell = UINib(nibName: "ProductPageButtonCell", bundle: nil)
        tableView.registerNib(nibConversationsCell, forCellReuseIdentifier: "ProductPageButtonCell")
        
        
    }
    
    func loadConversationsStats() {
        
        let productId = selectedProduct.productId
        let get = BVGet(type: BVGetTypeProducts)
        get.setFilterForAttribute("id", equality: BVEqualityEqualTo, value: productId)
        get.addStatsOn(BVIncludeStatsTypeReviews)
        get.addStatsOn(BVIncludeStatsTypeQuestions)
        get.sendRequestWithDelegate(self)
        
    }
    
    func loadNativeAd() {
        
        adLoader = GADAdLoader(
            adUnitID: "/5705/bv-incubator/EnduranceCyclesSale",
            rootViewController: self,
            adTypes: [ kGADAdLoaderAdTypeNativeContent ],
            options: nil
        )
        adLoader!.delegate = self
        
        let request = DFPRequest()
        request.customTargeting = BVSDKManager.sharedManager().getCustomTargeting()
        adLoader!.loadRequest(request)
        
    }
    
    func homeButtonPressed() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    
    }
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request: AnyObject!) {
        
        let results = ConversationsResponse<Product>(apiResponse: response).results

        guard let product = results.first, reviewStats = product.reviewStatistics, qaStats = product.qaStatistics else {
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.totalReviewCount = reviewStats["TotalReviewCount"] as? Int
            self.totalQuestionCount = qaStats["TotalQuestionCount"] as? Int
            self.totalAnswerCount = qaStats["TotalAnswerCount"] as? Int
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    func setPriceShrinkPercentage(percentageShrink: CGFloat) {
        let fontSize = 20 - (20 * percentageShrink)
        
        productPrice.font = UIFont(name: productPrice.font.fontName, size: fontSize)
        productPrice.textColor = productPrice.textColor.colorWithAlphaComponent(1.0 - percentageShrink)
    }
    
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ProductDetailSection.count()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.updateProductImageHeight()
        
    }
    
    func sdkIsConfiguredFor(product: ProductDetailSection) -> Bool {
        
        let sdk = BVSDKManager.sharedManager()
        
        // if we're in demo mode, we are configured for everything
        if (sdk.apiKeyCurations == "REPLACE_ME"
            && sdk.apiKeyConversations == "REPLACE_ME"
            && sdk.apiKeyShopperAdvertising == "REPLACE_ME") {
            return true
        }
      
        // check which product we're configured to use
        switch product {
            case .Ratings, .Questions:
                return BVSDKManager.sharedManager().apiKeyConversations != "REPLACE_ME"
            case .Curations, .CurationsAddPhoto:
                return BVSDKManager.sharedManager().apiKeyCurations != "REPLACE_ME"
            case .Recommendations:
                return BVSDKManager.sharedManager().apiKeyShopperAdvertising != "REPLACE_ME"
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            
            case ProductDetailSection.Ratings.rawValue:
                return sdkIsConfiguredFor(.Ratings) ? 1 : 0
            
            case ProductDetailSection.Questions.rawValue:
                return sdkIsConfiguredFor(.Questions) ? 1 : 0
            
            case ProductDetailSection.Recommendations.rawValue:
                return sdkIsConfiguredFor(.Recommendations) ? 1 : 0
            
            case ProductDetailSection.Curations.rawValue:
                return sdkIsConfiguredFor(.Curations) ? 1 : 0
            
            case ProductDetailSection.CurationsAddPhoto.rawValue:
                return sdkIsConfiguredFor(.CurationsAddPhoto) ? 1 : 0
            
            default:
                return 0
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.min
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == ProductDetailSection.Ratings.rawValue {
            return CGFloat.min
        }
        else if section == ProductDetailSection.Curations.rawValue {
            return CGFloat.min
        }
        else {
            return 18
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()

        if indexPath.section == ProductDetailSection.Recommendations.rawValue {
            
            let recsCell = tableView.dequeueReusableCellWithIdentifier("NewProductRecsTableViewCell") as! NewProductRecsTableViewCell
            
            recsCell.referenceProduct = self.selectedProduct
            recsCell.parentViewController = self
            
            recsCell.onProductRecTapped = {
                (selectedProduct) -> Void in
                
                let productView = NewProductPageViewController(nibName:"NewProductPageViewController", bundle: nil, product: selectedProduct)
                
                self.navigationController?.pushViewController(productView, animated: true)
                
                
            }
            
            return recsCell
            
        }
            
        if indexPath.section == ProductDetailSection.Curations.rawValue {
            
            let curationsCell = tableView.dequeueReusableCellWithIdentifier("NewProductCurationsTableViewCell") as! NewProductCurationsTableViewCell
            
            curationsCell.product = selectedProduct
            
            curationsCell.onFeedItemTapped = {
                (selectedIndex, feedItems) -> Void in
                // navigate to lightbox
                let targetVC = CurationsFeedMasterViewController()
                
                let titleLabel = UILabel(frame: CGRectMake(0,0,200,44))
                titleLabel.text = "Social Feed";
                titleLabel.textColor = UIColor.whiteColor()
                titleLabel.textAlignment = .Center
                titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
                targetVC.navigationItem.titleView = titleLabel
                
                targetVC.socialFeedItems = feedItems
                targetVC.startIndex = selectedIndex
                self.navigationController?.pushViewController(targetVC, animated: true)
            }
            
            return curationsCell
            
        }
        
        if indexPath.section == ProductDetailSection.Ratings.rawValue {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductPageButtonCell") as! ProductPageButtonCell
            
            cell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.button.addTarget(self, action: "ratingsButtonPressed", forControlEvents: .TouchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.commentsIconWithSize)
            cell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
            
            if let count = totalReviewCount {
                
                cell.button.setTitle("\(count) Reviews", forState: .Normal)

            }
            
            return cell
            
        }
        
        if indexPath.section == ProductDetailSection.Questions.rawValue {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductPageButtonCell") as! ProductPageButtonCell
            
            cell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.button.addTarget(self, action: "questionsButtonPressed", forControlEvents: .TouchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.questionCircleIconWithSize)
            cell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
            
            if let count = totalQuestionCount, let answerCount = totalAnswerCount {
                
                cell.button.setTitle("\(count) Questions, \(answerCount) Answers", forState: .Normal)
                
            }
            
            return cell
            
        }
        
        if indexPath.section == ProductDetailSection.CurationsAddPhoto.rawValue {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductPageButtonCell") as! ProductPageButtonCell
            
            cell.button.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell.button.addTarget(self, action: "curationsAddPhotoPressed", forControlEvents: .TouchUpInside)
            cell.setCustomLeftIcon(FAKFontAwesome.cameraRetroIconWithSize)
            cell.setCustomRightIcon(FAKFontAwesome.chevronRightIconWithSize)
            cell.button.setTitle("Add your photo!", forState: .Normal)
            
            return cell
            
        }
                
        // should not get here...
        return cell
        
    }
    
    func ratingsButtonPressed() {
        
        let ratingsVC = RatingsAndReviewsViewController(
            nibName: "RatingsAndReviewsViewController",
            bundle: nil,
            product: selectedProduct
        )
        self.navigationController?.pushViewController(ratingsVC, animated: true)
        
    }
    
    func questionsButtonPressed() {
        
        let questionsVC = QuestionAnswerViewController(
            nibName: "QuestionAnswerViewController",
            bundle: nil,
            product: selectedProduct
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
        
        submitPhotoVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(submitPhotoVC, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    //MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeContentAd nativeContentAd: GADNativeContentAd!) {
        self.nativeContentAd = nativeContentAd
        self.tableView.reloadData()
    }
    
    func adLoader(adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("failed to load ad!")
        print("error: \(error)")
    }
    
}

