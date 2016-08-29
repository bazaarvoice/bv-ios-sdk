//
//  CurationsPhotoMapViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import MapKit
import BVSDK

// 3rd Party
import SDWebImage

class CurationsPhotoMapViewController: UIViewController, MKMapViewDelegate {
    
    var curationsFeed : [BVCurationsFeedItem] = []
    
    init(curationsFeed : [BVCurationsFeedItem]){
        self.curationsFeed = curationsFeed
        super.init(nibName: nil, bundle: nil)
        self.title = "Curations Photo Map"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MKMapView(frame: self.view.bounds)
        mapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        // Annotations
        mapView.addAnnotations(self.annotations())
    }
    
    func annotations() -> [JPSThumbnailAnnotation]{
        
        var annotationThumbs : [JPSThumbnailAnnotation] = []
        
        var thumbId : UInt = 0
        for feedItem in self.curationsFeed {
            
            let location : BVCurationsCoordinates = feedItem.coordinates
            
            if location.longitude != nil && location.latitude != nil {
                
                let currThumb = JPSThumbnail()
            
                if feedItem.photos != nil && feedItem.photos.count > 0 {
                     currThumb.imageURL = NSURL(string: feedItem.photos[0].imageServiceUrl)
                } else {
                    continue; // skip anything that doesn't have any image
                }
        
                currThumb.title = feedItem.author.username
                currThumb.subtitle = feedItem.channel
                currThumb.coordinate = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue)
                currThumb.thumbId = thumbId
                
                currThumb.disclosureBlock = {
                    
                    // navigate to the curations lightbox from the user-selected image from the map annotation
                    
                    let targetVC = CurationsFeedMasterViewController()
                    
                    let titleLabel = UILabel(frame: CGRectMake(0,0,200,44))
                    titleLabel.text = "Social Feed";
                    titleLabel.textColor = UIColor.whiteColor()
                    titleLabel.textAlignment = .Center
                    targetVC.navigationItem.titleView = titleLabel
                    
                    targetVC.socialFeedItems = self.curationsFeed
                    targetVC.startIndex = Int(currThumb.thumbId)
                    self.navigationController?.pushViewController(targetVC, animated: true)
                    
                }
                
                annotationThumbs.append(JPSThumbnailAnnotation(thumbnail: currThumb))
                thumbId = thumbId + 1
            }
            
        }
        
        return annotationThumbs
    }
        
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.conformsToProtocol(JPSThumbnailAnnotationViewProtocol) {
            (view as! JPSThumbnailAnnotationViewProtocol).didSelectAnnotationViewInMap(mapView)
        }
        
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.conformsToProtocol(JPSThumbnailAnnotationViewProtocol) {
            (view as! JPSThumbnailAnnotationViewProtocol).didDeselectAnnotationViewInMap(mapView)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.conformsToProtocol(JPSThumbnailAnnotationProtocol) {
            return (annotation as! JPSThumbnailAnnotationProtocol).annotationViewInMap(mapView)
        }
            return nil
        
    }
    
}
