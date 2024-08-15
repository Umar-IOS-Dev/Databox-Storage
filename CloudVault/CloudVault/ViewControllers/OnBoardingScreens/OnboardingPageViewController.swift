//
//  OnboardingPageViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 08/07/2024.
//

import UIKit
import Anchorage



class OnboardingPageViewController: UIPageViewController {
    
    private let onBoardingController = OnboardingViewController()
    private let descriptionForCardView = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular"
    private let pages: [OnboardingViewController] = {
        let page1 = OnboardingViewController()
        page1.pageIndex = 0
        page1.titleText = "Backup & Restore Data"
        page1.pageIndexImageName = "OnBoardings/onBoardingPageControlImage1"
        page1.progressButtonImageName = "OnBoardings/onBoardingProgress1"
        page1.gifImageName = "OnBoarding3"
        
        let page2 = OnboardingViewController()
        page2.pageIndex = 1
        page2.titleText = "Everyday Data Strorage"
        page2.pageIndexImageName = "OnBoardings/onBoardingPageControlImage2"
        page2.progressButtonImageName = "OnBoardings/onBoardingProgress2"
        page2.gifImageName = "OnBoarding2"
        
        let page3 = OnboardingViewController()
        page3.pageIndex = 2
        page3.titleText = "End-to-End Encrypted"
        page3.pageIndexImageName = "OnBoardings/onBoardingPageControlImage3"
        page3.progressButtonImageName = "OnBoardings/onBoardingProgress3"
        page3.gifImageName = "OnBoarding1"
        
        return [page1, page2, page3]
    }()
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.isHidden = true
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        setupPageControl()
        setupDelegateForPages()
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupDelegateForPages() {
        for page in pages {
            page.delegate = self
        }
    }
    
    private func showViews() {
        guard  let currentVC = viewControllers?.first as? OnboardingViewController else { return }
        currentVC.gifView.isHidden = false
        currentVC.titleLabel.isHidden = false
        currentVC.subHeadingLabel.isHidden = false
        currentVC.skipButton.isHidden = false
        currentVC.pageControlImageView.isHidden = false
        currentVC.progressButton.isHidden = false
        self.view.alpha = 1.0
    }
    
    private func hideViews() {
        guard  let currentVC = viewControllers?.first as? OnboardingViewController else { return }
        self.view.alpha = 0.7
        currentVC.gifView.isHidden = true
        currentVC.titleLabel.isHidden = true
        currentVC.subHeadingLabel.isHidden = true
        currentVC.skipButton.isHidden = true
        currentVC.pageControlImageView.isHidden = true
        currentVC.progressButton.isHidden = true
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        let currentIndex = currentVC.pageIndex
        if currentIndex == 0 {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController else { return nil }
        let currentIndex = currentVC.pageIndex
        if currentIndex >= pages.count - 1 {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = viewControllers?.first as? OnboardingViewController else { return }
        pageControl.currentPage = currentVC.pageIndex
    }
}

extension OnboardingPageViewController: OnboardingViewControllerDelegate {
    func didTapNextButton(on viewController: OnboardingViewController) {
        let nextIndex = viewController.pageIndex + 1
        if nextIndex < pages.count {
            let nextVC = pages[nextIndex]
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = nextIndex
        } else {
            navigateOutOfOnboarding()
        }
    }
}

extension OnboardingPageViewController {
    func navigateOutOfOnboarding() {
        hideViews()
        let cardVC = CardViewController(title: "Terms & Conditions", description: descriptionForCardView)
        
        let transitionDelegate = CardTransitioningDelegate()
        cardVC.transitioningDelegate = transitionDelegate
        cardVC.modalPresentationStyle = .custom
        cardVC.delegate = self
        present(cardVC, animated: true, completion: nil)
        print("goto Main ViewController")
    }
}

extension OnboardingPageViewController: CardViewControllerDelegate {
    func showContent() {
        showViews()
    }
}
