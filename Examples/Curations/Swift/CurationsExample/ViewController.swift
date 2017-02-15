//
//  ViewController.swift
//  CurationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//
import UIKit
import BVSDK
import SDWebImage

class ViewController: UIViewController, BVCurationsUICollectionViewDelegate {
    
    @IBOutlet weak var curationsCollectionView: BVCurationsUICollectionView?
    @IBOutlet weak var stepper: UIStepper?
    
    @IBOutlet var heightConstraintGrid: NSLayoutConstraint!
    @IBOutlet var heightConstraintCarousel: NSLayoutConstraint!
    
    let sdMngr = SDWebImageManager.shared()
    let numRowsStart: UInt = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Curations UI display properties
        curationsCollectionView?.curationsDelegate = self
        curationsCollectionView?.groups = ["__all__"]
        curationsCollectionView?.fetchSize = 60
        curationsCollectionView?.infiniteScrollEnabled = true
        curationsCollectionView?.itemsPerRow = numRowsStart
        curationsCollectionView?.bvCurationsUILayout = .grid
        curationsCollectionView?.loadFeed()
        
        curationsCollectionView?.backgroundColor = UIColor.lightGray
        stepper?.value = Double(numRowsStart)
        // Add a bar button item so we can demo curations submission
        let submitButton  = UIBarButtonItem(title: "Add Photo",  style: .plain, target: self, action: #selector(didTapAddPhotoButton))
        self.navigationItem.rightBarButtonItem = submitButton
        
    }
    
    // This demo shows how to create a customized Share View Controller and upload an image and text to Curations.
    func didTapAddPhotoButton(_ sender: AnyObject) {
        
        // Here we load our request with the groups we want to subit to and additional info.
        let shareRequest = BVCurationsAddPostRequest(groups: [],
                                                     withAuthorAlias: "authorAlias",
                                                     withToken: "token",
                                                     withText: "Hello.")
        
        // We've hard-coded an image here for testing, where you would normally have the user select from a gallery or camera.
        shareRequest.image = UIImage(named: "curations_test_image")!
        
        // Now we just post the share view controller with a couple of styling options.
        let shareVC = BVCurationsPostViewController.init(postRequest: shareRequest,
                                                          logoImage: UIImage(named: "happy_icon")!,
                                                          bavBarColor: UIColor.orange,
                                                          navBarTintColor: UIColor.white)
        
        shareVC.placeholder = "Say something awesome\nabout your photo!"
        shareVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        
        shareVC.didPressCancel = {
            self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            print("User cancelled")
        }
        
        shareVC.didBeginPost = {
            // Here you could add your own spinner
            print("Beginning Post Submission...")
        }
        
        shareVC.didCompletePost = {(error) in
            // Here you could remove your spinner if added to the view
             self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            if error != nil {
                print("Ooops, the submissions failed: " + (error?.localizedDescription)!)
            } else {
                print("Successful submission!")
            }
        }
        
        self.navigationController?.present(shareVC, animated: true, completion: { 
            // completion
        })
        
    }
    
    @IBAction func updateRowCount(_ sender: UIStepper) {
        if (sender.value > 0) {
            if (curationsCollectionView?.bvCurationsUILayout == .carousel) {
                curationsCollectionView?.bvCurationsUILayout = .grid
                self.heightConstraintGrid.isActive = true
                heightConstraintCarousel.isActive = false
            }
            curationsCollectionView?.itemsPerRow = UInt(sender.value)
        }else {
            curationsCollectionView?.bvCurationsUILayout = .carousel
            heightConstraintGrid.isActive = false
            heightConstraintCarousel.isActive = true
            view.layoutIfNeeded()
        }
        
        view.layoutIfNeeded()
    }
    
    // MARK: BVCurationsUICollectionViewDelegate
    
    
    func curationsLoadImage(_ imageUrl: String, completion:@escaping BVSDK.BVCurationsLoadImageCompletion) {
        self.loadImage(imageUrl, completion: completion)
    }
    
    func curationsImageIsCached(_ imageUrl: String, completion:@escaping BVCurationsIsImageCachedCompletion) {
        
        self.sdMngr.cachedImageExists(for: URL(string: imageUrl)) { (cached) in
            completion(cached, imageUrl)
        }
    
    }
    
    func curationsDidSelect(_ feedItem: BVCurationsFeedItem) {
        print("Tapped: " + feedItem.debugDescription)
    }
    
    func curationsFailed(toLoadFeed error: Error) {
        print("An error occurred: " + error.localizedDescription)
    }
    
    fileprivate func loadImage(_ imageUrl: String, completion:@escaping ((UIImage, String) -> Void)) {
        
        _ = self.sdMngr.loadImage(with: URL(string: imageUrl)!,
                                  options: [],
                                  progress: { (_, _, _) in
                                    
        }, completed: { (image, _, _, _, _, url) in
            if let img = image {
                completion(img, imageUrl)
            }
        })
        
    }
}
