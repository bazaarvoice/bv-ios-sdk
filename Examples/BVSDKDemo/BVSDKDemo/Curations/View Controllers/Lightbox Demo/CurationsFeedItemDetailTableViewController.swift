//
//  CurationsFeedItemDetailTableViewController.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage
import AVKit
import AVFoundation

class CurationsFeedItemDetailTableViewController: UITableViewController {
    
    var itemIndex: Int = 0
    var feedItem : BVCurationsFeedItem?
    
    var hasNext : Bool!  // When used in a pageview controller, does this have a next controller?
    var hasPrev : Bool!  // When used in a pageview controller, does this have a previous controller?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileUtils.trackViewController(self)
        
        self.tableView.registerNib(UINib(nibName: "CurationsFeedItemDetailCell", bundle: nil), forCellReuseIdentifier: "CurationsFeedItemDetailCell")
        
        self.tableView.registerNib(UINib(nibName: "ProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailTableViewCell")
        
        self.tableView.registerNib(UINib(nibName: "CurationsImageTableViewCell", bundle: nil), forCellReuseIdentifier: "CurationsImageTableViewCell")
        
        self.tableView.registerNib(UINib(nibName: "CurationsYouTubePlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "CurationsYouTubePlayerTableViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            if feedItem!.videos.count > 0 {
    
               let video : BVCurationsVideo = feedItem!.videos.first!;
               
                if (video.origin == "instagram") {
                    
                    // instagram - play video with AV player
                    
                    let videoURL = NSURL(string: video.remoteUrl)
                    let player = AVPlayer(URL: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.presentViewController(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }

                } else {
                    
                    // Have not yet tested out this video support.
                    
                    SweetAlert().showAlert("\(video.origin) is not yet supported in the demo app.", subTitle: "This feature is currenlty under development.", style: AlertStyle.Warning)
                    
                }
                
                
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let frame = CGRectMake(0, 0, tableView.bounds.width, 22)
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.clearColor()
        
            let labelFrame = CGRectMake(8, 0, tableView.bounds.width, 22)
            let titleLabel = UILabel(frame: labelFrame)
            titleLabel.text = "Shop Now"
            view.addSubview(titleLabel)
            
            return view
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return 3
        }
        
        if section == 1 {
            return 22
        }
        
        return 0
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (feedItem?.referencedProducts.count)! > 0 ? 2 : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        } else if section == 1 {
            return (feedItem?.referencedProducts.count)!
        }
        
        
        return 0;
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
           
            if (indexPath.row == 0){
                
                let imageCell = tableView.dequeueReusableCellWithIdentifier("CurationsImageTableViewCell") as! CurationsImageTableViewCell
            
                return imageCell.bounds.size.height
                
            } else if (indexPath.row == 1){
            
                let detail1Cell = tableView.dequeueReusableCellWithIdentifier("CurationsFeedItemDetailCell") as! CurationsFeedItemDetailCell
                return detail1Cell.bounds.size.height
                
            }

        } else if indexPath.section == 1 {
            
            let productCell = tableView.dequeueReusableCellWithIdentifier("ProductDetailTableViewCell") as! ProductDetailTableViewCell
            return productCell.bounds.size.height
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if (indexPath.section == 0){
            
            // Curations post meta-info
            // detail summary of the curations item. This always appears
            
            if (indexPath.row == 0){
                
                var video : BVCurationsVideo?
                
                // Check if this is a youtube video
                if (feedItem!.videos.count > 0){
                    video = feedItem!.videos.first!;
                
                }
                
                if (video != nil && video?.origin == "youtube"){
                    
                    // image view
                    let youTubeCell = tableView.dequeueReusableCellWithIdentifier("CurationsYouTubePlayerTableViewCell") as! CurationsYouTubePlayerTableViewCell
                    
                    //youTubeCell.feedItem = self.feedItem!
                    
                    // set flags so the cell knows whether or not to display there are prev/next pages.
                    // If you don't set the flags the chevron icons will always show
                    youTubeCell.hasPrev = self.hasPrev
                    youTubeCell.hasNext = self.hasNext
                    youTubeCell.video = video
                    
                    return youTubeCell
                    
                } else {
                    
                    // image view
                    let imageCell = tableView.dequeueReusableCellWithIdentifier("CurationsImageTableViewCell") as! CurationsImageTableViewCell
                    
                    imageCell.feedItem = self.feedItem!
                    
                    // set flags so the cell knows whether or not to display there are prev/next pages.
                    // If you don't set the flags the chevron icons will always show
                    imageCell.hasPrev = self.hasPrev
                    imageCell.hasNext = self.hasNext
                    
                    return imageCell
                }
                
            } else if (indexPath.row == 1){
                
                // social post details
                
                let detail1Cell = tableView.dequeueReusableCellWithIdentifier("CurationsFeedItemDetailCell") as! CurationsFeedItemDetailCell
                detail1Cell.feedItem = self.feedItem!
                
                // Demonstration on getting user events to re-share contributions
                detail1Cell.onSocialButtonTapped = { (socialOutlet, feedItemSelected) -> Void in
                    
                    var itemType : String?
                    
                    switch socialOutlet {
                    
                        case SocialOutlet.Pinterest:
                            itemType = "Pinterest"
                            break
                        
                        case SocialOutlet.Twitter:
                            itemType = "Twitter"
                            break
                          
                        case SocialOutlet.Email:
                            itemType = "Email"
                            break
                         
                        case SocialOutlet.Retweet:
                            itemType = "Retweet"
                            break
                           
                        case SocialOutlet.ReplyComment:
                            itemType = "ReplyComment"
                            break
                        
                        case .UserProfile:
                            itemType = "UserProfile"
                            if (feedItemSelected.author.profile != nil){
                                let url = NSURL(string: feedItemSelected.author.profile)
                                UIApplication.sharedApplication().openURL(url!)
                            } else {
                                print("ERROR: Nil author profile.")
                            }
                            
                        break
                        
                    }

                   print("Selected " + itemType! +  " on item: " + feedItemSelected.description)
                    
                }
                
                return detail1Cell
                
            }
           
        }
        
        else {

            // Refernced Product details
            // Product info tagged in this feed. This will not be present in all feeds
            
            let productDetailCell = tableView.dequeueReusableCellWithIdentifier("ProductDetailTableViewCell") as! ProductDetailTableViewCell!
            let product = feedItem!.referencedProducts[indexPath.row]
            productDetailCell.product = product
            
            // utilize closure to get the product the user tapped the "Shop Now" button on.
            productDetailCell.onShopNowButtonTapped = { (selectedProduct) -> Void in
                
                print("Shop Now Selected: " + selectedProduct.description)
                
                // Demo just to navigate to a page. Really we'd navigate to the native product page here.
                
                let bvProduct = BVRecommendedProduct()
                bvProduct.productId = product.productId
                bvProduct.productName = product.productName
                bvProduct.imageURL = product.productImageUrl
                
                let productView = NewProductPageViewController(nibName:"NewProductPageViewController", bundle: nil, product: bvProduct)
                
                self.navigationController?.pushViewController(productView, animated: true)
                                
            }
            return productDetailCell!
        }
        
        // Will never get here, just keepting Swift compiler happy :/
        return UITableViewCell()
    }
    
}
