//
//  ViewController.swift
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import BVSDK

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var recommendationsView : BVProductRecommendationsCollectionView!
    var recommendations : [BVRecommendedProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationsView.registerNib(UINib(nibName: "DemoCell", bundle: nil), forCellWithReuseIdentifier: "DemoCellIdentifier")
        
        self.recommendationsView.delegate = self
        self.recommendationsView.dataSource = self
        
        let request = BVRecommendationsRequest(limit: 20)
        self.recommendationsView.loadRequest(request, completionHandler: { (recommendations:[BVRecommendedProduct]) in
            
            self.recommendations = recommendations
            self.recommendationsView.reloadData()
            
        }) { (error:NSError) in
            // handle error case
        }
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = (recommendationsView.collectionViewLayout) as! UICollectionViewFlowLayout
        
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSizeMake(recommendationsView.bounds.width / 2, recommendationsView.bounds.width / 2)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendations.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DemoCellIdentifier", forIndexPath: indexPath) as! DemoCell
        
        let product = recommendations[indexPath.row]
        
        // Must set the bvProduct on each cell
        cell.bvRecommendedProduct = product
        
        return cell;
    }
    
    // MARK UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected product: %@", recommendations[indexPath.row])
    }


}
