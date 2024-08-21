//
//  LoginWithEmailPasswordViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 15/07/2024.
//

import UIKit
import Anchorage

class LoginWithEmailPasswordViewController: BaseViewController {
    
    let customView = AppIconView(backgroundImage: UIImage(named: "appIconBgImage")!, iconImage: UIImage(named: "appIconImage")!)
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        let titleColorForDisableState: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.isEnabled = false
        button.setTitleColor(titleColorForDisableState, for: .normal)
        button.setTitleColor(titleColorForDisableState, for: .disabled)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        return button
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Password Here"
        textField.backgroundColor = .clear
        textField.keyboardType = .emailAddress
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        return textField
    }()
    private let togglePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    private let headinfAndPasswordContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.heightAnchor == DesignMetrics.Dimensions.height100
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "", showBackButton: true)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        self.setupTopAppIconView()
        self.configureHaedingAndPasswordView()
        self.configureNextButtton()
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let buttonImageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    private func setupTopAppIconView() {
        view.addSubview(customView)
        customView.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size12
        customView.leadingAnchor == view.leadingAnchor
        customView.trailingAnchor == view.trailingAnchor
        customView.heightAnchor == view.heightAnchor * 0.25
        appendViewToMainVStack(view: customView)
    }
    
    private func configureHaedingAndPasswordView() {
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = DesignMetrics.Padding.size12
        
        let headingLabel = UILabel()
        headingLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 18)
        headingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabel.textAlignment = .left
        headingLabel.text = "Email"
        headingLabel.heightAnchor == DesignMetrics.Padding.size20
        
        let emailContainerView = UIView()
        emailContainerView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        emailContainerView.heightAnchor == DesignMetrics.Dimensions.height70
        emailContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        
        emailContainerView.addSubview(passwordTextField)
        emailContainerView.addSubview(togglePasswordButton)
        togglePasswordButton.trailingAnchor == passwordTextField.trailingAnchor
        togglePasswordButton.centerYAnchor == passwordTextField.centerYAnchor
        passwordTextField.delegate = self
        passwordTextField.edgeAnchors == emailContainerView.edgeAnchors + DesignMetrics.Padding.size8
        
        containerStack.addArrangedSubview(headingLabel)
        containerStack.addArrangedSubview(emailContainerView)
        
        headinfAndPasswordContainerView.addSubview(containerStack)
        containerStack.edgeAnchors == headinfAndPasswordContainerView.edgeAnchors
        appendViewToMainVStack(view: headinfAndPasswordContainerView, topPadding: DesignMetrics.Padding.size24)
    }
    
    private func configureNextButtton() {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.heightAnchor == DesignMetrics.Dimensions.height65
        
        containerView.addSubview(nextButton)
        nextButton.heightAnchor == DesignMetrics.Dimensions.height50
        nextButton.widthAnchor == DesignMetrics.Dimensions.width166
        nextButton.centerXAnchor == containerView.centerXAnchor
        nextButton.centerYAnchor == containerView.centerYAnchor
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        appendViewToMainVStack(view: containerView, topPadding: 20)
    }
    
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        if(sender.isEnabled) {
            guard navigationController != nil else { print("not navigation")
                return }
            guard passwordTextField.text?.count ?? 0 > 7 else {return}
            print("password next Tapped")
            navigateOutOfOtpPin()
        }
    }
    
}

extension LoginWithEmailPasswordViewController: UITextFieldDelegate {
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // Enable the button if the text length is greater than 0
        nextButton.isEnabled = updatedText.count > 7
        if(nextButton.isEnabled) {
            nextButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        }
        else {
            nextButton.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        }
        return true
    }
}

extension LoginWithEmailPasswordViewController {
    func navigateOutOfOtpPin() {
        hideViews()
        let cardVC = OtpSuccessViewController(title: "Verification Completed", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", buttonTitle: "Create Your Profile", loginAsGuest: false, createProfileWith: .profileGoogle, isButtonHidden: false, successViewHeight: 400)
        
        let transitionDelegate = CardTransitioningDelegate()
        cardVC.transitioningDelegate = transitionDelegate
        cardVC.modalPresentationStyle = .custom
        cardVC.delegate = self
        present(cardVC, animated: true, completion: nil)
        print("goto Main ViewController")
    }
    
    private func hideViews() {
        customView.isHidden = true
        headinfAndPasswordContainerView.isHidden = true
        nextButton.isHidden = true
        self.view.alpha = 0.7
    }
    
    private func showViews() {
        customView.isHidden = false
        headinfAndPasswordContainerView.isHidden = false
        nextButton.isHidden = false
        self.view.alpha = 1.0
    }
}

extension LoginWithEmailPasswordViewController: OtpSuccesCardControllerDelegate {
    func showContent() {
        showViews()
    }
}
