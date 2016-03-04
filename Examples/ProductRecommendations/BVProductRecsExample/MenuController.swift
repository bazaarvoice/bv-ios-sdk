//
//  MenuController
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//  Adapted from Jose Zamudio's SwiftAppMenuController.
//

import Foundation
import UIKit
let kHeaderHeight : CGFloat = 200

var newDelegate = AppDelegate()
var window = UIWindow()
var panGesture = UIPanGestureRecognizer()

class MenuController: UINavigationController {
    
    var firstX = Float()
    var firstY = Float()
    var _origin = CGPoint()
    var _final = CGPoint()
    var duration = CGFloat()
    
    override func viewDidLoad() {
        newDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        window = newDelegate.window!
        window.layer.shadowRadius = 15
        window.layer.shadowOffset = CGSizeMake(0, 0)
        window.layer.shadowColor = UIColor.blackColor().CGColor
        window.layer.shadowOpacity = 0.8
        
        duration = 0.3
    }
    
    func activateSwipeToOpenMenu(onlyNavigation: Bool) -> Void {
        panGesture = UIPanGestureRecognizer(target: self, action: "onPan")
        
        if (onlyNavigation == true) {
            self.navigationBar.addGestureRecognizer(panGesture)
        } else {
            window.addGestureRecognizer(panGesture)
        }
    }
    
    // fore the menu to close
    func closeMenu() -> Void {
        
        var f = window.frame
        f.origin = CGPointZero
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            window.transform = CGAffineTransformIdentity
            window.frame = f
            },
            completion: nil)
    }
    
    // force the menu to open
    func openMenu() -> Void {
        
        var f = window.frame
        
        if (f.origin.y == CGPointZero.y) {
            if (UIScreen.mainScreen().bounds.height <= 480){
                f.origin.y = CGRectGetHeight(UIScreen.mainScreen().bounds) - kHeaderHeight + 100
            } else {
                f.origin.y = CGRectGetHeight(UIScreen.mainScreen().bounds) - kHeaderHeight
            }
            
        }
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            window.transform = CGAffineTransformIdentity
            window.frame = f
            },
            completion: nil)
    }
    
    // Toggle open/close state of menu
    func openAndCloseMenu() -> Void {
        let f = window.frame
        
        if (f.origin.y == CGPointZero.y) {
            self.openMenu()
        } else {
            self.closeMenu();
        }
    
    }
    
    func setAnimationDuration(d:CGFloat) -> Void {
        duration = d
    }
    
    func onPan(pan:UIPanGestureRecognizer) -> Void {
        let translation:CGPoint = pan.translationInView(window)
        let velocity:CGPoint = pan.velocityInView(window)
        
        switch (pan.state) {
        case .Began:
            _origin = window.frame.origin
            break
            
        case .Changed:
            if (_origin.y + translation.y >= 0) {
                if (window.frame.origin.y != CGPointZero.y) {
                    window.transform = CGAffineTransformMakeTranslation(0, translation.y)
                } else {
                    window.transform = CGAffineTransformMakeTranslation(0, translation.y)
                }
            }
            break
            
        case .Ended:
            break
            
        case .Cancelled:
            var finalOrigin = CGPointZero
            if (velocity.y >= 0) {
                finalOrigin.y = CGRectGetHeight(UIScreen.mainScreen().bounds) - kHeaderHeight
            }
            
            var f = window.frame
            f.origin = finalOrigin
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                window.transform = CGAffineTransformIdentity
                window.frame = f
                }, completion: nil)
            break
            
        default:
            break
        }
    }
    
}