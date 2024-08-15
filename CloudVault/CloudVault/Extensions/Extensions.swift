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

// Conform to UINavigationControllerDelegate
//extension UIViewController: UINavigationControllerDelegate {
//    public func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return (operation == .push) ? CustomPushAnimator(duration: 0.5) : nil
//    }
//}
