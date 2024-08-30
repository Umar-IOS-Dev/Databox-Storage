//
//  FeedbackViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit
import Anchorage

class FeedbackViewController: BaseViewController {

    var pageViewController: UIPageViewController!
        let viewControllers: [UIViewController] = [
            SubmitFeedbackViewController(),
            YourFeedbackViewController(),
            ReplyFeedbackViewController()
        ]
        let segmentedView = FeedbackSegmentedView()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor(named: "appBackgroundColor")
            configureUI(title: "Feedback", showBackButton: true, hideBackground: true, showMainNavigation: false)
            hideFocusbandOptionFromNavBar()
        }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        setupSegmentedView()
        setupPageViewController()
    }
        
        private func setupSegmentedView() {
            let segmentContainerView = UIView()
            segmentContainerView.backgroundColor = .white
            segmentContainerView.layer.cornerRadius = 8
            segmentContainerView.heightAnchor == 60
            
            segmentContainerView.addSubview(segmentedView)
            segmentedView.edgeAnchors == segmentContainerView.edgeAnchors
            
            appendViewToMainVStack(view: segmentContainerView, topPadding: 24)
            
            segmentedView.didSelectSegment = { [weak self] index in
                guard let self = self else { return }
                self.setViewController(index: index)
            }
        }
        
        private func setupPageViewController() {
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageViewController.dataSource = self
            pageViewController.delegate = self
            addChild(pageViewController)
            view.addSubview(pageViewController.view)
            
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
               // pageViewController.view.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
                pageViewController.view.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
                pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
        
        private func setViewController(index: Int) {
            let direction: UIPageViewController.NavigationDirection = index > (viewControllers.firstIndex(of: pageViewController.viewControllers!.first!) ?? 0) ? .forward : .reverse
            pageViewController.setViewControllers([viewControllers[index]], direction: direction, animated: true, completion: nil)
            segmentedView.selectSegment(index: index)
        }

}

extension FeedbackViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
            return viewControllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
            return viewControllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed {
                if let currentViewController = pageViewController.viewControllers?.first,
                   let index = viewControllers.firstIndex(of: currentViewController) {
                    segmentedView.selectSegment(index: index)
                }
            }
        }
}
