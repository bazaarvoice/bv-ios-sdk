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
        
        recommendationsView.register(UINib(nibName: "DemoCell", bundle: nil), forCellWithReuseIdentifier: "DemoCellIdentifier")
        
        self.recommendationsView.delegate = self
        self.recommendationsView.dataSource = self
        
        let request = BVRecommendationsRequest(limit: 20)
        
        self.recommendationsView.load(request, completionHandler: { (recommendations:[BVRecommendedProduct]) in
            
            self.recommendations = recommendations
            self.recommendationsView.reloadData()
            
        }) { (error) in
            // handle error case
            print("Error Loading Recommendations")
        }
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = (recommendationsView.collectionViewLayout) as! UICollectionViewFlowLayout
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        layout.itemSize = CGSize(width: recommendationsView.bounds.width / 2, height: recommendationsView.bounds.width / 2)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendations.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DemoCellIdentifier", for: indexPath as IndexPath) as! DemoCell
            
            let product = recommendations[indexPath.row]
            
            // Must set the bvProduct on each cell
            cell.bvRecommendedProduct = product
            
            return cell;
    }
    
    
    // MARK UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected product: %@", recommendations[indexPath.row])
    }
    

}
