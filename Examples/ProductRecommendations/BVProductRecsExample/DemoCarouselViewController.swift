//
//  CarouselViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class DemoCarouselViewController: UIViewController, BVRecommendationsUIDelegate {
    
    @IBOutlet weak var descriptionLabel : UILabel?
    @IBOutlet weak var carouselView : BVRecommendationsCarouselView?
    @IBOutlet weak var carouselViewHeight : NSLayoutConstraint?
    var starColor = UIColor.blackColor()
    var starsHidden = false
    var useCustomStars = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        carouselView?.layer.borderWidth = 0.5
        carouselView?.layer.cornerRadius = 4;
        
        carouselView?.cellHorizontalSpacing = 8;
        carouselView?.leftAndRightPadding = 8;
        carouselView?.topAndBottmPadding = 8;
        
        carouselView?.delegate = self;
        
        configureStarColor(0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.view.bounds.size.height <= 500 {
            self.descriptionLabel!.text = ""
        }
    }
    
    @IBAction func HideStarsChangedValue(sender: UISwitch) {
        starsHidden = sender.on
        carouselView?.reloadView()
    }
    
    @IBAction func CustomStarsChangedValue(sender: UISwitch) {
        useCustomStars = sender.on
        carouselView?.reloadView()
    }
    
    @IBAction func CarouselHeightSliderChangedValue(sender: UISlider) {
        carouselViewHeight?.constant = CGFloat(sender.value)
        carouselView?.reloadView()
    }
    
    @IBAction func SelectedStarColor(sender: UISegmentedControl) {
        configureStarColor(sender.selectedSegmentIndex)
        carouselView?.reloadView()
    }
    
    func configureStarColor(selectedIndex:Int) {
        if selectedIndex == 0 {
            self.starColor = UIColor(red: 1.0, green: 0.73, blue: 0.04, alpha: 1.0) // yellow
        }
        else {
            self.starColor = UIColor(red: 0.10, green: 0.76, blue: 0.03, alpha: 1.0) // green
        }
    }
    
    //MARK: - BVRecommendationsUIDelegate
    
    func styleRecommendationsView(recommendationsView: BVRecommendationsSharedView!) {
        // example delegate method
        recommendationsView.starsAndReviewStatsHidden = self.starsHidden
        recommendationsView.starsColor = self.starColor
        
        if useCustomStars {
            recommendationsView.starsEmptyImage = UIImage(named: "like-unselected.png")
            recommendationsView.starsFilledImage = UIImage(named: "heart-filled.png")
        }
        else {
            recommendationsView.starsEmptyImage = nil
            recommendationsView.starsFilledImage = nil
        }
        
    }
    
    func didSelectProduct(product: BVProduct!) {
        // example delegate method
        // you may want to navigate the user to the product page, since they clicked on the product
        print("User selected product in carousel: \(product.name)")
    }
    
    func didFailToLoadWithError(err: NSError!) {
        // example delegate method
        print("didFailToLoadWithError: called from CarouselViewController. \(err.localizedDescription)")
    }
    
    func didLoadUserRecommendations(profileRecommendations: BVShopperProfile!) {
        // example delegate method
    }
    
}