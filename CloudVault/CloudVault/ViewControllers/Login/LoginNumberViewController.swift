//
//  LoginNumberViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 11/07/2024.
//

import UIKit
import Anchorage

class LoginNumberViewController: BaseViewController {
    
    private var countryCode = "+92"
    private var userNumber = ""
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
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "333332443445"
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
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
        configureHaedingAndSubLabel()
        configurePhoneNumberView()
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
    
    private func configureHaedingAndSubLabel() {
        let containerView = UIView()
        containerView.backgroundColor = .clear//.neuphoriaWhite.withAlphaComponent(0.15)
        containerView.heightAnchor == DesignMetrics.Dimensions.height56
        
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = DesignMetrics.Padding.size12
        
        let headingLabel = UILabel()
        headingLabel.font = UIFont.cloudVaultBoldText(ofSize: 24)
        headingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabel.textAlignment = .left
        headingLabel.text = "Enter Your Number"
        headingLabel.heightAnchor == DesignMetrics.Padding.size20
        
        let subHeadingLabel = UILabel()
        subHeadingLabel.font = UIFont.cloudVaultItalicSemiLightText(ofSize: 16)
        subHeadingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 0.6978900935)
        subHeadingLabel.textAlignment = .left
        subHeadingLabel.numberOfLines = 0
        subHeadingLabel.text = "Enter your mobile number to generate OTP"
        
        containerStack.addArrangedSubview(headingLabel)
        containerStack.addArrangedSubview(subHeadingLabel)
        
        containerView.addSubview(containerStack)
        containerStack.edgeAnchors == containerView.edgeAnchors
        appendViewToMainVStack(view: containerView, topPadding: DesignMetrics.Padding.size24)
    }
    
    
    private func addChildViewController() {
        // Initialize the child view controller
        let loginVC = LoginViewController()
        // Add Child View Controller
        addChild(loginVC)
        // Notify Child View Controller
        loginVC.didMove(toParent: self)
        // Ensure the child view controller's view is loaded
        _ = loginVC.view
        // Add the guestAndNumberView from the child view controller
        appendViewToMainVStack(view: loginVC.guestAndNumberView)
    }
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        print("is appeared = \(isAppearing)")
    }
    
    private func configurePhoneNumberView() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        containerView.heightAnchor == DesignMetrics.Dimensions.height70
        containerView.layer.cornerRadius = DesignMetrics.Padding.size8
        
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.spacing = DesignMetrics.Padding.size12
        
        let countryButton = UIButton()
        countryButton.setTitle("", for: .normal)
        countryButton.setImage(UIImage(named: "flag"), for: .normal)
        countryButton.heightAnchor == DesignMetrics.Dimensions.height33
        countryButton.widthAnchor == DesignMetrics.Dimensions.width36
        
        let countryArrowButton = UIButton()
        countryArrowButton.setTitle("", for: .normal)
        countryArrowButton.setImage(UIImage(named: "downArrow"), for: .normal)
        countryArrowButton.heightAnchor == DesignMetrics.Dimensions.height14
        countryArrowButton.widthAnchor == DesignMetrics.Dimensions.width14
        
        let countryCodeButton = UIButton()
        countryCodeButton.setTitle("+92", for: .normal)
        countryCodeButton.setFont(UIFont.cloudVaultSemiBoldText(ofSize: 23), for: .normal)
        countryCodeButton.heightAnchor == DesignMetrics.Dimensions.height33
        countryCodeButton.widthAnchor == DesignMetrics.Dimensions.width50
        let buttonColor: UIColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        countryCodeButton.setTitleColor(buttonColor, for: .normal)
        
        let sepratorImage = UIImageView()
        sepratorImage.image = UIImage(named: "sepratorImage")
        sepratorImage.heightAnchor == DesignMetrics.Dimensions.height28
        sepratorImage.widthAnchor == DesignMetrics.Dimensions.width3
        
        numberTextField.heightAnchor == DesignMetrics.Dimensions.height33
        numberTextField.delegate = self
        
        containerStack.addArrangedSubview(countryButton)
        containerStack.addArrangedSubview(countryArrowButton)
        containerStack.addArrangedSubview(countryCodeButton)
        containerStack.addArrangedSubview(sepratorImage)
        containerStack.addArrangedSubview(numberTextField)
        
        containerView.addSubview(containerStack)
        containerStack.edgeAnchors == containerView.edgeAnchors + DesignMetrics.Padding.size10
        appendViewToMainVStack(view: containerView,topPadding: DesignMetrics.Padding.size20)
        
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
            userNumber = numberTextField.text ?? ""
            guard userNumber.count > 2 else {return}
            let lastThreeDigit = String(userNumber.suffix(3))
            let numberWithCountryCode = "\(countryCode)...........\(lastThreeDigit)"
            guard navigationController != nil else { print("not navigation")
                return }
            let OtpVC = OTPViewController()
            OtpVC.userNumber = numberWithCountryCode
            self.navigationController?.pushViewController(OtpVC, animated: true)
        }
    }
    
}

extension LoginNumberViewController: UITextFieldDelegate {
    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // Enable the button if the text length is greater than 0
        nextButton.isEnabled = updatedText.count > 2
        if(nextButton.isEnabled) {
            nextButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        }
        else {
            nextButton.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        }
        return true
    }
}


