
import UIKit
import BVSDK
import MobileCoreServices

class StoreWriteReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    private static let RATING_CELL_REUSE_ID = "StoreRatingTableViewCell";
    private static let REVIEW_TITLE_CELL_REUSE_ID = "ReviewTitleTableViewCell"
    private static let RECOMMEND_STORE_CELL_REUSE_ID = "RecommendStoreTableViewCell"
    private static let REVIEW_TEXT_CELL_REUSE_ID = "ReviewInputTableViewCell"
    private static let ADD_CONTENT_CELL_REUSE_ID = "AddContentTableViewCell"
    private static let QULAITY_SLIDER_CELL_REUSE_ID = "QualitySliderTableViewCell"
    
    private var reviewTextView: MPTextView?
    private var reviewSubmissionParams = ReviewSubmissionParams()
    private var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    private var locationPickerView : LocationPickerView?
    
    var storeId: String? {
        didSet {
            let req = BVBulkStoreItemsRequest(storeIds: [storeId!])
            req.load({(response) in
                self.store = response.results.first
                self.refreshStoreData()
            }){(error) in
                
            }
        }
    }
    
    
    var store: BVStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presentingViewController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(StoreWriteReviewViewController.donePressed(_:)))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(StoreWriteReviewViewController.savePressed(_:)))
        self.title = NSLocalizedString("Store Review", comment: "Store Review")
        // Do any additional setup after loading the view.
        setUpLocationPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if store != nil {
            refreshStoreData()
        }
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        self.dismissSelf()
    }
    
    func dismissSelf(){
        
        if self.presentingViewController != nil {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func savePressed(_ sender: UIBarButtonItem) {
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        let reviewSubmission = BVStoreReviewSubmission(reviewTitle: reviewSubmissionParams.title as? String ?? "" ,
                                                       reviewText: reviewSubmissionParams.text as? String ?? "",
                                                       rating: UInt( reviewSubmissionParams.rating?.intValue ?? 0),
                                                       productId: (store?.identifier)!)
        
        reviewSubmission.action = BVSubmissionAction.preview
        sranddev()
        let userId = "123abc\(arc4random())"
        let userNickName = "userNN\(arc4random())"
        let userEmail = "user.email\(arc4random())@domain.com"
        
        reviewSubmission.user = userId
        reviewSubmission.userNickname = userNickName
        reviewSubmission.userEmail = userEmail
        reviewSubmission.isRecommended = Bool(reviewSubmissionParams.isRecommended as? Bool ?? false) as NSNumber?
        reviewSubmission.agreedToTermsAndConditions = true
        reviewSubmission.addRatingSlider("How was your experience?", value: "\(0)")
        if let photo = reviewSubmissionParams.photo {
            reviewSubmission.addPhoto(photo, withPhotoCaption: nil)
        }
        
        reviewSubmission.submit({ (response) in
            
            DispatchQueue.main.async(execute: {
                _ = SweetAlert().showAlert("Success!", subTitle: "Your review was submitted. It may take up to 72 hours before your post is live.", style: .success)
                self.dismissSelf()
            })
            
        }) { (errors) in
            
            DispatchQueue.main.async(execute: {
                _ = SweetAlert().showAlert("Error!", subTitle: errors.first?.localizedDescription, style: .error)
                self.spinner.removeFromSuperview()
            })
        }
    }
    
    private func setUpLocationPicker(){
        
        self.locationPickerView = LocationPickerView(frame: self.view.bounds)
        self.view.addSubview(self.locationPickerView!)
        
        self.locationPickerView!.tableViewDataSource = self
        self.locationPickerView!.tableViewDelegate = self
        self.locationPickerView!.mapViewDelegate = self
        
        // Optional parameters
        self.locationPickerView!.delegate = self
        self.locationPickerView!.shouldAutoCenterOnUserLocation = true
        self.locationPickerView!.shouldCreateHideMapButton = true
        self.locationPickerView!.pullToExpandMapEnabled = false
        self.locationPickerView!.defaultMapHeight = 220.0          // larger than normal
        self.locationPickerView!.parallaxScrollFactor = 0.3        // little slower than normal.
    }
    
    private func refreshStoreData() {
        
        if (store?.storeLocation?.latitude != nil
            && store?.storeLocation?.longitude != nil
            && self.locationPickerView?.mapView != nil){
            let lat = Double(store!.storeLocation!.latitude!)!
            let long = Double(store!.storeLocation!.longitude!)!
            let delta = 0.003
            
            var region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, long), MKCoordinateSpanMake(delta, delta))
            let ptAnn = MKPointAnnotation()
            ptAnn.coordinate = region.center
            self.locationPickerView?.mapView.addAnnotation(ptAnn)
            
            region.center.latitude -= 0.00065
            self.locationPickerView?.mapView.setRegion(region, animated: false)
        }
    }
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).row == 4 {
            
            if let presentingVC = self.presentingViewController {
                presentingVC.dismiss(animated: true) {
                    
                    let picker = self.getImagePicker()
                    picker.controllerToSwap = self
                    DispatchQueue.main.async{
                        presentingVC.present(picker, animated: true, completion: nil)
                    }
                }
            }else {
                self.present(getImagePicker(), animated: true, completion: nil)
            }
        }
        
        return
    }
    
    private func getImagePicker() -> BVImagePickerController {
        let picker = BVImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            reviewSubmissionParams.photo = pickedImage
            locationPickerView?.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        }
        dismissPickerShowVC(picker)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPickerShowVC(picker)
    }
    
    private func dismissPickerShowVC(_ picker: UIImagePickerController) {
        let bvPicker = picker as! BVImagePickerController
        if let vcToSwap = bvPicker.controllerToSwap  {
            let presentingVC = bvPicker.presentingViewController
            bvPicker.dismiss(animated: true) {
                DispatchQueue.main.async {
                    let navVC = UINavigationController(rootViewController: vcToSwap)
                    presentingVC?.present(navVC, animated: true, completion: nil)
                }
            }
        }else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: EditablePropertyTableViewCell!
        if ((indexPath as NSIndexPath).row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.RATING_CELL_REUSE_ID, for: indexPath) as! StoreRatingTableViewCell
            cell.keyPath = "rating"
        }else if ((indexPath as NSIndexPath).row == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.REVIEW_TITLE_CELL_REUSE_ID, for: indexPath) as! ReviewTitleTableViewCell
            cell.keyPath = "title"
        }else if ((indexPath as NSIndexPath).row == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.RECOMMEND_STORE_CELL_REUSE_ID, for: indexPath) as! RecommendStoreTableViewCell
            cell.keyPath = "isRecommended"
        }else if ((indexPath as NSIndexPath).row == 3) {
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.REVIEW_TEXT_CELL_REUSE_ID, for: indexPath) as! ReviewInputTableViewCell
            reviewCell.viewToMoveUp = locationPickerView?.tableView
            cell = reviewCell
            cell.keyPath = "text"
        }else if ((indexPath as NSIndexPath).row == 4) {
            let addCell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.ADD_CONTENT_CELL_REUSE_ID, for: indexPath) as! AddContentTableViewCell
            addCell.lable?.text = "Add Photo"
            if reviewSubmissionParams.photo == nil {
                addCell.iconImageView?.image = UIImage(named: "cameraIcon")
            }else {
                addCell.iconImageView?.image = reviewSubmissionParams.photo
            }
            
            return addCell
        }else if ((indexPath as NSIndexPath).row == 5) {
            cell = tableView.dequeueReusableCell(withIdentifier: StoreWriteReviewViewController.QULAITY_SLIDER_CELL_REUSE_ID, for: indexPath) as! QualitySliderTableViewCell
            cell.keyPath = "quality"
        }
        
        cell.object = reviewSubmissionParams
        return cell
    }
    
    
    // MARK: LocationPickerViewDelegate
    
    func locationPicker(_ locationPicker: LocationPickerView!, tableViewDidLoad tableView: UITableView!) {
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let ratingCellNib = UINib(nibName: StoreWriteReviewViewController.RATING_CELL_REUSE_ID, bundle: nil)
        tableView.register(ratingCellNib, forCellReuseIdentifier: StoreWriteReviewViewController.RATING_CELL_REUSE_ID)
        
        let reviewTitleCell = UINib(nibName: StoreWriteReviewViewController.REVIEW_TITLE_CELL_REUSE_ID, bundle: nil)
        tableView.register(reviewTitleCell, forCellReuseIdentifier: StoreWriteReviewViewController.REVIEW_TITLE_CELL_REUSE_ID)
        
        let recommendCell = UINib(nibName: StoreWriteReviewViewController.RECOMMEND_STORE_CELL_REUSE_ID, bundle: nil)
        tableView.register(recommendCell, forCellReuseIdentifier: StoreWriteReviewViewController.RECOMMEND_STORE_CELL_REUSE_ID)
        
        let reviewInputCell = UINib(nibName: StoreWriteReviewViewController.REVIEW_TEXT_CELL_REUSE_ID, bundle: nil)
        tableView.register(reviewInputCell, forCellReuseIdentifier: StoreWriteReviewViewController.REVIEW_TEXT_CELL_REUSE_ID)
        
        let addContentCell = UINib(nibName: StoreWriteReviewViewController.ADD_CONTENT_CELL_REUSE_ID, bundle: nil)
        tableView.register(addContentCell, forCellReuseIdentifier: StoreWriteReviewViewController.ADD_CONTENT_CELL_REUSE_ID)
        
        let qualitySliderCell = UINib(nibName: StoreWriteReviewViewController.QULAITY_SLIDER_CELL_REUSE_ID, bundle: nil)
        tableView.register(qualitySliderCell, forCellReuseIdentifier: StoreWriteReviewViewController.QULAITY_SLIDER_CELL_REUSE_ID)
    }
}

@objc class ReviewSubmissionParams: NSObject {
    var title: NSString?
    var text: NSString?
    var rating: NSNumber? = 5
    var isRecommended: NSNumber? = true
    var quality: NSNumber? = 5
    var photo: UIImage?
}

class BVImagePickerController: UIImagePickerController {
    var controllerToSwap: UIViewController?
}
