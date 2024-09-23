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
import AuthenticationServices

class SplashViewController: BaseViewController {
    
    let gifImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
    
    let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DesignMetrics.Padding.size8
        return stack
    }()
   
    
    deinit {
        print("SplashViewController is being deallocated")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
           super.traitCollectionDidChange(previousTraitCollection)
           
           if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
               // Update the GIF when the theme changes
               updateGifImage()
           }
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
//        showProgress()
        updateGifImage()
    }
    // Method to update the GIF image based on the current interface style (light/dark mode)
       private func updateGifImage() {
           let gifName: String
           if traitCollection.userInterfaceStyle == .dark {
               gifName = "OnBoarding1Dark"  // Use the dark mode GIF
           } else {
               gifName = "splashLight"  // Use the light mode GIF
           }
           
           if let gif = try? UIImage(gifName: gifName) {
               gifImageView.setGifImage(gif)
           }
       }
    
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
            // User is signed in with Firebase.
            print("User is signed in with uid: \(user.uid)")
            if let savedUserID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIDKey") {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: savedUserID) { [weak self] (credentialState, error) in
                    guard let self = self else { return }
                    switch credentialState {
                    case .authorized:
                        // The Apple ID credential is still valid.
                        print("User is signed in with Apple ID.")
                        // Proceed to the main app screen.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                            guard let self = self else { return }
                            self.transitionToMainApp()
                        }
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or does not exist.
                        print("Apple ID credential revoked or not found. Showing onboarding screens.")
                        DispatchQueue.main.async {
                            self.showOnBoardingScreens()
                        }
                    default:
                        break
                     }
               }
            }
            
            else {
                // Proceed to the main app screen.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    guard let self = self else { return }
                    self.transitionToMainApp()
                }
            }
        } else {
            print("No user is signed in. Showing onboarding screens.")
            self.showOnBoardingScreens()
            
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
    
    private func showOnBoardingScreens() {
        let onboardingPageVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        onboardingPageVC.modalTransitionStyle = .crossDissolve
        onboardingPageVC.modalPresentationStyle = .fullScreen
        present(onboardingPageVC, animated: true, completion: nil)
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
    
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully.")
            // Navigate to the login screen or take necessary action
            // For example, if you are using a navigation controller:
            // self.navigationController?.popToRootViewController(animated: true)
            if let savedUserID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIDKey") {
                UserDefaults.standard.removeObject(forKey: "appleAuthorizedUserIDKey")
            }
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
   
}
