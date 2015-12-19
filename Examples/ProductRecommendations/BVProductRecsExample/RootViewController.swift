//
//  RootViewController.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setRootViewStyle()
        
        pageMenu = createPageMenu()
        
        self.view.addSubview(pageMenu!.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        pageMenu!.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
    }
    
    func createPageMenu() -> CAPSPageMenu {
        // populate the page menu with a recommendations carousel view, static view, and table view controller.
        var controllerArray : [UIViewController] = []
        
        controllerArray.append(createCarousel())
        controllerArray.append(createTable())
        controllerArray.append(createStaticView())
        
        let parameters = getPageMenuParameters()
        
        return CAPSPageMenu(viewControllers: controllerArray, frame: self.view.bounds, pageMenuOptions: parameters)
    }
    
    func createCarousel() -> DemoCarouselViewController {
        let carousel = DemoCarouselViewController(nibName: "DemoCarouselViewController", bundle: nil)
        carousel.title = "Carousel"
        return carousel
    }
    
    func createTable() -> DemoTableViewController {
        
        let demoTableViewController = DemoTableViewController(nibName:"DemoTableViewController", bundle:nil)
        demoTableViewController.title = "TableViewController"
        return demoTableViewController
    }
    
    func createStaticView() -> DemoStaticViewController {
        let staticView = DemoStaticViewController(nibName:"DemoStaticViewController", bundle: nil)
        staticView.title = "StaticView"
        return staticView
    }
    
    func getPageMenuParameters() -> [CAPSPageMenuOption] {
        return [
            .MenuHeight(40),
            .SelectionIndicatorHeight(2),
            .ScrollMenuBackgroundColor(UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.bazaarvoiceTeal()),
            .SelectedMenuItemLabelColor(UIColor.bazaarvoiceTeal()),
            .UnselectedMenuItemLabelColor(UIColor.grayColor()),
            .MenuItemFont(UIFont.systemFontOfSize(16)),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .CenterMenuItems(true)
        ]
    }
    
    func setRootViewStyle() {
        
        self.view.backgroundColor = UIColor.bazaarvoiceNavy()
        
        // set "bazaarvoice:" logo in navigationBar
        let titleLabel = UILabel(frame: CGRectMake(0,0,200,40))
        titleLabel.text = "bazaarvoice:";
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "ForalPro-Regular", size: 36)
        self.navigationItem.titleView = titleLabel
    }
}
