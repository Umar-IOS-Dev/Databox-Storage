//
//  ImagePreviewAnimator.swift
//  CloudVault
//
//  Created by Appinators Technology on 26/08/2024.
//

import Foundation
import UIKit

class ImagePreviewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7 // Duration of the animation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let imageView = isPresenting ? toVC.view! : fromVC.view!
        
        if isPresenting {
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toVC.view.alpha = 1
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.alpha = 0
            }) { _ in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}




class ImagePreviewTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    // Implement methods to provide custom animation controller
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImagePreviewAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImagePreviewAnimator(isPresenting: false)
    }
}
