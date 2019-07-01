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
    btnImage.image = btnImage.image?.withRenderingMode(.alwaysTemplate)
    btnImage.tintColor = UIColor.red
    btnImage.backgroundColor = UIColor.white
    btnImage.layer.cornerRadius = btnImage.frame.width / 2
    mapView.addAnnotations(self.annotations)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if !hasShownDefault {
      hasShownDefault = true
      /*
       
       guard let storeId = LocationPreferenceUtils.getDefaultStoreId() else {
       return
       }
       
       // TODO: This should be fetching a store with lat/long from the default store selected.
       for ann in annotations {
       if ann.coordinate.latitude == Double(store.latitude) {
       mapView.selectAnnotation(ann, animated: true)
       break
       }
       }
       */
    }
  }
  
  lazy var annotations: [JPSThumbnailAnnotation] = {
    [unowned self] in
    
    var annotationThumbs : [JPSThumbnailAnnotation] = []
    
    var idx : Int = 0
    for feedItem in self.curationsFeed {
      let location = feedItem.coordinates
      
      if let _ = location?.longitude, let _ = location?.latitude, let _ = feedItem.photos{
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
  
  private func groupFeedItem(_ feedItem: BVCurationsFeedItem){
    var itemGroup : [BVCurationsFeedItem]?
    for group in groupedFeedItems {
      for item in group {
        if getDistanceBetween(feedItem, feedItem2: item) < distanceThreshold {
          itemGroup = group
          let idx = groupedFeedItems.index(where: {$0 == itemGroup!})
          groupedFeedItems.remove(at: idx!)
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
  
  private func getDistanceBetween(_ feedItem1: BVCurationsFeedItem, feedItem2: BVCurationsFeedItem) -> Double {
    let loc1 = CLLocation(latitude: feedItem1.coordinates.latitude.doubleValue, longitude: feedItem1.coordinates.longitude.doubleValue)
    let loc2 = CLLocation(latitude: feedItem2.coordinates.latitude.doubleValue, longitude: feedItem2.coordinates.longitude.doubleValue)
    
    return loc1.distance(from: loc2)
  }
  
  // MARK: MKMapViewDelegate
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    if !animated {
      shouldHideZoomout(false)
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    shouldHideZoomout(false)
    if let jpsView = view as? JPSThumbnailAnnotationView, let annotation = view.annotation as? JPSThumbnailAnnotation {
      let feedItem = annotation.curationsFeedItem
      
      if mapView.region.span.latitudeDelta < 2.0 {
        jpsView.didSelectAnnotationView(inMap: mapView)
        let loc = feedItem?.coordinates;
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (loc?.latitude!.doubleValue)!, longitude: (loc?.longitude!.doubleValue)!), span: MKCoordinateSpan(latitudeDelta: storeZoom, longitudeDelta: storeZoom))
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
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLong), span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLong))
        mapView.setRegion(region, animated: true)
        previousRegion = region
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    if let jpsView = view as? JPSThumbnailAnnotationView {
      jpsView.didDeselectAnnotationView(inMap: mapView)
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    if let jpsAnnotation = annotation as? JPSThumbnailAnnotation {
      return jpsAnnotation.annotationView(inMap: mapView)
    }
    return nil
    
  }
  
  @IBAction internal func resetZoomAnimated(_ sender: UIButton?) {
    resetZoom(true)
  }
  
  private func resetZoom(_ animated: Bool) {
    
    if previousRegion != nil && mapView.region.span.latitudeDelta < minGroupZoom  {
      mapView.setRegion(previousRegion!, animated: animated)
    }else{
      previousRegion = nil
      let coord = CLLocationCoordinate2D(latitude: 39.50, longitude: -98.35)
        let region = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 59.0, longitudeDelta: 59.0))
      mapView.setRegion(region, animated: animated)
      shouldHideZoomout(true)
    }
  }
  
  private func shouldHideZoomout(_ shouldHide:Bool) {
    zoomOutBtn.isHidden = shouldHide
    btnImage.isHidden = shouldHide
  }
}
