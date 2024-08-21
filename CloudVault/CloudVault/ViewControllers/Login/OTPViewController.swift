//
//  OTPViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 12/07/2024.
//

import UIKit
import Anchorage
import FirebaseAuth

class OTPViewController: BaseViewController {
    
    let customView = AppIconView(backgroundImage: UIImage(named: "appIconBgImage")!, iconImage: UIImage(named: "appIconImage")!)
    var userNumber = ""
    let userPhoneNumber = "+923475248433"
    let userOtp = "111100"
    var verificationID = ""
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private var enteredOTP: String = "------"
    private let wrongOtpLabel: UILabel = {
        let otplabel = UILabel()
        otplabel.textAlignment = .left
        otplabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        otplabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 14)
        otplabel.isHidden = true
        otplabel.text = "Your Verification code is wrong try another one"
        return otplabel
    }()
    private let numberTextField1: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let numberTextField2: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let numberTextField3: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let numberTextField4: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let numberTextField5: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let numberTextField6: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 22)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        return textField
    }()
    private let headingAndSubLabelView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    private let otpContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    private let verifyOtpContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    private let resendOtpContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    private let timerLabel: UILabel = {
            let label = UILabel()
            label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
            label.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
            label.textAlignment = .center
            label.text = "00:60"
            return label
        }()
    private let resendButton: UIButton = {
            let button = UIButton()
            let titleColorForButton = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
            button.titleLabel?.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
            button.backgroundColor = .clear
            button.setTitleColor(titleColorForButton, for: .normal)
            button.setTitle("Resend OTP", for: .normal)
            button.addTarget(self, action: #selector(resendButtonTapped(_:)), for: .touchUpInside)
            button.isEnabled = false
            button.alpha = 0.5
            return button
        }()
    private var timer: Timer?
    private var secondsRemaining = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "", showBackButton: true)
        hideFocusbandOptionFromNavBar()
        
        // Disable app verification for testing
         Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        setupActivityIndicator()
        self.view.bringSubviewToFront(activityIndicator)
        startTimer()
    }
    
    func setupActivityIndicator() {
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            view.addSubview(activityIndicator)
        }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        setupTopAppIconView()
        configureHaedingAndSubLabel()
        configureOtpView()
        configureVerifyOtpView()
        configureTimerLabel()
        configureResendOtpView()
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
        headingAndSubLabelView.backgroundColor = .clear
        headingAndSubLabelView.heightAnchor == DesignMetrics.Dimensions.height60
        
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = DesignMetrics.Padding.size12
        
        let headingLabel = UILabel()
        headingLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 24)
        headingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabel.textAlignment = .left
        headingLabel.text = "Verify OTP"
        headingLabel.heightAnchor == DesignMetrics.Padding.size32
        
        let subHeadingLabel = UILabel()
        subHeadingLabel.font = FontManagerDatabox.shared.cloudVaultItalicSemiLightText(ofSize: 16)
        subHeadingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 0.6978900935)
        subHeadingLabel.textAlignment = .left
        subHeadingLabel.numberOfLines = 0
        subHeadingLabel.text = "OTP sent to \(userNumber)"
        
        containerStack.addArrangedSubview(headingLabel)
        containerStack.addArrangedSubview(subHeadingLabel)
        
        headingAndSubLabelView.addSubview(containerStack)
        containerStack.edgeAnchors == headingAndSubLabelView.edgeAnchors
        appendViewToMainVStack(view: headingAndSubLabelView, topPadding: DesignMetrics.Padding.size24)
    }
    
    private func configureOtpView() {
        otpContainerView.backgroundColor = .clear
        otpContainerView.heightAnchor == DesignMetrics.Dimensions.height53
        
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.distribution = .equalSpacing
        
        let otpView1 = UIView()
        otpView1.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView1.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView1.widthAnchor == DesignMetrics.Dimensions.width44
        otpView1.heightAnchor == DesignMetrics.Dimensions.height53
        
        let otpView2 = UIView()
        otpView2.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView2.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView2.widthAnchor == DesignMetrics.Dimensions.width44
        otpView2.heightAnchor == DesignMetrics.Dimensions.height53
        
        let otpView3 = UIView()
        otpView3.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView3.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView3.widthAnchor == DesignMetrics.Dimensions.width44
        otpView3.heightAnchor == DesignMetrics.Dimensions.height53
        
        let otpView4 = UIView()
        otpView4.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView4.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView4.widthAnchor == DesignMetrics.Dimensions.width44
        otpView4.heightAnchor == DesignMetrics.Dimensions.height53
        
        
        let otpView5 = UIView()
        otpView5.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView5.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView5.widthAnchor == DesignMetrics.Dimensions.width44
        otpView5.heightAnchor == DesignMetrics.Dimensions.height53
        
        let otpView6 = UIView()
        otpView6.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        otpView6.layer.cornerRadius = DesignMetrics.Padding.size4
        otpView6.widthAnchor == DesignMetrics.Dimensions.width44
        otpView6.heightAnchor == DesignMetrics.Dimensions.height53
        
        otpView1.addSubview(numberTextField1)
        otpView2.addSubview(numberTextField2)
        otpView3.addSubview(numberTextField3)
        otpView4.addSubview(numberTextField4)
        otpView5.addSubview(numberTextField5)
        otpView6.addSubview(numberTextField6)
        
        containerStack.addArrangedSubview(otpView1)
        containerStack.addArrangedSubview(otpView2)
        containerStack.addArrangedSubview(otpView3)
        containerStack.addArrangedSubview(otpView4)
        containerStack.addArrangedSubview(otpView5)
        containerStack.addArrangedSubview(otpView6)
        
        numberTextField1.delegate = self
        numberTextField1.tag = 1
        numberTextField2.delegate = self
        numberTextField2.tag = 2
        numberTextField3.delegate = self
        numberTextField3.tag = 3
        numberTextField4.delegate = self
        numberTextField4.tag = 4
        numberTextField5.delegate = self
        numberTextField5.tag = 5
        numberTextField6.delegate = self
        numberTextField6.tag = 6
        
        numberTextField1.edgeAnchors == otpView1.edgeAnchors
        numberTextField2.edgeAnchors == otpView2.edgeAnchors
        numberTextField3.edgeAnchors == otpView3.edgeAnchors
        numberTextField4.edgeAnchors == otpView4.edgeAnchors
        numberTextField5.edgeAnchors == otpView5.edgeAnchors
        numberTextField6.edgeAnchors == otpView6.edgeAnchors
        
        otpContainerView.addSubview(containerStack)
        containerStack.edgeAnchors == otpContainerView.edgeAnchors
        appendViewToMainVStack(view: otpContainerView,topPadding: 30)
    }
    
    private func configureVerifyOtpView() {
        verifyOtpContainerView.backgroundColor = .clear
        verifyOtpContainerView.heightAnchor == DesignMetrics.Dimensions.height90
        
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = 12
        
        wrongOtpLabel.heightAnchor == DesignMetrics.Dimensions.height22
        
        let buttonContainerView = UIView()
        buttonContainerView.backgroundColor = .clear
        buttonContainerView.heightAnchor == DesignMetrics.Dimensions.height50
        
        let verifyButton = UIButton()
        let titleColorForButton = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonContainerView.addSubview(verifyButton)
        
        verifyButton.layer.cornerRadius = DesignMetrics.Padding.size8
        verifyButton.titleLabel?.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 20)
        verifyButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        verifyButton.setTitleColor(titleColorForButton, for: .normal)
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.widthAnchor == DesignMetrics.Dimensions.width166
        verifyButton.heightAnchor == DesignMetrics.Dimensions.height50
        verifyButton.centerAnchors == buttonContainerView.centerAnchors
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped(_:)), for: .touchUpInside)
        
        containerStack.addArrangedSubview(wrongOtpLabel)
        containerStack.addArrangedSubview(buttonContainerView)
        
        verifyOtpContainerView.addSubview(containerStack)
        containerStack.verticalAnchors == verifyOtpContainerView.verticalAnchors
        containerStack.horizontalAnchors == verifyOtpContainerView.horizontalAnchors
        appendViewToMainVStack(view: verifyOtpContainerView, topPadding: DesignMetrics.Padding.size12)
    }
    
    private func configureTimerLabel() {
        timerLabel.heightAnchor == DesignMetrics.Dimensions.height16
        appendViewToMainVStack(view: timerLabel, topPadding: DesignMetrics.Padding.size12)
    }
    
    private func configureResendOtpView() {
        resendOtpContainerView.backgroundColor = .clear
        resendOtpContainerView.heightAnchor == DesignMetrics.Dimensions.height24
        
        let containerStack = UIStackView()
        containerStack.axis = .horizontal
        containerStack.spacing = 0
        
        let resendLabel = UILabel()
        resendLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        resendLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        resendLabel.textAlignment = .left
        resendLabel.text = "Didn't received OTP?"
        
        containerStack.addArrangedSubview(resendLabel)
        containerStack.addArrangedSubview(resendButton)
        
        
        resendOtpContainerView.addSubview(containerStack)
        
        containerStack.verticalAnchors == resendOtpContainerView.verticalAnchors
        containerStack.widthAnchor == 220 //DesignMetrics.Dimensions.width256
        containerStack.centerXAnchor == resendOtpContainerView.centerXAnchor
        appendViewToMainVStack(view: resendOtpContainerView, topPadding: DesignMetrics.Padding.size24)
    }
    
    private func startTimer() {
            secondsRemaining = 60
            timerLabel.text = "00:60"
            resendButton.isEnabled = false
            resendButton.alpha = 0.5
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        @objc private func updateTimer() {
            if secondsRemaining > 0 {
                secondsRemaining -= 1
                timerLabel.text = String(format: "00:%02d", secondsRemaining)
            } else {
                timer?.invalidate()
                resendButton.isEnabled = true
                resendButton.alpha = 1
            }
        }
    
    
    @objc private func resendButtonTapped(_ sender: UIButton) {
        print("resend Button Tapped")
        startTimer()
    }
    
    @objc private func verifyButtonTapped(_ sender: UIButton) {
        verifyOTP(enteredOTP)
        
        
    }
    
    private func verifyPhoneNumber() {
        activityIndicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(userPhoneNumber, uiDelegate: nil) { verificationID, error in
                   if let error = error {
                       print("Error: \(error.localizedDescription)")
                       self.activityIndicator.stopAnimating()
                       return
                   }
                   
                  self.verificationID = verificationID ?? ""
                   print("Verification ID: \(String(describing: verificationID))")
                   self.verifyUserOtpPin(self.enteredOTP)
               }
    }
    
    private func verifyUserOtpPin(_ otp: String) {
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        self.activityIndicator.stopAnimating()
                        self.wrongOtpLabel.isHidden = false
                        return
                    }
                    self.activityIndicator.stopAnimating()
                    self.wrongOtpLabel.isHidden = true
                    // User signed in
                    print("User signed in: \(String(describing: authResult?.user))")
                    self.navigateOutOfOtpPin()
                }
    }
    
    func verifyOTP(_ otp: String) {
        // Example: Print the OTP for now (replace with your verification logic)
        if((countOccurrences(of: "-", in: enteredOTP)) > 0) {
            print("Invalid OTP is: \(otp)")
            wrongOtpLabel.isHidden = false
            return
        }
        print("Entered OTP is: \(otp)")
//        if otp == "123456" {
//            wrongOtpLabel.isHidden = true
//            print("OTP Verified")
//            navigateOutOfOtpPin()
//        }
//        else {
//            wrongOtpLabel.isHidden = false
//            print("InValid Otp")
//        }
        
        verifyPhoneNumber()
    }
    
    func countOccurrences(of character: Character, in string: String) -> Int {
        var count = 0
        // Iterate through each character in the string
        for char in string {
            // Check if the current character matches the specified character
            if char == character {
                count += 1
            }
        }
        return count
    }
    
    private func showViews() {
        customView.isHidden = false
        headingAndSubLabelView.isHidden = false
        otpContainerView.isHidden = false
        verifyOtpContainerView.isHidden = false
        resendOtpContainerView.isHidden = false
        timerLabel.isHidden = false
        self.view.alpha = 1.0
    }
    
    private func hideViews() {
        customView.isHidden = true
        headingAndSubLabelView.isHidden = true
        otpContainerView.isHidden = true
        verifyOtpContainerView.isHidden = true
        resendOtpContainerView.isHidden = true
        timerLabel.isHidden = true
        self.view.alpha = 0.7
        
    }
    
    
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text != nil else { return false }
        let charcterCount = countOccurrences(of: "-", in: enteredOTP)
        if string.count == 1 { // If a digit is entered
            textField.text = string
            if textField.tag < 6 { // Move to next text field if not the last one
                if(charcterCount > 1) {
                    let indexToReplace = textField.tag - 1 // Replace the ',' character
                    let newCharacter: Character = Character(string)
                    enteredOTP.replaceCharacter(at: indexToReplace, with: newCharacter)
                    print(enteredOTP) // Outputs:
                    let nextTag = textField.tag + 1
                    if let nextResponder = view.viewWithTag(nextTag) as? UITextField {
                        nextResponder.becomeFirstResponder()
                    }
                }
                else {
                    let indexToReplace = textField.tag - 1 // Replace the ',' character
                    let newCharacter: Character = Character(string)
                    enteredOTP.replaceCharacter(at: indexToReplace, with: newCharacter)
                    // verifyOTP(enteredOTP)
                    textField.resignFirstResponder()
                }
            } else { // Last text field, dismiss keyboard
                let indexToReplace = textField.tag - 1 // Replace the ',' character
                let newCharacter: Character = Character(string)
                enteredOTP.replaceCharacter(at: indexToReplace, with: newCharacter)
                //verifyOTP(enteredOTP)
                textField.resignFirstResponder()
            }
            return false
        } else if string.isEmpty { // If backspace is pressed
            textField.text = ""
            if textField.tag > 0 { // Move to previous text field
                let prevTag = textField.tag - 1
                enteredOTP.replaceCharacter(at: prevTag, with: "-")
                print(enteredOTP)
                if let prevResponder = view.viewWithTag(prevTag) as? UITextField {
                    prevResponder.becomeFirstResponder()
                }
            }
            return false
        }
        return false
    }
}
extension OTPViewController {
    func navigateOutOfOtpPin() {
        hideViews()
        let cardVC = OtpSuccessViewController(title: "Verification Completed", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", buttonTitle: "Create Your Profile", loginAsGuest: false, createProfileWith: .profilePhoneNumber, isButtonHidden: false, successViewHeight: 400)
        
        let transitionDelegate = CardTransitioningDelegate()
        cardVC.transitioningDelegate = transitionDelegate
        cardVC.modalPresentationStyle = .custom
        cardVC.delegate = self
        present(cardVC, animated: true, completion: nil)
        print("goto Main ViewController")
    }
}

extension OTPViewController: OtpSuccesCardControllerDelegate {
    func showContent() {
        showViews()
    }
}

