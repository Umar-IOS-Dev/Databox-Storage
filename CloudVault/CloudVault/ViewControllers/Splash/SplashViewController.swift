//
//  SplashViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 08/07/2024.
//

import UIKit
import SwiftyGif
import Anchorage
import FirebaseAuth

class SplashViewController: BaseViewController {
    
    let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        // Set up the gifImageView
        if let gif = try? UIImage(gifName: "OnBoarding1") {
            imageView.setGifImage(gif)
        }
        
        return imageView
    }()
    let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DesignMetrics.Padding.size8
        return stack
    }()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    deinit {
        print("SplashViewController is being deallocated")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                for family in UIFont.familyNames {
                    print("Family: \(family)")
                    for name in UIFont.fontNames(forFamilyName: family) {
                        print("Font: \(name) \n")
                    }
                }
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureAppIcon()
        configureFooterView()
        showProgress()
       // setupActivityIndicator()
       // activityIndicator.startAnimating()
       // self.view.bringSubviewToFront(activityIndicator)
    }
    
//    func setupActivityIndicator() {
//            activityIndicator.center = view.center
//            activityIndicator.hidesWhenStopped = true
//        activityIndicator.color = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
//            view.addSubview(activityIndicator)
//        }
    
    private func configureAppIcon() {
        view.addSubview(gifImageView)
        gifImageView.centerXAnchor == view.centerXAnchor
        gifImageView.centerYAnchor == view.centerYAnchor - DesignMetrics.Padding.size28
        gifImageView.widthAnchor == view.widthAnchor * 0.90
        gifImageView.heightAnchor == view.heightAnchor * 0.30
    }
    
    private func configureFooterView() {
        view.addSubview(footerStack)
        footerStack.heightAnchor == DesignMetrics.Dimensions.height48
        footerStack.horizontalAnchors == view.horizontalAnchors + DesignMetrics.Padding.size16
        footerStack.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor - DesignMetrics.Padding.size16
        
        let slogenLabel = UILabel()
        slogenLabel.text = "Secure Your Memories, Anytime, Anywhere"
        slogenLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        slogenLabel.textAlignment = .center
        
        let privacyPolicyLabel = UILabel()
        privacyPolicyLabel.textAlignment = .center
        privacyPolicyLabel.textColor = UIColor.link
        privacyPolicyLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        privacyPolicyLabel.attributedText = "Privacy Policy".underlined()
        
        privacyPolicyLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        privacyPolicyLabel.addGestureRecognizer(tapGesture)
        
        footerStack.addArrangedSubview(slogenLabel)
        footerStack.addArrangedSubview(privacyPolicyLabel)
        // Transition to the onboarding screens after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.transitionToOnboarding()
        }
    }
    
    @objc private func privacyPolicyTapped() {
        // Handle the tap on the privacy policy label
        if let url = URL(string: "https://your-privacy-policy-url.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func transitionToOnboarding() {
        if let user = Auth.auth().currentUser {
                // User is signed in.
                print("User is signed in with uid: \(user.uid)")
                // Navigate to the main app screen or perform any other actions needed.
           // activityIndicator.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                hideProgress()
                self.transitionToMainApp()
            }
          //  self.showHomeViewController()
//            let onboardingPageVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//            onboardingPageVC.modalTransitionStyle = .crossDissolve
//            onboardingPageVC.modalPresentationStyle = .fullScreen
//            present(onboardingPageVC, animated: true, completion: nil)
            } else {
                // No user is signed in.
                print("No user is signed in.")
                hideProgress()
              //  activityIndicator.stopAnimating()
                // Show the login screen or perform any other actions needed.
                let onboardingPageVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                onboardingPageVC.modalTransitionStyle = .crossDissolve
                onboardingPageVC.modalPresentationStyle = .fullScreen
                present(onboardingPageVC, animated: true, completion: nil)
            }
    }
    
    private func showHomeViewController() {
        let homeVC = CustomTabBarController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        // Set HomeViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func transitionToMainApp() {
            let tabBarController = CustomTabBarController()
            let navigationController = UINavigationController(rootViewController: tabBarController)
            
            // Set this navigation controller as the root view controller
            if let window = UIApplication.shared.windows.first {
                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                      window.rootViewController = navigationController
                                  },
                                  completion: nil)
            }
        }
    
//    private func showHomeViewController() {
//        let customTabBarController = CustomTabBarController()
//        let navigationController = UINavigationController(rootViewController: customTabBarController)
//        navigationController.modalPresentationStyle = .fullScreen // if needed
//        if let window = UIApplication.shared.windows.first {
//            window.rootViewController = navigationController
//            UIView.transition(with: window,
//                              duration: 0.5,
//                              options: .transitionCrossDissolve,
//                              animations: nil,
//                              completion: nil)
//        }
//    }
    
   
}
