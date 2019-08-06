// From Gist: https://gist.github.com/freedom27/c709923b163e26405f62b799437243f4
import UIKit

extension CAShapeLayer {
  func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
    fillColor = filled ? color.cgColor : UIColor.white.cgColor
    strokeColor = color.cgColor
    let origin = CGPoint(x: location.x - radius, y: location.y - radius)
    path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
  }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
  private var badgeLayer: CAShapeLayer? {
    if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
      return b as? CAShapeLayer
    } else {
      return nil
    }
  }
  
  func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
    guard let view = self.value(forKey: "view") as? UIView else { return }
    
    badgeLayer?.removeFromSuperlayer()
    
    var badgeWidth = 8
    var numberOffset = 4
    
    if number > 9 {
      badgeWidth = 12
      numberOffset = 6
    }
    
    // Initialize Badge
    let badge = CAShapeLayer()
    let radius = CGFloat(7)
    let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
    badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
    view.layer.addSublayer(badge)
    
    // Initialiaze Badge's label
    let label = CATextLayer()
    label.string = "\(number)"
    label.alignmentMode = CATextLayerAlignmentMode.center
    label.fontSize = 11
    label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
    label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
    label.backgroundColor = UIColor.clear.cgColor
    label.contentsScale = UIScreen.main.scale
    badge.addSublayer(label)
    
    // Save Badge as UIBarButtonItem property
    objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
  
  func updateBadge(number: Int) {
    if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
      text.string = "\(number)"
    }
  }
  
  func removeBadge() {
    badgeLayer?.removeFromSuperlayer()
  }
}
