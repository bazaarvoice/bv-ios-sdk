//
//  ViewController.swift
//  ConversationsExample
//
//  Created by Tim Kelly on 5/24/16.
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ViewController: UIViewController, BVDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loadReviewsTapped(sender: AnyObject) {
        
        // This is the most minimal of Conversations requests.
        // For fetching Conversations content, such as reviews and questions,
        // explore the other options in the BVGet request object.
        let request = BVGet(type: BVGetTypeReviews)
        request.sendRequestWithDelegate(self)
        
    }
   
    
    // MARK: BVDelegate
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request:
        AnyObject!) {
        print("Raw Response: ", response)
    }
    

}

