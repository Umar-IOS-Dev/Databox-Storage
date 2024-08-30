//
//  Extensions.swift
//  CloudVault
//
//  Created by Appinators Technology on 05/08/2024.
//

import Foundation
import ObjectiveC
import UIKit

private var buttonParamsKey: UInt8 = 0

extension UIButton {
    var params: (section: Int, item: Int)? {
        get {
            return objc_getAssociatedObject(self, &buttonParamsKey) as? (section: Int, item: Int)
        }
        set {
            objc_setAssociatedObject(self, &buttonParamsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func setDottedBorder(color: UIColor, lineWidth: CGFloat) {
            // Remove any existing shape layers to avoid multiple layers being added
            self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
            
            // Create the dotted border layer
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineDashPattern = [4, 2]
            shapeLayer.frame = self.bounds
            shapeLayer.fillColor = nil
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            shapeLayer.lineWidth = lineWidth
            
            // Add the shape layer to the view's layer
            self.layer.addSublayer(shapeLayer)
        }
    
        
    
}

// Conform to UINavigationControllerDelegate
//extension UIViewController: UINavigationControllerDelegate {
//    public func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return (operation == .push) ? CustomPushAnimator(duration: 0.5) : nil
//    }
//}
