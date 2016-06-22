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

let ADVERT_INDEX_PATH = 5

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GADNativeContentAdLoaderDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var recommendationsCollectionView: BVProductRecommendationsCollectionView!
    
    var recommendations:[BVProduct]?
    var spinner = Util.createSpinner()
    var errorLabel = Util.createErrorLabel()
    
    var adLoader : GADAdLoader?
    
    var currClientId : String?
    
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
        
        self.loadRecommendations()
        
        let versionString = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNum = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
        self.versionLabel.text = "v" + versionString! + "(" + buildNum! + ")"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check that user is logged in to facebook
        if (ProfileUtils.isFacebookInstalled()) {
            // The app ID was set so we can authenticate the user
            if(FBSDKAccessToken.currentAccessToken() == nil) {
                let loginViewController = FacebookLoginViewController()
                self.presentViewController(loginViewController, animated: true, completion: nil)
            }
            else {
                if let profile = FBSDKProfile.currentProfile() {
                    
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
            adLoader = GADAdLoader(adUnitID: "/5705/bv-incubator/IncubatorEnduranceCycles", rootViewController: self, adTypes: [kGADAdLoaderAdTypeNativeContent], options: nil)
            adLoader?.delegate = self
            
            let request = DFPRequest()
            //request.testDevices = [kDFPSimulatorID]
            request.customTargeting = BVSDKManager.sharedManager().getCustomTargeting()
            adLoader?.loadRequest(request)
        }
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
    
    func loadRecommendations() {
        
        // add loading icon
        self.recommendationsCollectionView.addSubview(self.spinner)
            
        self.errorLabel.removeFromSuperview()
        
        let request = BVRecommendationsRequest(limit: 20)
        self.recommendationsCollectionView.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            
            self.recommendationsCollectionView?.reloadData()
            
        }) { (error:NSError) in
            
            // remove loading icon
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.recommendationsCollectionView.bounds
            self.recommendationsCollectionView.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
            self.recommendationsCollectionView?.reloadData()
            
        }
        
    }
    
    // MARK: UICollectionViewDelegate / UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.recommendations != nil && self.recommendations!.count > 0 {
            return self.recommendations!.count + 2 // one for top banner, one for advertisement
        }
        else {
            return 0
        }
        
    }
    
    func getRecommendationForIndexPath(indexPath: NSIndexPath) -> BVProduct {
        
        let indexOffset = (indexPath.row > ADVERT_INDEX_PATH) ? 2 : 1

        return self.recommendations![indexPath.row - indexOffset]
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.cellType {
        case .Header:
            return CGSize(
                width: self.view.bounds.width,
                height: HomeHeaderCollectionViewCell.preferredHeightForWidth(self.view.bounds.width)
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
        
        case .Advertisement:
            
            self.initAdvertisement()
            
            return collectionView.dequeueReusableCellWithReuseIdentifier("HomeAdvertisementCollectionViewCell", forIndexPath: indexPath) as! HomeAdvertisementCollectionViewCell
        
        default:
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCarouselCollectionViewCell", forIndexPath: indexPath) as! DemoCarouselCollectionViewCell
            
            cell.bvProduct = getRecommendationForIndexPath(indexPath)
            
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
    
    func adLoader(var adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive advertisement: " + error.localizedDescription)
        self.adLoader = nil

    }
    
    
}

private enum CellType {
    case Header, Advertisement, ProductRecommendation
}

private extension NSIndexPath {
    var cellType : CellType {
        get {
            switch row {
                case 0: return .Header
                case ADVERT_INDEX_PATH: return .Advertisement
                default: return .ProductRecommendation
            }
        }
    }
}