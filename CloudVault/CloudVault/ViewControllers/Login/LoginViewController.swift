//
//  LoginViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/07/2024.
//

import UIKit
import Anchorage
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LoginViewController: BaseViewController {
    
    private let customView = AppIconView(backgroundImage: UIImage(named: "appIconBgImage")!, iconImage: UIImage(named: "appIconImage")!)
     let guestAndNumberView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
    private let welcomeView: UIView = {
        let welcomeView = UIView()
        welcomeView.backgroundColor = .clear
        welcomeView.heightAnchor == DesignMetrics.Dimensions.height74
        return welcomeView
    }()
    private let sepratorView: UIView = {
        let sepratorView = UIView()
        sepratorView.backgroundColor = .clear
        sepratorView.heightAnchor == DesignMetrics.Dimensions.height14
        return sepratorView
    }()
    private let googleContainerView: UIView = {
        let googleContainerView = UIView()
        googleContainerView.backgroundColor = .clear
        googleContainerView.heightAnchor == DesignMetrics.Dimensions.height60
        return googleContainerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "", showBackButton: false)
        hideFocusbandOptionFromNavBar()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                // Create Google Sign In configuration object
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        setupTopAppIconView()
        configureWelcomeDataBoxLabels()
        configureGuestAndNumberView()
        configureSepratorView()
        configureGoogleSignInView()
    }
    
    private func setupTopAppIconView() {
        view.addSubview(customView)
        
        customView.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size12
        customView.leadingAnchor == view.leadingAnchor
        customView.trailingAnchor == view.trailingAnchor
        customView.heightAnchor == view.heightAnchor * 0.25
        appendViewToMainVStack(view: customView)
    }
    
    private func configureWelcomeDataBoxLabels() {
        let welcomeStack = UIStackView()
        welcomeStack.axis = .vertical
        welcomeStack.spacing = DesignMetrics.Padding.size0
        
        let welcomeLabel = UILabel()
        welcomeLabel.font = UIFont.cloudVaultItalicSemiLightText(ofSize: 22)
        welcomeLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        welcomeLabel.textAlignment = .left
        welcomeLabel.text = "Welcome to"
        welcomeLabel.heightAnchor == DesignMetrics.Padding.size24
        
        let dataBoxLabel = UILabel()
        dataBoxLabel.font = UIFont.cloudVaultBoldText(ofSize: 50)
        dataBoxLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        dataBoxLabel.textAlignment = .left
        dataBoxLabel.text = "Databox"
        
        welcomeStack.addArrangedSubview(welcomeLabel)
        welcomeStack.addArrangedSubview(dataBoxLabel)
        
        welcomeView.addSubview(welcomeStack)
        welcomeStack.edgeAnchors == welcomeView.edgeAnchors
        appendViewToMainVStack(view: welcomeView, topPadding: DesignMetrics.Padding.size16)
    }
    
    private func configureGuestAndNumberView() {
        guestAndNumberView.heightAnchor == DesignMetrics.Dimensions.height156
        
        let guestAndNumberStackView = UIStackView()
        guestAndNumberStackView.axis = .vertical
        guestAndNumberStackView.spacing = DesignMetrics.Padding.size16
        
        let guestView = UIView()
        guestView.layer.cornerRadius = DesignMetrics.Padding.size8
        guestView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        guestView.heightAnchor == DesignMetrics.Dimensions.height70
        
        let numberView = UIView()
        numberView.layer.cornerRadius = DesignMetrics.Padding.size8
        numberView.backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.737254902, blue: 0.3647058824, alpha: 1)
        numberView.heightAnchor == DesignMetrics.Dimensions.height70
        
        guestAndNumberStackView.addArrangedSubview(guestView)
        guestAndNumberStackView.addArrangedSubview(numberView)
        
        let guestViewStack = UIStackView()
        guestViewStack.axis = .horizontal
        guestViewStack.spacing = DesignMetrics.Padding.size24
      
        let guestIconImageView = UIImageView()
        guestIconImageView.image = UIImage(named: "personIcon")
        guestIconImageView.contentMode = .scaleAspectFit
        guestIconImageView.widthAnchor == DesignMetrics.Dimensions.width28
        guestIconImageView.heightAnchor == DesignMetrics.Dimensions.height34
        
        let guestLabel = UILabel()
        guestLabel.textColor = UIColor.white
        guestLabel.text = "Continue as Guest"
        guestLabel.font = UIFont.cloudVaultBoldText(ofSize: 20)
        
        guestViewStack.addArrangedSubview(guestIconImageView)
        guestViewStack.addArrangedSubview(guestLabel)
        
        guestView.addSubview(guestViewStack)
        guestViewStack.topAnchor == guestView.topAnchor
        guestViewStack.bottomAnchor == guestView.bottomAnchor
        guestViewStack.leadingAnchor == guestView.leadingAnchor + DesignMetrics.Padding.size24
        guestViewStack.trailingAnchor == guestView.trailingAnchor
        
        let numberViewStack = UIStackView()
        numberViewStack.axis = .horizontal
        numberViewStack.spacing = DesignMetrics.Padding.size24
        // 28 * 34
        let numberIconImageView = UIImageView()
        numberIconImageView.image = UIImage(named: "phoneIcon")
        numberIconImageView.contentMode = .scaleAspectFit
        numberIconImageView.widthAnchor == DesignMetrics.Dimensions.width32
        numberIconImageView.heightAnchor == DesignMetrics.Dimensions.height32
        
        let numberLabel = UILabel()
        numberLabel.textColor = UIColor.white
        numberLabel.text = "Continue with Number"
        numberLabel.font = UIFont.cloudVaultBoldText(ofSize: 20)
        
        numberViewStack.addArrangedSubview(numberIconImageView)
        numberViewStack.addArrangedSubview(numberLabel)
        
        numberView.addSubview(numberViewStack)
        numberViewStack.topAnchor == numberView.topAnchor
        numberViewStack.bottomAnchor == numberView.bottomAnchor
        numberViewStack.leadingAnchor == numberView.leadingAnchor + DesignMetrics.Padding.size24
        guestViewStack.trailingAnchor == numberView.trailingAnchor
        
        let transparentNumberButton = UIButton()
        transparentNumberButton.backgroundColor = .clear
        transparentNumberButton.setTitle("", for: .normal)
        numberView.addSubview(transparentNumberButton)
        transparentNumberButton.sizeAnchors == numberView.sizeAnchors
        transparentNumberButton.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
        
        let transparentGuestButton = UIButton()
        transparentGuestButton.backgroundColor = .clear
        transparentGuestButton.setTitle("", for: .normal)
        guestView.addSubview(transparentGuestButton)
        transparentGuestButton.sizeAnchors == guestView.sizeAnchors
        transparentGuestButton.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        
        guestAndNumberView.addSubview(guestAndNumberStackView)
        guestAndNumberStackView.edgeAnchors == guestAndNumberView.edgeAnchors
        appendViewToMainVStack(view: guestAndNumberView, topPadding: DesignMetrics.Padding.size50)
    }
    
    private func configureSepratorView() {
        let sepratorStackView = UIStackView()
        sepratorStackView.axis = .horizontal
        sepratorStackView.spacing = DesignMetrics.Padding.size4
        
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.heightAnchor == DesignMetrics.Padding.size14
        leftImageView.image = UIImage(named: "rightLineImage")
        
        let sepratorLabel = UILabel()
        sepratorLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        sepratorLabel.font = UIFont.cloudVaultRegularText(ofSize: 18)
        sepratorLabel.text = "OR continue with"
        sepratorLabel.heightAnchor == DesignMetrics.Padding.size14
        
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.heightAnchor == DesignMetrics.Padding.size14
        rightImageView.image = UIImage(named: "leftLineImage")
        
        sepratorStackView.addArrangedSubview(leftImageView)
        sepratorStackView.addArrangedSubview(sepratorLabel)
        sepratorStackView.addArrangedSubview(rightImageView)
        
        sepratorView.addSubview(sepratorStackView)
        sepratorStackView.edgeAnchors == sepratorView.edgeAnchors
        appendViewToMainVStack(view: sepratorView, topPadding: DesignMetrics.Padding.size37)
    }
    
    private func configureGoogleSignInView() {
        let googleView = UIView()
        googleView.backgroundColor = #colorLiteral(red: 0.7777122855, green: 0.7926475406, blue: 0.8181691766, alpha: 1).withAlphaComponent(0.4)
        googleContainerView.addSubview(googleView)
        
        googleView.layer.cornerRadius = DesignMetrics.Padding.size8
        googleView.topAnchor == googleContainerView.topAnchor
        googleView.bottomAnchor == googleContainerView.bottomAnchor
        googleView.widthAnchor == DesignMetrics.Dimensions.width247
        googleView.centerXAnchor == googleContainerView.centerXAnchor
        
        let googleStackView = UIStackView()
        googleStackView.axis = .horizontal
        googleStackView.spacing = DesignMetrics.Padding.size16
        
        let googleIconImageView = UIImageView()
        googleIconImageView.image = UIImage(named: "googleIcon")
        googleIconImageView.contentMode = .scaleAspectFit
        googleIconImageView.widthAnchor == DesignMetrics.Dimensions.width28
        googleIconImageView.heightAnchor == DesignMetrics.Dimensions.height28
        
        let googleAccountLabel = UILabel()
        googleAccountLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        googleAccountLabel.font = UIFont.cloudVaultSemiBoldText(ofSize: 18)
        googleAccountLabel.text = "Google Account"
        
        googleStackView.addArrangedSubview(googleIconImageView)
        googleStackView.addArrangedSubview(googleAccountLabel)
        googleView.addSubview(googleStackView)
        
        let transParentGoogleButton = UIButton() // GIDSignInButton()
        transParentGoogleButton.backgroundColor = .clear
//        transParentGoogleButton.setTitle("", for: .normal)
        transParentGoogleButton.alpha = 1
        googleView.addSubview(transParentGoogleButton)
        transParentGoogleButton.sizeAnchors == googleView.sizeAnchors
        transParentGoogleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        googleStackView.topAnchor == googleView.topAnchor
        googleStackView.bottomAnchor == googleView.bottomAnchor
        googleStackView.leadingAnchor == googleView.leadingAnchor + DesignMetrics.Padding.size24
        googleStackView.trailingAnchor == googleView.trailingAnchor
        appendViewToMainVStack(view: googleContainerView, topPadding: DesignMetrics.Padding.size32)
    }
    
    func socialGoogleLogin(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
                    guard error == nil else {
                        // Handle error
                        return
                    }

                    guard let user = result?.user,
                          let idToken = user.idToken?.tokenString else {
                        // Handle error
                        return
                    }

                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

                    Auth.auth().signIn(with: credential) { result, error in
                        if let error = error {
                            // Handle error
                            print("Error signing in: \(error)")
                        } else {
                            // User is signed in
                            print("User signed in")
                            self.navigateOutOfOtpPinForGoogleAndPhone()
                        }
                    }
                }
    }
    
    
    
    @objc func googleButtonTapped() {
        print("googleButtonTapped button tapped")
        guard  navigationController != nil else { print("not Navigation") 
            return }
//        let loginWithEmail = LoginWithEmailViewController()
//        self.navigationController?.pushViewController(loginWithEmail, animated: true)
        socialGoogleLogin()
    }
    
    @objc func guestButtonTapped() {
        print("guestButtonTapped button tapped")
        navigateOutOfOtpPin()
    }
    
    @objc func numberButtonTapped() {
        guard navigationController != nil else { print("not navigation")
            return }
        let loginNumberVC = LoginNumberViewController()
        self.navigationController?.pushViewController(loginNumberVC, animated: true)
    }
    
}

extension LoginViewController {
    func navigateOutOfOtpPin() {
      // // hideViews()
//        let createProfileVC = CreateProfileViewController(titleOfProfile: .guestUser, createProfileWith: .profileGuestUser)
//        self.navigationController?.pushViewController(createProfileVC, animated: true)
        hideViews()
        let cardVC = OtpSuccessViewController(title: "Verification Completed", subTitle: "Lorem Ipsum is simply dummy text of the printing and typesetting industry", buttonTitle: "Create Your Profile", loginAsGuest: false, createProfileWith: .profileGuestUser, isButtonHidden: false, successViewHeight: 400)
        
        let transitionDelegate = CardTransitioningDelegate()
        cardVC.transitioningDelegate = transitionDelegate
        cardVC.modalPresentationStyle = .custom
        cardVC.delegate = self
        present(cardVC, animated: true, completion: nil)
        print("goto Main ViewController")
    }
    
    func navigateOutOfOtpPinForGoogleAndPhone() {
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
        welcomeView.isHidden = true
        guestAndNumberView.isHidden = true
        sepratorView.isHidden = true
        googleContainerView.isHidden = true
        self.view.alpha = 0.7
    }
    
    private func showViews() {
        customView.isHidden = false
        welcomeView.isHidden = false
        guestAndNumberView.isHidden = false
        sepratorView.isHidden = false
        googleContainerView.isHidden = false
        self.view.alpha = 1.0
    }
}

extension LoginViewController: OtpSuccesCardControllerDelegate {
    func showContent() {
       showViews()
    }
}
