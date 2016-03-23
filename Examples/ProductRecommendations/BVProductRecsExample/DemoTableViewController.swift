//
//  DemoTableViewController.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : BVProductRecommendationsTableView!
    
    var recommendations:[BVProduct]?
    
    var spinner = Util.createSpinner()
    
    var errorLabel = Util.createErrorLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 300
        
        self.loadRecommendations()
        
        self.tableView.registerNib(UINib(nibName: "DemoTableViewCell", bundle: nil), forCellReuseIdentifier: "DemoTableViewCell")

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.spinner.center = self.view.center
        
    }
    
    func loadRecommendations() {
        
        self.view.addSubview(self.spinner)
        self.errorLabel.removeFromSuperview()
        
    
        let request = BVRecommendationsRequest(limit: 20)
        self.tableView.loadRequest(request, completionHandler: { (recommendations:[BVProduct]) in
            
            self.spinner.removeFromSuperview()
            self.recommendations = recommendations
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            
            self.spinner.removeFromSuperview()
            self.errorLabel.frame = self.view.bounds
            self.view.addSubview(self.errorLabel)
            print("Error: \(error.localizedDescription)")
            
        }
        
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendations?.count ?? 0;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("DemoTableViewCell", forIndexPath: indexPath) as! DemoTableViewCell
        
        let product = self.recommendations![indexPath.row]
        
        cell.bvProduct = product

        return cell
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = self.recommendations![indexPath.row]
        
        let productView = ProductPageViewController(nibName:"ProductPageViewController", bundle: nil)
        productView.title = product.productName
        productView.product = product
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.pushViewController(productView, animated: true)
        
    }
    
}
