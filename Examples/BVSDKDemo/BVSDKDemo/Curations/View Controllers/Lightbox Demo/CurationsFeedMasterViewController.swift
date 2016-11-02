//
//  CurationsFeedPageViewController.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class CurationsFeedMasterViewController: UIViewController, UIPageViewControllerDataSource {

    private var pageViewController: UIPageViewController?
    
    var socialFeedItems : [BVCurationsFeedItem]?
    var startIndex : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: 44))
        titleLabel.text = "Social Feed";
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        
        createPageViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = UIInterfaceOrientation.portrait.rawValue;
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate : Bool {
        
        return true
    }
    
    private func createPageViewController() {
        
        let pageController = UIPageViewController(nibName: "CurationsFeedPageViewController", bundle: nil)
                
        pageController.dataSource = self
        
        if socialFeedItems!.count > 0 {
            let firstController = getItemController(self.startIndex)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    // navigate to previous controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CurationsFeedItemDetailTableViewController
        
        if startIndex > 0{
            startIndex -= 1
            return getItemController(startIndex)
        }
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    // navigate to next controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! CurationsFeedItemDetailTableViewController
        
        if itemController.itemIndex+1 < self.socialFeedItems!.count {
            return getItemController(itemController.itemIndex+1)
        }
        

        return nil
    }
    
    private func getItemController(_ itemIndex: Int) -> CurationsFeedItemDetailTableViewController? {
        
        if itemIndex < self.socialFeedItems!.count {
            
            let pageItemController = CurationsFeedItemDetailTableViewController(nibName: "CurationsFeedItemDetailTableViewController", bundle: nil)
            
            pageItemController.itemIndex = itemIndex
            
            pageItemController.feedItem = self.socialFeedItems![itemIndex]
            
            pageItemController.hasPrev = (itemIndex == 0) ?  false : true
            
            pageItemController.hasNext = (itemIndex+1 == self.socialFeedItems?.count) ? false : true
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return socialFeedItems!.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
