//
//  HomeHeaderCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import Foundation

class HomeHeaderCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPageIndex : Int = 0 {
        didSet {
            pageControl.currentPage = currentPageIndex
        }
    }
    
    var timer : NSTimer?
    
    let images : [UIImageView] = [
        UIImageView(image: UIImage(named: "slide_1.jpg")),
        UIImageView(image: UIImage(named: "slide_2.jpg")),
        UIImageView(image: UIImage(named: "slide_3.jpg"))
    ]
    
    static let heightCalculator = UIImage(named: "slide_1.jpg")!
    class func preferredHeightForWidth (preferredWidth: CGFloat) -> CGFloat {
        
        return (preferredWidth / heightCalculator.size.width) * heightCalculator.size.height
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAutoScrollTimer(2.0)
        
        configureImages()
        configureScrollView()
        
    }
    
    
    func configureImages() {
        
        for image in images {
            image.contentMode = .ScaleAspectFit
        }
        
    }
    
    func configureScrollView() {
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        scrollView.delegate = self
        
        for image in images {
            scrollView.addSubview(image)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.width,
            height: self.bounds.height
        )
        
        for i in 0 ..< images.count {
            
            images[i].frame = CGRectMake(
                CGFloat(i) * self.bounds.width,
                scrollView.frame.origin.y,
                self.bounds.width,
                self.bounds.height
            )
            
        }
        
        self.scrollView.contentSize = CGSize(
            width: scrollView.frame.size.width * 3,
            height: self.frame.size.height
        )
        
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        currentPageIndex = Int(floor(scrollView.contentOffset.x / self.bounds.width))
        setAutoScrollTimer(4.0)
        
    }
    
    func setAutoScrollTimer(time:Double) {
        timer?.invalidate()
        timer = nil
        timer = NSTimer.scheduledTimerWithTimeInterval(
            time,
            target: self,
            selector: "autoScroll",
            userInfo: nil,
            repeats: false
        )
    }
    
    func autoScroll() {
        
        currentPageIndex += 1
        if currentPageIndex >= images.count {
            currentPageIndex = 0
        }
        
        var newFrame = scrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(currentPageIndex)
        UIView.animateWithDuration(0.6) {
            self.scrollView.scrollRectToVisible(newFrame, animated: false)
        }
        
    }

}
