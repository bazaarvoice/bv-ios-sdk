//
//  ViewController.swift
//  CurationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var curationsCollectionView: BVCurationsCollectionView!
    
    var curationsFeedItems:[BVCurationsFeedItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.curationsCollectionView.registerNib(UINib(nibName: "DemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DemoCell")
        
        self.curationsCollectionView.delegate = self
        self.curationsCollectionView.dataSource = self
        
        let groups = ["__all__"]
        let feedRequest = BVCurationsFeedRequest(groups: groups)
        feedRequest.limit = 40
        feedRequest.hasPhoto = true
        feedRequest.withProductData = true
        
        self.curationsCollectionView.loadFeedWithRequest(feedRequest, withWidgetId: nil, completionHandler: { (feedItems) -> Void in
            // success
            // closure from request returned on main thread
            
            self.curationsFeedItems = feedItems as [BVCurationsFeedItem]
            self.curationsCollectionView.reloadData()
            
        }) { (error) -> Void in
            // error
            
            print("ERROR: Curations feed could not be retrieved. Error: " + error.localizedDescription)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = (curationsCollectionView.collectionViewLayout) as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(curationsCollectionView.bounds.height, curationsCollectionView.bounds.height)
        
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.itemSize = CGSizeMake(curationsCollectionView.bounds.width / 2, curationsCollectionView.bounds.width / 2)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    // MARK: UICollectionViewDatasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.curationsFeedItems?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCell", forIndexPath: indexPath) as! DemoCollectionViewCell
        
        let feedItem : BVCurationsFeedItem = self.curationsFeedItems![indexPath.row]
        
        cell.feedItem = feedItem
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let feedItem : BVCurationsFeedItem = curationsFeedItems![indexPath.row]
        
        print("Selected: " + feedItem.description)
        
    }
}