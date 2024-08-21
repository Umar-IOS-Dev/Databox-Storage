//
//  LoginWithEmailViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 15/07/2024.
//

import UIKit
import Anchorage

class LoginWithEmailViewController: BaseViewController {
    
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
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Email Here"
        textField.backgroundColor = .clear
        textField.keyboardType = .emailAddress
        textField.borderStyle = .none
        return textField
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
        setupTopAppIconView()
        configureHaedingAndEmailView()
        configureNextButtton()
    }
    
    private func setupTopAppIconView() {
        view.addSubview(customView)
        customView.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size12
        customView.leadingAnchor == view.leadingAnchor
        customView.trailingAnchor == view.trailingAnchor
        customView.heightAnchor == view.heightAnchor * 0.25
        appendViewToMainVStack(view: customView)
    }
    
    private func configureHaedingAndEmailView() {
        let containerView = UIView()
        containerView.backgroundColor = .clear//.neuphoriaWhite.withAlphaComponent(0.15)
        containerView.heightAnchor == DesignMetrics.Dimensions.height100
        
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
        
        emailContainerView.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.edgeAnchors == emailContainerView.edgeAnchors + DesignMetrics.Padding.size8
        
        containerStack.addArrangedSubview(headingLabel)
        containerStack.addArrangedSubview(emailContainerView)
        
        containerView.addSubview(containerStack)
        containerStack.edgeAnchors == containerView.edgeAnchors
        appendViewToMainVStack(view: containerView, topPadding: DesignMetrics.Padding.size24)
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
            guard emailTextField.text?.count ?? 0 > 2 else {return}
            
            print("email next Tapped")
            let emailPasswordVC = LoginWithEmailPasswordViewController()
            self.navigationController?.pushViewController(emailPasswordVC, animated: true)
        }
    }
}

extension LoginWithEmailViewController: UITextFieldDelegate {
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // Enable the button if the text length is greater than 0
        nextButton.isEnabled = updatedText.contains("@")
        
        if(nextButton.isEnabled) {
            nextButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        }
        else {
            nextButton.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        }
        return true
    }
}
