//
//  ReviewHighlightsDetailsViewController.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 28/03/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ReviewHighlightsDetailsViewController: UIViewController {
    
    @IBOutlet weak var view_Backgound: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_PresenceCount: UILabel!
    @IBOutlet weak var lbl_MentionsCount: UILabel!
    var bVReviewHighlight: BVReviewHighlight = BVReviewHighlight() {
        didSet {
            self.title = bVReviewHighlight.title?.capitalized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerCell()
        
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "ReviewHighlightsDetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewHighlightsDetailsTableViewCell")
    }
}

extension ReviewHighlightsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bVReviewHighlight.bestExamples?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewHighlightsDetailsTableViewCell", for: indexPath) as! ReviewHighlightsDetailsTableViewCell
        if let bestExample = self.bVReviewHighlight.bestExamples {
            cell.bVReviewHighligtsReview = bestExample[indexPath.row]
            print(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
