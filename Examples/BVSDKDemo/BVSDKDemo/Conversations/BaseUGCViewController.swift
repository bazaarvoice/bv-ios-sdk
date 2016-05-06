//
//  BaseUGCViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class BaseUGCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let product : BVProduct
    
    @IBOutlet weak var header : ProductDetailHeaderView!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var spinner = Util.createSpinner()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product:BVProduct) {
        
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.appBackground()
        
        spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
        
        header.product = product
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    // MARK: UITableViewDatasource
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        assert(false, "Child class of BaseUGCViewController should implement tableView:numberOfRowsInSection")
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //assert(false, "Child class of BaseUGCViewController should implement tableView:numberOfRowsInSection")
        return UITableViewCell()
        
    }
    
}
