//
//  DemoCurations.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import OHHTTPStubs
import SDWebImage
import AVKit
import AVFoundation
import FontAwesomeKit

class DemoCurationsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var feedCarousel: BVCurationsCollectionView!
    @IBOutlet weak var summaryLabel: UILabel!
    
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
        
        let groups = CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS
        self.feedParams = BVCurationsFeedRequest(groups: groups)
        self.feedParams?.limit = 40
        self.feedParams?.hasVideo = false
        self.feedParams?.hasPhoto = true
        self.feedParams?.withProductData = true
        
        if (!CurationsDemoConstants.isSDKConfigured()){
            
            _ = SweetAlert().showAlert("BVSDK not configured!", subTitle: "Please set your Curations API Key and Client ID in CurationsDemoConstants.swift.\n\nLocal static data will be used until you have configured the BVSDK properly.", style: AlertStyle.warning)
            
            BVSDKManager.shared().staging = true
            
        } else if (self.feedParams?.groups.count == 0){
            
            _ = SweetAlert().showAlert("BVSDK not configured!", subTitle: "Curations will not wok without 'groups' defined. Please define your 'groups' in CurationsDemoConstants.swift.\n\nUsing local demo data.", style: AlertStyle.warning)
            
        }
        
        // camera icon, for uploading custom Curations post
        
        let cameraIcon = FAKFontAwesome.cameraIcon(withSize: 20)
        cameraIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: cameraIcon?.image(with: CGSize(width: 20, height: 20)),
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(DemoCurationsController.doCustomCurationsPost)
        )
        
        
        let nibName = "DemoCurationsCollectionViewCell"
        self.feedCarousel.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        
        self.feedCarousel.delegate = self;
        self.feedCarousel.dataSource = self;
        
        self.loadCurationsFeed()
        
        self.isPortrait = UIDevice.current.orientation.isPortrait 
        
        self.PARALLAX_VELOCITY = self.isPortrait! ? 20 : 6
        
    }
    
    func doCustomCurationsPost(){
        
        let shareRequest = BVCurationsAddPostRequest(groups: CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS, withAuthorAlias: "anonymous", withToken: "anonymous_coward", withText: "")
        
        let submitPhotoVC = DemoCustomPostViewController(shareRequest: shareRequest, placeholderText: "Say Hey!")
        submitPhotoVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        
        self.present(submitPhotoVC, animated: true, completion: { () -> Void in
            // completion
        });
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let layout = (feedCarousel.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: feedCarousel.bounds.height, height: feedCarousel.bounds.height)
        
        if isPortrait == true {
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            layout.itemSize = CGSize(width: feedCarousel.bounds.height, height: feedCarousel.bounds.height)
            self.summaryLabel.text = "Harness the wealth of social media content tailored for your marketing needs and display it right where it can go to work delivering engagement, trust, and conversation: your mobile experience.\n\nOur new social media curations platform allows you to build engaging experiences on your site with high-quality, relavant, social content backed by Bazaarvoice's experience in moderation."
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
            
        } else {
            
            // In landscape hide text summary and switch to vertically scrolling with 3 columns and tight cells
            layout.scrollDirection = UICollectionViewScrollDirection.vertical
            layout.itemSize = CGSize(width: feedCarousel.bounds.width / 3, height: feedCarousel.bounds.height - 20)
            self.summaryLabel.text = ""
            
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
    }
    
    func loadCurationsFeed(){
        
        self.feedCarousel.addSubview(self.spinner)
        self.spinner.frame.origin = CGPoint(x: UIScreen.main.bounds.size.width/2, y: self.feedCarousel.bounds.size.height/2)
        
        self.errorLabel.removeFromSuperview()
        
        self.feedCarousel.loadFeed(with: feedParams!, withWidgetId: nil, completionHandler: { (feedItems) -> Void in
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            self.isPortrait = false;
        } else {
            self.isPortrait = true;
        }
        
        self.feedCarousel.reloadItems(at: self.feedCarousel.indexPathsForVisibleItems)
        
        self.PARALLAX_VELOCITY = self.isPortrait! ? 20 : 6
    }
    
    // MARK: UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.curationsFeedItems?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCurationsCollectionViewCell", for: indexPath) as! DemoCurationsCollectionViewCell
        
        let feedItem : BVCurationsFeedItem = self.curationsFeedItems![(indexPath as NSIndexPath).row]
        
        cell.feedItem = feedItem;
        
        //set offset accordingly
        self.feedCellWidth = cell.frame.size.width
        
        let xOffset : CGFloat = ((self.feedCarousel.contentOffset.x - cell.frame.origin.x) / self.feedCellWidth!) * PARALLAX_VELOCITY
        cell.imageOffset = CGPoint(x: xOffset, y: 0.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feedItem : BVCurationsFeedItem = curationsFeedItems![(indexPath as NSIndexPath).row]
        
        print("Selected: " + feedItem.description)
        
        let targetVC = CurationsFeedMasterViewController()
        targetVC.socialFeedItems = self.curationsFeedItems
        targetVC.startIndex = (indexPath as NSIndexPath).row
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell : DemoCurationsCollectionViewCell in self.feedCarousel.visibleCells as! [DemoCurationsCollectionViewCell] {
            
            let xOffset : CGFloat = ((self.feedCarousel.contentOffset.x - cell.frame.origin.x) / self.feedCellWidth!) * PARALLAX_VELOCITY
            cell.imageOffset = CGPoint(x: xOffset, y: 0.0)
        }
        
    }
    
}

