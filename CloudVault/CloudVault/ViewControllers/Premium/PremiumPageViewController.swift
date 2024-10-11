//
//  PremiumPageViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/09/2024.
//

//import UIKit
//import Anchorage
//
//class PremiumPageViewController: UIPageViewController {
//    
//    private let pages: [PremiumViewController] = {
//        let page1 = PremiumViewController()
//        page1.pageIndex = 0
//        page1.titleText = "Backup & Restore Data"
//      //  page1.pageIndexImageName = "premiumIndex1Image"
//        page1.separatorColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 0.08029801325)
//        page1.robotImageName = "robotImage1"
//        page1.basicPlanImageName = "basicPlanImage1"
//        page1.advancePlanImageName = "advancePlanImage1"
//        page1.pricingLabelColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 1)
//        
//      
//        
//        let page2 = PremiumViewController()
//        page2.pageIndex = 1
//        page2.titleText = "Everyday Data Strorage"
//       // page2.pageIndexImageName = "premiumIndex2Image"
//        page2.separatorColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 0.1999948262)
//        page2.robotImageName = "robotImage2"
//        page2.basicPlanImageName = "basicPlanImage2"
//        page2.advancePlanImageName = "advancePlanImage2"
//        page2.pricingLabelColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 1)
//       
//      
//        
//        let page3 = PremiumViewController()
//        page3.pageIndex = 2
//        page3.titleText = "End-to-End Encrypted"
//      //  page3.pageIndexImageName = "premiumIndex3Image"
//        page3.separatorColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 0.08029801325)
//        page3.robotImageName = "robotImage3"
//        page3.basicPlanImageName = "basicPlanImage3"
//        page3.advancePlanImageName = "advancePlanImage3"
//        page3.pricingLabelColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 1)
//        
//       
//        
//        return [page1, page2, page3]
//    }()
//    private let pageControl: UIPageControl = {
//        let pc = UIPageControl()
//        pc.translatesAutoresizingMaskIntoConstraints = false
//        pc.currentPage = 0
//        pc.numberOfPages = 3
//        pc.isHidden = true
//        return pc
//    }()
//    private let progressContainerView = UIView()
//        private let firstPageView = UIView()
//        private let secondPageView = UIView()
//        private let thirdPageView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        dataSource = self
//        delegate = self
////        if let firstVC = pages.first {
////            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
////            firstVC.resetAndAnimateRobot()
////        }
//        setupPageControl()
//        setupCustomProgressView()
//        updateProgress(for: 0) // Initialize progress bar
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        if let firstVC = pages.first {
//            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//            firstVC.resetAndAnimateRobot()
//           // prepareForTransition(to: firstVC)
//        }
//    }
//    
//    
//    private func setupPageControl() {
//        view.addSubview(pageControl)
//        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    }
//
//    // Function to set up the custom progress view
//        private func setupCustomProgressView() {
//            progressContainerView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(progressContainerView)
//            
//            progressContainerView.heightAnchor == 10
//            progressContainerView.widthAnchor == 100
//            progressContainerView.centerXAnchor == view.centerXAnchor
//            progressContainerView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 340
//            
//            // Add the three views for each page
//            progressContainerView.addSubview(firstPageView)
//            progressContainerView.addSubview(secondPageView)
//            progressContainerView.addSubview(thirdPageView)
//            
//            // Initial layout setup for page views
//            setupPageViews(widthOfFirst: 46, widthOfSecond: 22, widthOfThird: 22)
//            
//            // Set corner radius and background color
//            firstPageView.layer.cornerRadius = 5
//            firstPageView.backgroundColor = UIColor(named: "appPrimaryTextColor")
//            
//            secondPageView.layer.cornerRadius = 5
//            secondPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
//            
//            thirdPageView.layer.cornerRadius = 5
//            thirdPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
//        }
//
//        // Function to set up page view widths
//        private func setupPageViews(widthOfFirst: CGFloat, widthOfSecond: CGFloat, widthOfThird: CGFloat) {
//            firstPageView.removeConstraints(firstPageView.constraints)  // Remove old constraints before adding new ones
//            secondPageView.removeConstraints(secondPageView.constraints)
//            thirdPageView.removeConstraints(thirdPageView.constraints)
//            
//            // Set new constraints using Anchorage
//            firstPageView.topAnchor == progressContainerView.topAnchor
//            firstPageView.leadingAnchor == progressContainerView.leadingAnchor
//            firstPageView.bottomAnchor == progressContainerView.bottomAnchor
//            firstPageView.widthAnchor == widthOfFirst
//            
//            secondPageView.topAnchor == progressContainerView.topAnchor
//            secondPageView.leadingAnchor == firstPageView.trailingAnchor + 5
//            secondPageView.bottomAnchor == progressContainerView.bottomAnchor
//            secondPageView.widthAnchor == widthOfSecond
//            
//            thirdPageView.topAnchor == progressContainerView.topAnchor
//            thirdPageView.leadingAnchor == secondPageView.trailingAnchor + 5
//            thirdPageView.bottomAnchor == progressContainerView.bottomAnchor
//            thirdPageView.widthAnchor == widthOfThird
//            thirdPageView.trailingAnchor == progressContainerView.trailingAnchor
//        }
//
//        // Function to update the progress view based on the current page index
//        private func updateProgress(for pageIndex: Int) {
//            // Set widths dynamically based on the selected index
//            let firstPageWidth: CGFloat = pageIndex == 0 ? 46 : 22
//            let secondPageWidth: CGFloat = pageIndex == 1 ? 46 : 22
//            let thirdPageWidth: CGFloat = pageIndex == 2 ? 46 : 22
//            
//            // Animate the layout change
//            UIView.animate(withDuration: 1.3) {
//                // Reapply the widths using the setupPageViews function
//                self.setupPageViews(widthOfFirst: firstPageWidth, widthOfSecond: secondPageWidth, widthOfThird: thirdPageWidth)
//                self.view.layoutIfNeeded()  // Ensure the layout is updated within the animation block
//            }
//            
//            // Update the colors to show the active page visually
//            firstPageView.backgroundColor = pageIndex == 0 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//            secondPageView.backgroundColor = pageIndex == 1 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//            thirdPageView.backgroundColor = pageIndex == 2 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//        }
//    
//    // Function to reset the first page to its initial state (no transformations)
//    private func resetPageView(for viewController: PremiumViewController) {
//        viewController.view.transform = CGAffineTransform.identity  // Reset any transformations
//        viewController.view.alpha = 1.0  // Fully visible
//    }
//    
////    func prepareForTransition(to viewController: PremiumViewController, isFirstPage: Bool = false) {
////        // Only apply transformations if it's not the first page
////        if isFirstPage {
////            viewController.view.transform = CGAffineTransform.identity
////            viewController.view.alpha = 1.0
////        } else {
////            // Prepare for the next transition
////            viewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
////            viewController.view.alpha = 0.5
////        }
////    }
//
////    override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
////        super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
////        
////        // If it's the first page, ensure it's properly displayed
//////        if let newVC = viewControllers?.first as? PremiumViewController {
//////            prepareForTransition(to: newVC, isFirstPage: true)
//////        }
////        
////        // If it's the first page, ensure it's properly displayed
////        if let newVC = viewControllers?.first as? PremiumViewController {
////                resetPageView(for: newVC)  // No transformations, fully visible
////            }
////    }
//    
//   
//   
//
//}
//
//extension PremiumPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let currentVC = viewController as? PremiumViewController else { return nil }
//        let currentIndex = currentVC.pageIndex
//        if currentIndex == 0 {
//            return nil
//        }
//        return pages[currentIndex - 1]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let currentVC = viewController as? PremiumViewController else { return nil }
//        let currentIndex = currentVC.pageIndex
//        if currentIndex >= pages.count - 1 {
//            return nil
//        }
//        return pages[currentIndex + 1]
//    }
//    
//    
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed, let currentVC = viewControllers?.first as? PremiumViewController else {
//            return
//        }
//        
//        // Apply transformation to the current view controller's content
//        UIView.animate(withDuration: 1.3) {
//            // Example transformation: scaling in the current view
//            currentVC.view.transform = CGAffineTransform.identity
//            
//            // Set the progress bar state for the current page
//            self.updateProgress(for: currentVC.pageIndex)
//        }
//        
//        // Ensure the current view is fully visible and reset any transformations
//            UIView.animate(withDuration: 1.3) {
//                currentVC.view.transform = CGAffineTransform.identity
//                currentVC.view.alpha = 1.0
//            }
//            
//            // Reset the previous view controller's transformation if needed
//            if let previousVC = previousViewControllers.first as? PremiumViewController {
//                UIView.animate(withDuration: 1.3) {
//                    previousVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                    previousVC.view.alpha = 0.5
//                }
//            }
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        if let nextVC = pendingViewControllers.first as? PremiumViewController {
//            // Apply the transformation to the next controller as the user swipes
//            nextVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            nextVC.view.alpha = 0.5 // Optional: lower the alpha for a transition effect
//        }
//    }
//    
//    
//    
//}




import UIKit
import Anchorage

//class PremiumPageViewController: UIPageViewController {
//
//    private let pages: [PremiumViewController] = {
//        let page1 = PremiumViewController()
//        page1.pageIndex = 0
//        page1.titleText = "Backup & Restore Data"
//        page1.separatorColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 0.08029801325)
//        page1.robotImageName = "robotImage1"
//        page1.basicPlanImageName = "basicPlanImage1"
//        page1.advancePlanImageName = "advancePlanImage1"
//        page1.pricingLabelColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 1)
//        
//        let page2 = PremiumViewController()
//        page2.pageIndex = 1
//        page2.titleText = "Everyday Data Storage"
//        page2.separatorColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 0.1999948262)
//        page2.robotImageName = "robotImage2"
//        page2.basicPlanImageName = "basicPlanImage2"
//        page2.advancePlanImageName = "advancePlanImage2"
//        page2.pricingLabelColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 1)
//
//        let page3 = PremiumViewController()
//        page3.pageIndex = 2
//        page3.titleText = "End-to-End Encrypted"
//        page3.separatorColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 0.08029801325)
//        page3.robotImageName = "robotImage3"
//        page3.basicPlanImageName = "basicPlanImage3"
//        page3.advancePlanImageName = "advancePlanImage3"
//        page3.pricingLabelColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 1)
//
//        return [page1, page2, page3]
//    }()
//
//    private let pageControl: UIPageControl = {
//        let pc = UIPageControl()
//        pc.translatesAutoresizingMaskIntoConstraints = false
//        pc.currentPage = 0
//        pc.numberOfPages = 3
//        pc.isHidden = true
//        return pc
//    }()
//    
//    private let progressContainerView = UIView()
//    private let firstPageView = UIView()
//    private let secondPageView = UIView()
//    private let thirdPageView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        dataSource = self
//        delegate = self
//        setupPageControl()
//        setupCustomProgressView()
//        updateProgress(for: 0)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let firstVC = pages.first {
//           // setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
//            firstVC.resetAndAnimateRobot()
//        }
//    }
//    
//    private func setupPageControl() {
//        view.addSubview(pageControl)
//        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    }
//
//    private func setupCustomProgressView() {
//        progressContainerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(progressContainerView)
//        
//        progressContainerView.heightAnchor == 10
//        progressContainerView.widthAnchor == 100
//        progressContainerView.centerXAnchor == view.centerXAnchor
//        progressContainerView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 340
//        
//        progressContainerView.addSubview(firstPageView)
//        progressContainerView.addSubview(secondPageView)
//        progressContainerView.addSubview(thirdPageView)
//        
//        setupPageViews(widthOfFirst: 46, widthOfSecond: 22, widthOfThird: 22)
//        
//        firstPageView.layer.cornerRadius = 5
//        firstPageView.backgroundColor = UIColor(named: "appPrimaryTextColor")
//        secondPageView.layer.cornerRadius = 5
//        secondPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
//        thirdPageView.layer.cornerRadius = 5
//        thirdPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
//    }
//
//    private func setupPageViews(widthOfFirst: CGFloat, widthOfSecond: CGFloat, widthOfThird: CGFloat) {
//        firstPageView.removeConstraints(firstPageView.constraints)
//        secondPageView.removeConstraints(secondPageView.constraints)
//        thirdPageView.removeConstraints(thirdPageView.constraints)
//        
//        firstPageView.topAnchor == progressContainerView.topAnchor
//        firstPageView.leadingAnchor == progressContainerView.leadingAnchor
//        firstPageView.bottomAnchor == progressContainerView.bottomAnchor
//        firstPageView.widthAnchor == widthOfFirst
//        
//        secondPageView.topAnchor == progressContainerView.topAnchor
//        secondPageView.leadingAnchor == firstPageView.trailingAnchor + 5
//        secondPageView.bottomAnchor == progressContainerView.bottomAnchor
//        secondPageView.widthAnchor == widthOfSecond
//        
//        thirdPageView.topAnchor == progressContainerView.topAnchor
//        thirdPageView.leadingAnchor == secondPageView.trailingAnchor + 5
//        thirdPageView.bottomAnchor == progressContainerView.bottomAnchor
//        thirdPageView.widthAnchor == widthOfThird
//        thirdPageView.trailingAnchor == progressContainerView.trailingAnchor
//    }
//
//    private func updateProgress(for pageIndex: Int) {
//        let firstPageWidth: CGFloat = pageIndex == 0 ? 46 : 22
//        let secondPageWidth: CGFloat = pageIndex == 1 ? 46 : 22
//        let thirdPageWidth: CGFloat = pageIndex == 2 ? 46 : 22
//        
//        UIView.animate(withDuration: 1.3) {
//            self.setupPageViews(widthOfFirst: firstPageWidth, widthOfSecond: secondPageWidth, widthOfThird: thirdPageWidth)
//            self.view.layoutIfNeeded()
//        }
//        
//        firstPageView.backgroundColor = pageIndex == 0 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//        secondPageView.backgroundColor = pageIndex == 1 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//        thirdPageView.backgroundColor = pageIndex == 2 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
//    }
//}
//
//extension PremiumPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = pages.firstIndex(of: viewController as! PremiumViewController), viewControllerIndex > 0 else {
//            return nil
//        }
//        return pages[viewControllerIndex - 1]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = pages.firstIndex(of: viewController as! PremiumViewController), viewControllerIndex < (pages.count - 1) else {
//            return nil
//        }
//        return pages[viewControllerIndex + 1]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        guard completed, let currentVC = viewControllers?.first as? PremiumViewController else { return }
//        pageControl.currentPage = currentVC.pageIndex
//        updateProgress(for: currentVC.pageIndex)
//        currentVC.resetAndAnimateRobot()
//    }
//}

import UIKit
import Anchorage
class PremiumPageViewController: UIViewController {
    
    private var currentPage = 0
    private let pages: [PremiumViewController] = {
        let page1 = PremiumViewController()
        page1.titleText = "Backup & Restore Data"
        page1.robotImageName = "robotImage1"
        page1.pageIndex = 0
      
        page1.separatorColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 0.08029801325)
        page1.basicPlanImageName = "basicPlanImage1"
        page1.advancePlanImageName = "advancePlanImage1"
        page1.pricingLabelColor = #colorLiteral(red: 0.1098039216, green: 0.6941176471, blue: 0.9333333333, alpha: 1)
        
        
        let page2 = PremiumViewController()
        page2.titleText = "Everyday Data Storage"
        page2.robotImageName = "robotImage2"
        page2.separatorColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 0.1999948262)
        page2.basicPlanImageName = "basicPlanImage2"
        page2.advancePlanImageName = "advancePlanImage2"
        page2.pricingLabelColor = #colorLiteral(red: 0.9333333333, green: 0.3058823529, blue: 0.1098039216, alpha: 1)
        page2.pageIndex = 1
        
        let page3 = PremiumViewController()
        page3.titleText = "End-to-End Encrypted"
        page3.robotImageName = "robotImage3"
        page3.separatorColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 0.08029801325)
        page3.basicPlanImageName = "basicPlanImage3"
        page3.advancePlanImageName = "advancePlanImage3"
        page3.pricingLabelColor = #colorLiteral(red: 0.07843137255, green: 0.8431372549, blue: 0.4705882353, alpha: 1)
        page3.pageIndex = 2

        return [page1, page2, page3]
    }()
    
    // Custom progress view elements
        private let progressContainerView = UIView()
        private let firstPageView = UIView()
        private let secondPageView = UIView()
        private let thirdPageView = UIView()
        
        private let pageIndicator: UIPageControl = {
            let pc = UIPageControl()
            pc.translatesAutoresizingMaskIntoConstraints = false
            pc.numberOfPages = 3
            pc.currentPage = 0
            return pc
        }()

        private let contentView = UIView()

        override func viewDidLoad() {
            super.viewDidLoad()

            setupUI()
            setupCustomProgressView()
            setupGestureRecognizers()
            updateContent()
        }
        
        private func setupUI() {
            view.backgroundColor = .white
            view.addSubview(contentView)
            view.addSubview(pageIndicator)

            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])

            pageIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }

        private func setupCustomProgressView() {
            progressContainerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(progressContainerView)
            
            // Progress container constraints
            progressContainerView.heightAnchor == 10
            progressContainerView.widthAnchor == 100
            progressContainerView.centerXAnchor == view.centerXAnchor
            progressContainerView.topAnchor == view.safeAreaLayoutGuide.topAnchor + 340

            // Add page views to the container
            progressContainerView.addSubview(firstPageView)
            progressContainerView.addSubview(secondPageView)
            progressContainerView.addSubview(thirdPageView)

            setupPageViews(widthOfFirst: 46, widthOfSecond: 22, widthOfThird: 22)

            // Initial colors
            firstPageView.layer.cornerRadius = 5
            firstPageView.backgroundColor = UIColor(named: "appPrimaryTextColor")
            secondPageView.layer.cornerRadius = 5
            secondPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
            thirdPageView.layer.cornerRadius = 5
            thirdPageView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
        }

        private func setupPageViews(widthOfFirst: CGFloat, widthOfSecond: CGFloat, widthOfThird: CGFloat) {
            firstPageView.removeConstraints(firstPageView.constraints)
            secondPageView.removeConstraints(secondPageView.constraints)
            thirdPageView.removeConstraints(thirdPageView.constraints)
            
            // Set up page views constraints
            firstPageView.topAnchor == progressContainerView.topAnchor
            firstPageView.leadingAnchor == progressContainerView.leadingAnchor
            firstPageView.bottomAnchor == progressContainerView.bottomAnchor
            firstPageView.widthAnchor == widthOfFirst
            
            secondPageView.topAnchor == progressContainerView.topAnchor
            secondPageView.leadingAnchor == firstPageView.trailingAnchor + 5
            secondPageView.bottomAnchor == progressContainerView.bottomAnchor
            secondPageView.widthAnchor == widthOfSecond
            
            thirdPageView.topAnchor == progressContainerView.topAnchor
            thirdPageView.leadingAnchor == secondPageView.trailingAnchor + 5
            thirdPageView.bottomAnchor == progressContainerView.bottomAnchor
            thirdPageView.widthAnchor == widthOfThird
            thirdPageView.trailingAnchor == progressContainerView.trailingAnchor
        }

        private func setupGestureRecognizers() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            contentView.addGestureRecognizer(panGesture)
        }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)

        if gesture.state == .ended {
            if translation.x < -50 { // Swipe left
                if currentPage < pages.count - 1 {
                    currentPage += 1
                }
            } else if translation.x > 50 { // Swipe right
                if currentPage > 0 {
                    currentPage -= 1
                }
            }

            // Call updateContent only after setting currentPage
            updateContent()
        }
    }

    private func updateContent() {
        // Remove current content
        contentView.subviews.forEach { $0.removeFromSuperview() }

        // Add the new content
        let currentVC = pages[currentPage]
        addChild(currentVC)

        // First add the new view to the hierarchy
        contentView.addSubview(currentVC.view)

        // Set the frame after adding the view
        currentVC.view.frame = contentView.bounds
        currentVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Ensure layout updates immediately
        contentView.layoutIfNeeded()

        currentVC.didMove(toParent: self)

        // Update page indicator
        pageIndicator.currentPage = currentPage

        // Update the progress view
        updateProgress(for: currentPage)
    }

        private func updateProgress(for pageIndex: Int) {
            let firstPageWidth: CGFloat = pageIndex == 0 ? 46 : 22
            let secondPageWidth: CGFloat = pageIndex == 1 ? 46 : 22
            let thirdPageWidth: CGFloat = pageIndex == 2 ? 46 : 22
            
            UIView.animate(withDuration: 1.3) {
                self.setupPageViews(widthOfFirst: firstPageWidth, widthOfSecond: secondPageWidth, widthOfThird: thirdPageWidth)
                self.view.layoutIfNeeded()
            }
            
            firstPageView.backgroundColor = pageIndex == 0 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
            secondPageView.backgroundColor = pageIndex == 1 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
            thirdPageView.backgroundColor = pageIndex == 2 ? UIColor(named: "appPrimaryTextColor") : UIColor(named: "appDeselectedTabbarColor")
        }
    }
