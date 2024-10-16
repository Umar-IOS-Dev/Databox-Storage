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
import AuthenticationServices
import CryptoKit
import Amplify
import AWSCognitoIdentityProvider
import AWSCognitoAuthPlugin
import AWSCognitoIdentity
import AWSAPIPlugin





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
    
    private let appleContainerView: UIView = {
        let appleContainerView = UIView()
        appleContainerView.backgroundColor = .clear
        appleContainerView.heightAnchor == DesignMetrics.Dimensions.height60
        return appleContainerView
    }()
    
    fileprivate var currentNonce: String?
    
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
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        setupTopAppIconView()
        configureWelcomeDataBoxLabels()
        configureGuestAndNumberView()
        configureSepratorView()
        configureGoogleSignInView()
        setupAppleSignInButton()
    }
    
    private func setupTopAppIconView() {
        view.addSubview(customView)
        
        customView.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size12
        customView.leadingAnchor == view.leadingAnchor
        customView.trailingAnchor == view.trailingAnchor
        customView.heightAnchor == view.bounds.height * 0.25 //view.heightAnchor * 0.10
        customView.animateIcons()
        //customView.rotateIconImageView()
        appendViewToMainVStack(view: customView)
    }
    
    private func configureWelcomeDataBoxLabels() {
        let welcomeStack = UIStackView()
        welcomeStack.axis = .vertical
        welcomeStack.spacing = DesignMetrics.Padding.size0
        
        let welcomeLabel = UILabel()
        welcomeLabel.font = FontManagerDatabox.shared.cloudVaultItalicSemiLightText(ofSize: 22)
        welcomeLabel.textColor = UIColor(named: "loginTitleTextColor")
        welcomeLabel.textAlignment = .left
        welcomeLabel.text = "Welcome to"
        welcomeLabel.heightAnchor == DesignMetrics.Padding.size24
        
        let dataBoxLabel = UILabel()
        dataBoxLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 50)
        dataBoxLabel.textColor = UIColor(named: "loginTitleTextColor")
        dataBoxLabel.textAlignment = .left
        dataBoxLabel.text = "Databox"
        
        welcomeStack.addArrangedSubview(welcomeLabel)
        welcomeStack.addArrangedSubview(dataBoxLabel)
        
        welcomeView.addSubview(welcomeStack)
        welcomeStack.edgeAnchors == welcomeView.edgeAnchors
        appendViewToMainVStack(view: welcomeView)
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
        guestLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 20)
        
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
        numberLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 20)
        
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
        appendViewToMainVStack(view: guestAndNumberView, topPadding: DesignMetrics.Padding.size24)
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
        sepratorLabel.textColor = UIColor(named: "loginTitleTextColor")
        sepratorLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 18)
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
        googleAccountLabel.textColor = UIColor(named: "loginTitleTextColor")
        googleAccountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 18)
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
    
    private func setupAppleSignInButton() {
        let appleView = UIView()
        appleView.backgroundColor = #colorLiteral(red: 0.7777122855, green: 0.7926475406, blue: 0.8181691766, alpha: 1).withAlphaComponent(0.4)
        appleContainerView.addSubview(appleView)
        
        appleView.layer.cornerRadius = DesignMetrics.Padding.size8
        appleView.topAnchor == appleContainerView.topAnchor
        appleView.bottomAnchor == appleContainerView.bottomAnchor
        appleView.widthAnchor == DesignMetrics.Dimensions.width247
        appleView.centerXAnchor == appleContainerView.centerXAnchor
        
//        
//        let appleSignInButton = ASAuthorizationAppleIDButton()
//        appleSignInButton.backgroundColor = .clear
//        appleSignInButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
//        appleView.addSubview(appleSignInButton)
        
        
        
        // Create a custom button
               let customAppleSignInButton = UIButton(type: .system)
               customAppleSignInButton.setTitle("Sign in with Apple", for: .normal)
               customAppleSignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
               customAppleSignInButton.setTitleColor(UIColor(named: "loginTitleTextColor"), for: .normal)
               customAppleSignInButton.backgroundColor = .clear
               customAppleSignInButton.layer.cornerRadius = 8
               
               // Add an icon to the button (optional)
               if let appleLogo = UIImage(systemName: "applelogo") {
                   customAppleSignInButton.setImage(appleLogo, for: .normal)
                   customAppleSignInButton.tintColor = UIColor(named: "loginTitleTextColor")
                   customAppleSignInButton.imageView?.contentMode = .scaleAspectFit
                   customAppleSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
               }
        
        // Set button constraints or frame
               // customAppleSignInButton.frame = CGRect(x: 50, y: 100, width: 250, height: 50) // Example frame
        appleView.addSubview(customAppleSignInButton)
        customAppleSignInButton.edgeAnchors == appleView.edgeAnchors
                
                // Add action for the button
                customAppleSignInButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        
        
        //appleSignInButton.edgeAnchors == appleView.edgeAnchors
        appendViewToMainVStack(view: appleContainerView, topPadding: 12)
    }
    
    @objc func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
               let request = appleIDProvider.createRequest()
               request.requestedScopes = [.fullName, .email]
               
               let authorizationController = ASAuthorizationController(authorizationRequests: [request])
               authorizationController.delegate = self
               authorizationController.presentationContextProvider = self
               authorizationController.performRequests()
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

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.refreshToken.tokenString)

                    Auth.auth().signIn(with: credential) { result, error in
                        if let error = error {
                            // Handle error
                            print("Error signing in: \(error)")
                        } else {
                            // User is signed in
                            print("User signed in")
                           // self.navigateOutOfOtpPinForGoogleAndPhone()
//                            if let idTokenData = idToken.data(using: .utf8) { // Replace with your actual token
//                                self.federateToIdentityPools(with: idToken)
//                            }
                            self.configureAmplify(with: idToken)
                            
                            
                        }
                    }
                }
    }
    
    func configureAmplify(with token: String) {

        
        do {
            // Automatically loads from amplifyconfiguration.json
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            Amplify.Logging.logLevel = .debug

            print("Amplify configured successfully")
            Task {
               try await self.federateToIdentityPoolsUsingCustomIdentityId(with: token)
            }
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        
    }
    
    
    
//    func federateToIdentityPools(with token: String) {
//        // Ensure that the token is valid
//        guard !token.isEmpty else {
//            print("Token is empty")
//            return
//        }
//
//        Task {
//            do {
//                let plugin = try Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin
//
//                let developerProvidedIdentity = "securetoken.google.com/databox-ios"
//                // Create options with a developerProvidedIdentityID if available, or pass nil for now
//                let options = AuthFederateToIdentityPoolRequest.Options()
//
//                // Call federateToIdentityPool with the options
//                let result = try await plugin?.federateToIdentityPool(withProviderToken: token, for: .google, options: options)
//
//                print("Successfully federated user to identity pool with result:", result ?? "")
//            } catch {
//                print("Failed to federate to identity pool with error:", error)
//                // Retry federating the user if necessary
//                self.federateToIdentityPools(with: token)
//            }
//        }
//    }
    
    
    func federateToIdentityPools(with token: String) {
        guard
            let plugin = try? Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin
        else { return }
        
        Task {
            do {
                let result = try await plugin.federateToIdentityPool(
                    withProviderToken: token,
                    for: .google
                )
                print("Successfully federated user to identity pool with result:", result)
            } catch {
                print("Failed to federate to identity pool with error:", error)
                Task {
                    try await clearFederationToIdentityPools()
                }
            }
        }
    }
    
    func clearFederationToIdentityPools() async throws {
        guard let authCognitoPlugin = try Amplify.Auth.getPlugin(
            for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin else {
            fatalError("Unable to get the Auth plugin")
        }
        do {
            try await authCognitoPlugin.clearFederationToIdentityPool()
            print("Federation cleared successfully")
        } catch {
            print("Clear federation failed with error: \(error)")
        }
    }
    
    func federateToIdentityPoolsUsingCustomIdentityId(with token: String) async throws {
        guard let authCognitoPlugin = try Amplify.Auth.getPlugin(
            for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin else {
            fatalError("Unable to get the Auth plugin")
        }
        do {
            let identityId = "us-east-1_Le3C0PcJd"
            let result = try await authCognitoPlugin.federateToIdentityPool(
                withProviderToken: token,
                for: .google,
                options: .init(developerProvidedIdentityID: nil))
            print("Federation successful with result: \(result)")
        } catch {
            print("Failed to federate to identity pools with error: \(error)")
            Task {
               // try await clearFederationToIdentityPools()
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
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}

extension LoginViewController: OtpSuccesCardControllerDelegate {
    func showContent() {
       showViews()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let identityToken = appleIDCredential.identityToken
            let authorizationCode = appleIDCredential.authorizationCode
            
            // Convert identityToken and authorizationCode to String
            guard let identityTokenString = identityToken != nil ? String(data: identityToken!, encoding: .utf8) : nil else { return }
            guard let authorizationCodeString = authorizationCode != nil ? String(data: authorizationCode!, encoding: .utf8) : nil else { return }
            let nonce = randomNonceString()
            currentNonce = nonce
            
            let firebaseCredential = OAuthProvider.credential(
                withProviderID: "apple.com",               // Correct provider ID for Apple Sign-In
                idToken: identityTokenString,          // ID token received from Apple
                rawNonce: sha256(nonce),               // Your hashed nonce if you're using it
                accessToken: authorizationCodeString   // Authorization code from Apple (optional)
            )
            
            
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                if let error = error {
                    print("Firebase sign in with Apple credential failed: \(error)")
                    return
                }
                
                // User is signed in
                print("User is signed in with Firebase UID: \(authResult?.user.uid ?? "")")
                UserDefaults.standard.set(userID, forKey: "appleAuthorizedUserIDKey")
                // Proceed to the main app screen
                self.navigateOutOfOtpPinForGoogleAndPhone()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print("Sign in with Apple failed: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


