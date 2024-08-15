//
//  OtpSuccessViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 13/07/2024.
//

import UIKit
import Anchorage


protocol OtpSuccesCardControllerDelegate: AnyObject {
    func showContent()
}

class OtpSuccessViewController: UIViewController {
    
    private let otpSuccessView: OtpSuccessView
    private var loginAsGuest: Bool = true
    private var createProfileWith: Profile = .profileGoogle
    weak var delegate: OtpSuccesCardControllerDelegate?
    private var successViewHeight = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        otpSuccessView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otpSuccessView)
        
        
        otpSuccessView.centerAnchors == view.centerAnchors
        otpSuccessView.widthAnchor == view.widthAnchor * 0.84
        otpSuccessView.heightAnchor == successViewHeight//view.heightAnchor * 0.54
        
        otpSuccessView.otpSuccessDelegate = self
        if(loginAsGuest) {
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCard))
                    view.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func dismissCard() {
        self.delegate?.showContent()
        dismiss(animated: true, completion: nil)
    }
    
    init(title: String, subTitle: String, buttonTitle: String, loginAsGuest: Bool, createProfileWith: Profile, isButtonHidden: Bool,successViewHeight: CGFloat) {
        self.otpSuccessView = OtpSuccessView(title: title, subTitle: subTitle, buttonText: buttonTitle, isButtonHidden: isButtonHidden)
        self.loginAsGuest =  loginAsGuest
        self.createProfileWith = createProfileWith
        self.successViewHeight = successViewHeight
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func showLoginViewController() {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        // Set LoginViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func showProfileForNumberOrGmailController() {
        let createProfileVC = CreateProfileViewController(titleOfProfile: .phoneNumberOrGoogle, createProfileWith: createProfileWith)
        let navigationController = UINavigationController(rootViewController: createProfileVC)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func showProfileforGuestController() {
        let loginVC = LoginWithEmailViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        // Set LoginViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

}

extension OtpSuccessViewController: OtpSuccessCardViewDelegate {
    func didTapCardButton() {
        self.loginAsGuest == true ? showProfileforGuestController() : showProfileForNumberOrGmailController()
        
    }
}
