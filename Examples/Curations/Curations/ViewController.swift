//
//  ViewController.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import OHHTTPStubs
import SDWebImage
import AVKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var feedCarousel: BVCurationsCollectionView!
    
    @IBOutlet weak var summaryLabel1: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!

    var curationsFeedItems:[BVCurationsFeedItem]?
    var feedParams : BVCurationsFeedRequest?
    
    let spinner = Util.createSpinner()
    let errorLabel = Util.createErrorLabel()
    
    var feedCellWidth : CGFloat?
    
    var PARALLAX_VELOCITY : CGFloat =  20.0
    
    var isPortrait : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setRootViewStyle()
        
        let groups = CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS
        self.feedParams = BVCurationsFeedRequest(groups: groups)
        self.feedParams?.limit = 40
        self.feedParams?.hasVideo = false
        self.feedParams?.hasPhoto = true
        self.feedParams?.withProductData = true

        if (!CurationsDemoConstants.isSDKConfigured()){
            
            SweetAlert().showAlert("BVSDK not configured!", subTitle: "Please set your Curations API Key and Client ID in CurationsDemoConstants.swift.\n\nLocal static data will be used until you have configured the BVSDK properly.", style: AlertStyle.Warning)
            
            BVSDKManager.sharedManager().staging = true
            
            self.useMockDataConfig()
        
        } else if (self.feedParams?.groups.count == 0){
            
            SweetAlert().showAlert("BVSDK not configured!", subTitle: "Curations will not wok without 'groups' defined. Please define your 'groups' in CurationsDemoConstants.swift.\n\nUsing local demo data.", style: AlertStyle.Warning)
            
            self.useMockDataConfig()
            
        }

        // camera icon, for uploading custom Curations post
        let cameraBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doCustomCurationsPost"))
        self.navigationItem.leftBarButtonItem = cameraBarButtonItem
        
        self.feedCarousel.registerNib(UINib(nibName: "DemoCurationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCurationsCollectionViewCell")
        
        self.feedCarousel.delegate = self;
        self.feedCarousel.dataSource = self;
        
        self.loadCurationsFeed()
        
        self.isPortrait = UIDevice.currentDevice().orientation.isPortrait.boolValue ?? false
        
        self.PARALLAX_VELOCITY = self.isPortrait! ? 20 : 6

    }

    func doCustomCurationsPost(){
        
        let shareRequest = BVCurationsAddPostRequest(groups: CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS, withAuthorAlias: "anonymous", withToken: "anonymous_coward", withText: "")
        
        let submitPhotoVC = DemoCustomPostViewController(shareRequest: shareRequest, placeholderText: "Say Hey!")
        submitPhotoVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext;
        
        self.presentViewController(submitPhotoVC, animated: true, completion: { () -> Void in
            // completion
        });
        
    }
    
    // If the SDK is not configured properly, load static data
    func useMockDataConfig(){
      
        self.feedParams!.groups = ["livebv"]
        
        OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            // only mock data from the BV API requests.
            return (request.URL?.host?.containsString("api.bazaarvoice.com"))!
            }) { (request) -> OHHTTPStubsResponse in
                // 
                
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("curationsFeed.json", self.dynamicType)!, statusCode:200, headers:["Content-Type":"application/json"])
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let layout = (feedCarousel.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(feedCarousel.bounds.height, feedCarousel.bounds.height)
        
        if isPortrait == true {
            layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            layout.itemSize = CGSizeMake(feedCarousel.bounds.height, feedCarousel.bounds.height)
            self.summaryLabel1.text = "Harness the wealth of social media content tailored for your marketing needs and display it right where it can go to work delivering engagement, trust, and conversation: your mobile experience.\n\nOur new social media curations platform allows you to build engaging experiences on your site with high-quality, relavant, social content backed by Bazaarvoice's experience in moderation."
            self.titleLabel.text = "Curations"
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
            
        } else {
            
            // In landscape hide text summary and switch to vertically scrolling with 3 columns and tight cells
            layout.scrollDirection = UICollectionViewScrollDirection.Vertical
            layout.itemSize = CGSizeMake(feedCarousel.bounds.width / 3, feedCarousel.bounds.height - 20)
            self.summaryLabel1.text = ""
        
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
    }
    
    func loadCurationsFeed(){
        
        self.feedCarousel.addSubview(self.spinner)
        self.spinner.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, self.feedCarousel.bounds.size.height/2)
        
        self.errorLabel.removeFromSuperview()
        
        self.feedCarousel.loadFeedWithRequest(feedParams!, withWidgetId: nil, completionHandler: { (feedItems) -> Void in
                // completion - closure from request returned on main thread
                self.spinner.removeFromSuperview()
                self.curationsFeedItems = feedItems
                self.feedCarousel.reloadData()
            }) { (error) -> Void in
                // error - closure from request returned on main thread
                self.spinner.removeFromSuperview()
                self.errorLabel.frame = self.feedCarousel.bounds
                self.feedCarousel.addSubview(self.errorLabel)
                
                print("ERROR: Curations feed could not be retrieved. Error: " + error.localizedDescription)
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            self.isPortrait = false;
        } else {
            self.isPortrait = true;
        }
        
        self.feedCarousel.reloadItemsAtIndexPaths(self.feedCarousel.indexPathsForVisibleItems())
        
        self.PARALLAX_VELOCITY = self.isPortrait! ? 20 : 6
    }
    
    
    func setRootViewStyle() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        self.navigationController?.navigationBar.barStyle = .Black;
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let titleLabel = UILabel(frame: CGRectMake(0,0,200,44))
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        self.navigationItem.titleView = titleLabel
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.curationsFeedItems?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCurationsCollectionViewCell", forIndexPath: indexPath) as! DemoCurationsCollectionViewCell
        
        let feedItem : BVCurationsFeedItem = self.curationsFeedItems![indexPath.row]
        
        cell.feedItem = feedItem;
        
        //set offset accordingly
        self.feedCellWidth = cell.frame.size.width
        
        let xOffset : CGFloat = ((self.feedCarousel.contentOffset.x - cell.frame.origin.x) / self.feedCellWidth!) * PARALLAX_VELOCITY
        cell.imageOffset = CGPointMake(xOffset, 0.0)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let feedItem : BVCurationsFeedItem = curationsFeedItems![indexPath.row]
        
        print("Selected: " + feedItem.description)
        
        let targetVC = CurationsFeedMasterViewController()
        
        let titleLabel = UILabel(frame: CGRectMake(0,0,200,44))
        titleLabel.text = "Social Feed";
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        targetVC.navigationItem.titleView = titleLabel
        
        targetVC.socialFeedItems = self.curationsFeedItems
        targetVC.startIndex = indexPath.row
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        for cell : DemoCurationsCollectionViewCell in self.feedCarousel.visibleCells() as! [DemoCurationsCollectionViewCell] {
            
            let xOffset : CGFloat = ((self.feedCarousel.contentOffset.x - cell.frame.origin.x) / self.feedCellWidth!) * PARALLAX_VELOCITY
            cell.imageOffset = CGPointMake(xOffset, 0.0)
        }
        
    }
    
}

