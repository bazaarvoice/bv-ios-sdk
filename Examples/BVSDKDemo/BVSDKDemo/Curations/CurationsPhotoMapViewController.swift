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
    
    let distanceThreshold = 120000.0
    let minGroupZoom = 0.4
    let storeZoom = 0.025
    var hasShownDefault = false
    var curationsFeed : [BVCurationsFeedItem] = []
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var zoomOutBtn: UIButton!
    @IBOutlet var btnImage: UIImageView!
    
    var groupedFeedItems = [[BVCurationsFeedItem]]()
    var previousRegion:  MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Curations Photo Map"
        btnImage.image = btnImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        btnImage.tintColor = UIColor.redColor()
        btnImage.backgroundColor = UIColor.whiteColor()
        btnImage.layer.cornerRadius = btnImage.frame.width / 2
        mapView.addAnnotations(self.annotations)
    }
    
    override func viewDidAppear(animated: Bool) {
        if !hasShownDefault {
            hasShownDefault = true
            guard let store = LocationPreferenceUtils.getDefaultStore()else{ return }
            for ann in annotations {
                if ann.coordinate.latitude == Double(store.latitude) {
                    mapView.selectAnnotation(ann, animated: true)
                    break
                }
            }
        }
    }
    
    lazy var annotations: [JPSThumbnailAnnotation] = {
        [unowned self] in
        
        var annotationThumbs : [JPSThumbnailAnnotation] = []
        
        var idx : Int = 0
        for feedItem in self.curationsFeed {
            let location = feedItem.coordinates
            
            if let _ = location.longitude, _ = location.latitude, _ = feedItem.photos{
                if feedItem.photos.count == 0 {
                    continue; // skip anything that doesn't have any image
                }
                
                self.groupFeedItem(feedItem)
                
                let i = idx;
                let annotation = JPSThumbnailAnnotation(curationsFeedItem: feedItem) {
                    // navigate to the curations lightbox from the user-selected image from the map annotation
                    let targetVC = CurationsFeedMasterViewController()
                    targetVC.socialFeedItems = self.curationsFeed
                    targetVC.startIndex = i
                    self.navigationController?.pushViewController(targetVC, animated: true)
                }
                
                annotationThumbs.append(annotation)
                idx += 1
            }
        }
        
        return annotationThumbs
    }()
    
    private func groupFeedItem(feedItem: BVCurationsFeedItem){
        var itemGroup : [BVCurationsFeedItem]?
        for group in groupedFeedItems {
            for item in group {
                if getDistanceBetween(feedItem, feedItem2: item) < distanceThreshold {
                    itemGroup = group
                    let idx = groupedFeedItems.indexOf({$0 == itemGroup!})
                    groupedFeedItems.removeAtIndex(idx!)
                    break
                }
            }
            if let _ = itemGroup {
                break
            }
        }
        
        if itemGroup == nil {
            itemGroup = [BVCurationsFeedItem]()
        }
        
        itemGroup?.append(feedItem)
        groupedFeedItems.append(itemGroup!)
    }
    
    private func getDistanceBetween(feedItem1: BVCurationsFeedItem, feedItem2: BVCurationsFeedItem) -> Double {
        let loc1 = CLLocation(latitude: feedItem1.coordinates.latitude.doubleValue, longitude: feedItem1.coordinates.longitude.doubleValue)
        let loc2 = CLLocation(latitude: feedItem2.coordinates.latitude.doubleValue, longitude: feedItem2.coordinates.longitude.doubleValue)
        
        return loc1.distanceFromLocation(loc2)
    }
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            shouldHideZoomout(false)
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        shouldHideZoomout(false)
        if let jpsView = view as? JPSThumbnailAnnotationView, annotation = view.annotation as? JPSThumbnailAnnotation {
            let feedItem = annotation.curationsFeedItem
            
            if mapView.region.span.latitudeDelta < 2.0 {
                jpsView.didSelectAnnotationViewInMap(mapView)
                let loc = feedItem.coordinates;
                let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: loc.latitude!.doubleValue, longitude: loc.longitude!.doubleValue), MKCoordinateSpanMake(storeZoom, storeZoom))
                mapView.setRegion(region, animated: true)
            }else {
                mapView.deselectAnnotation(annotation, animated: false)
                var itemGroup: [BVCurationsFeedItem]?
                for group in groupedFeedItems {
                    for item in group {
                        if item === feedItem {
                            itemGroup = group
                            break
                        }
                    }
                    if let _ = itemGroup {
                        break
                    }
                }
                
                var minLong = 0.0
                var maxLong = -180.0
                var minLat = 90.0
                var maxLat = 0.0
                
                for item in itemGroup! {
                    if item.coordinates.longitude.doubleValue < minLong {
                        minLong = item.coordinates.longitude.doubleValue
                    }
                    
                    if item.coordinates.longitude.doubleValue > maxLong {
                        maxLong = item.coordinates.longitude.doubleValue
                    }
                    
                    if item.coordinates.latitude.doubleValue < minLat {
                        minLat = item.coordinates.latitude.doubleValue
                    }
                    
                    if item.coordinates.latitude.doubleValue > maxLat {
                        maxLat = item.coordinates.latitude.doubleValue
                    }
                }
                //Getting center
                let avgLat = (minLat + maxLat) / 2.0
                let avgLong = (minLong + maxLong) / 2.0
                //getting viewport + add padding
                var spanLong = abs(maxLong - minLong) + 0.3
                spanLong = spanLong > minGroupZoom ? spanLong : minGroupZoom
                var spanLat = abs(maxLat - minLat) + 0.3
                spanLat = spanLat > minGroupZoom ? spanLat : minGroupZoom

                let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: avgLat, longitude: avgLong), MKCoordinateSpanMake(spanLat, spanLong))
                mapView.setRegion(region, animated: true)
                previousRegion = region
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if let jpsView = view as? JPSThumbnailAnnotationView {
                jpsView.didDeselectAnnotationViewInMap(mapView)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let jpsAnnotation = annotation as? JPSThumbnailAnnotation {
            return jpsAnnotation.annotationViewInMap(mapView)
        }
        return nil
        
    }
    
    @IBAction internal func resetZoomAnimated(sender: UIButton?) {
        resetZoom(true)
    }
    
    private func resetZoom(animated: Bool) {
        
        if previousRegion != nil && mapView.region.span.latitudeDelta < minGroupZoom  {
            mapView.setRegion(previousRegion!, animated: animated)
        }else{
            previousRegion = nil
            let coord = CLLocationCoordinate2D(latitude: 39.50, longitude: -98.35)
            let region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(59.0, 59.0))
            mapView.setRegion(region, animated: animated)
            shouldHideZoomout(true)
        }
    }
    
    private func shouldHideZoomout(shouldHide:Bool) {
        zoomOutBtn.hidden = shouldHide
        btnImage.hidden = shouldHide
    }
}
