//
//  BaseViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 09/07/2024.
//

import UIKit
import Anchorage
import SVProgressHUD
import Lottie

class BaseViewController: UIViewController {

    
    private let mainContentStack = UIStackView()
    
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let footerView = UIView()
    private let navBarContainer = UIView()
    private let focusbandButtonsStack = UIStackView()
    let checkBoxButton = UIButton()
    private let imageActionButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height

        // Find the scroll view in the stack view
        if let scrollView = findScrollView(in: self.view) {
            UIView.animate(withDuration: 0.3) {
                scrollView.contentInset.bottom = keyboardHeight
                scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            if let scrollView = self.findScrollView(in: self.view) {
                scrollView.contentInset.bottom = 0
                scrollView.verticalScrollIndicatorInsets.bottom = 0
            }
        }
    }

    private func findScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for subview in view.subviews {
            if let foundScrollView = findScrollView(in: subview) {
                return foundScrollView
            }
        }
        return nil
    }

    
    
    /// ConfigureUI: Adds mainContentStack to view, ands sets up navbar on top.
    func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        //Basic functionality that you want to include in most of view controllers
        view.backgroundColor = UIColor(named: "appBackgroundColor")//.neuphoriaMainViewBG
        let backgroundImageView = UIImageView(image: .neuphoriaBackgroundImage)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.isHidden = hideBackground
        
        view.addSubview(backgroundImageView)
        backgroundImageView.edgeAnchors == view.edgeAnchors
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add tap gesture recognizer to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        view.addSubview(contentStack)
        if(addHorizontalPadding) {
            contentStack.horizontalAnchors == view.safeAreaLayoutGuide.horizontalAnchors + DesignMetrics.Padding.size16
            contentStack.verticalAnchors == view.safeAreaLayoutGuide.verticalAnchors
        }
        else {
            contentStack.horizontalAnchors == view.safeAreaLayoutGuide.horizontalAnchors
            contentStack.topAnchor == view.safeAreaLayoutGuide.topAnchor
            contentStack.bottomAnchor == view.bottomAnchor
            // contentStack.verticalAnchors == view.safeAreaLayoutGuide.verticalAnchors
        }
        
        contentStack.axis = .vertical
        contentStack.spacing = DesignMetrics.Padding.size16
        contentStack.distribution = .fill
        
        mainContentStack.axis = .vertical
        mainContentStack.distribution = .fill
        
        navBarContainer.isHidden = !showNavBar
        
        contentStack.addArrangedSubview(navBarContainer)
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(mainContentStack)
        mainContentStack.edgeAnchors == scrollView.edgeAnchors
        mainContentStack.heightAnchor >= scrollView.heightAnchor
        mainContentStack.widthAnchor == scrollView.widthAnchor
        
        contentStack.addArrangedSubview(scrollView)
        contentStack.addArrangedSubview(footerView)
        
        if(showMainNavigation) {
            setupNavBarNew(title: title, showBackButton: showBackButton, hideBackground: hideBackground)
        }
        else {
            setupNavBar(title: title, showBackButton: showBackButton, hideBackground: hideBackground, showAsSubViewController: showAsSubViewController)
        }
    }
    
    private func setupNavBar(title: String, showBackButton: Bool, hideBackground: Bool, showAsSubViewController: Bool) {
        if(showAsSubViewController) {
            navBarContainer.heightAnchor == DesignMetrics.Dimensions.height00
            navBarContainer.isHidden = true
        }
        else {
            navBarContainer.heightAnchor == DesignMetrics.Dimensions.height44
            navBarContainer.isHidden = false
            if (hideBackground) {
                navBarContainer.backgroundColor = UIColor(named: "appBackgroundViewColor")
            }
            
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = DesignMetrics.Padding.size12
            
            let backButton = UIButton(type: .system)
            backButton.sizeAnchors == CGSize(width: DesignMetrics.Dimensions.width44, height: DesignMetrics.Dimensions.height44)
            backButton.isHidden = !showBackButton
            if #available(iOS 14.0, *) {
                backButton.addAction(UIAction(handler: { [weak self] _ in
                    self?.backButtonAction()
                }), for: .touchUpInside)
            } else {
                // Fallback on earlier versions
            }
            
            if let backButtonImage = UIImage.cloudVaultBackButton {
                let backButtonColor = UIColor(named: "appPrimaryTextColor") ?? .black
                
                // Apply rendering mode and tint color
                let tintedBackButtonImage = backButtonImage.withRenderingMode(.alwaysTemplate)
                backButton.setImage(tintedBackButtonImage, for: .normal)
                
                // Set the tint color of the button
                backButton.tintColor = backButtonColor
            }
            
            if showBackButton {
                let backButtonView = UIView()
                backButtonView.backgroundColor = .clear
                stackView.addArrangedSubview(backButtonView)
                backButtonView.widthAnchor == DesignMetrics.Dimensions.width50
                backButtonView.addSubview(backButton)
                backButton.topAnchor == backButtonView.topAnchor + 20
                backButton.horizontalAnchors == backButtonView.horizontalAnchors
                //            stackView.addArrangedSubview(backButton)
            }
            
            //titleLabel.font = .neuphoriaTitle
            titleLabel.textColor =  UIColor(named: "appPrimaryTextColor")
            titleLabel.text = title
            titleLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 22)
            titleLabel.heightAnchor == DesignMetrics.Dimensions.height44
            stackView.addArrangedSubview(titleLabel)
            
            let navBarStack = UIStackView()
            navBarStack.axis = .horizontal
            navBarStack.distribution = .fill
            navBarStack.spacing = DesignMetrics.Padding.size16
            navBarContainer.addSubview(navBarStack)
            if(hideBackground) {
                navBarStack.backgroundColor = UIColor(named: "appBackgroundViewColor")
                navBarStack.edgeAnchors == navBarContainer.edgeAnchors - 16
                addButtonsToNavbar(addSpacerView: false)
            }
            else {
                navBarStack.edgeAnchors == navBarContainer.edgeAnchors
                addButtonsToNavbar(addSpacerView: true)
            }
            navBarStack.addArrangedSubview(stackView)
            navBarStack.addArrangedSubview(UIView())
            navBarStack.addArrangedSubview(focusbandButtonsStack)
            // FocusbandButtons.shared.setButtonsInStack(stack: focusbandButtonsStack)
            // FocusbandButtons.shared.focusBandNavigationDelegate = FocusBandViewController.shared
            
        }// else
    }
    
    private func addButtonsToNavbar(addSpacerView: Bool) {
        focusbandButtonsStack.axis = .horizontal
        focusbandButtonsStack.spacing = DesignMetrics.Padding.size8
        
        let checkBoxView = UIView()
        checkBoxView.backgroundColor = .clear//black
        checkBoxView.widthAnchor == 24
        
        let imageActionButtonView = UIView()
        imageActionButtonView.backgroundColor = .clear//gray
        imageActionButtonView.widthAnchor == 24
        
        imageActionButton.widthAnchor == 24
        imageActionButton.heightAnchor == 24
        imageActionButton.setImage(UIImage(named: "verticalDots"), for: .normal)
        if #available(iOS 14.0, *) {
            imageActionButton.addAction(UIAction(handler: { [weak self] _ in
                self?.imageButtonAction()
            }), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            checkBoxButton.addAction(UIAction(handler: { [weak self] _ in
                self?.checkboxButtonAction()
            }), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
        checkBoxButton.widthAnchor == 24
        checkBoxButton.heightAnchor == 24
        checkBoxButton.setImage(UIImage(named: "navBarUnchecked"), for: .normal)
        
        focusbandButtonsStack.addArrangedSubview(checkBoxView)
        focusbandButtonsStack.addArrangedSubview(imageActionButtonView)
        if(addSpacerView) {
            let spacerView = UIView()
            spacerView.backgroundColor = .clear
            spacerView.widthAnchor == 16
            focusbandButtonsStack.addArrangedSubview(spacerView)
        }
        checkBoxView.addSubview(checkBoxButton)
        imageActionButtonView.addSubview(imageActionButton)
        
        checkBoxButton.centerAnchors == checkBoxView.centerAnchors
        imageActionButton.centerAnchors == imageActionButtonView.centerAnchors
    }
    
    
    private func setupNavBarNew(title: String, showBackButton: Bool, hideBackground: Bool) {
        navBarContainer.heightAnchor == DesignMetrics.Dimensions.height60
        if hideBackground {
            navBarContainer.backgroundColor = .clear
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = DesignMetrics.Padding.size0
        
        let profileView = UIView()
        profileView.backgroundColor = .clear
        
        let profileStackView = UIStackView()
        profileStackView.axis = .horizontal
        profileStackView.spacing = DesignMetrics.Padding.size0
        
        let profilePicView = UIView()
        profilePicView.backgroundColor = .white
        profilePicView.widthAnchor == 60
        profilePicView.heightAnchor == DesignMetrics.Dimensions.height60
        profilePicView.layer.cornerRadius = 30
        
        let userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = UIImage(named: "emoji1")
        
        let onlineView = UIView()
        onlineView.backgroundColor = .green
        onlineView.widthAnchor == 10
        onlineView.heightAnchor == 10
        onlineView.layer.cornerRadius = 5
        
        profilePicView.addSubview(userImageView)
        profilePicView.addSubview(onlineView)
        onlineView.topAnchor == profilePicView.topAnchor
        onlineView.trailingAnchor == profilePicView.trailingAnchor - 12
        userImageView.edgeAnchors == profilePicView.edgeAnchors + 8
        
        let userInfoView = UIView()
        userInfoView.backgroundColor = .clear
        userInfoView.heightAnchor == DesignMetrics.Dimensions.height60
        
        let userInfoStackView = UIStackView()
        userInfoStackView.axis = .vertical
        userInfoStackView.spacing = DesignMetrics.Padding.size0
        
        let nameLabel = UILabel()
        nameLabel.text = "Nataliya Smith"
        nameLabel.textColor =  UIColor(named: "appPrimaryTextColor")
        nameLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 18)
        
        let emailLabel = UILabel()
        emailLabel.text = "Younasmughal122@gmail.com"
        emailLabel.textColor =  UIColor(named: "appPrimaryTextColor")
        emailLabel.font = FontManagerDatabox.shared.cloudVaultSemiLightText(ofSize: 10)
        emailLabel.numberOfLines = 0
        
        userInfoStackView.addArrangedSubview(nameLabel)
        userInfoStackView.addArrangedSubview(emailLabel)
        
        userInfoView.addSubview(userInfoStackView)
        userInfoStackView.edgeAnchors == userInfoView.edgeAnchors + 8
        
        profileStackView.addArrangedSubview(profilePicView)
        profileStackView.addArrangedSubview(userInfoView)
        
        profileView.addSubview(profileStackView)
        profileStackView.heightAnchor == DesignMetrics.Dimensions.height60
        profileStackView.leadingAnchor == profileView.leadingAnchor + 8
        profileStackView.trailingAnchor == profileView.trailingAnchor - 8
        profileStackView.topAnchor == profileView.topAnchor + 4
        
        let navigationButtonsView = UIView()
        navigationButtonsView.backgroundColor = .clear
        navigationButtonsView.widthAnchor == 150
        
        stackView.addArrangedSubview(profileView)
        stackView.addArrangedSubview(navigationButtonsView)
        
        let navigationButtonsStackView = UIStackView()
        navigationButtonsStackView.axis = .horizontal
        navigationButtonsStackView.distribution = .equalSpacing
        
        let getProView = UIView()
        getProView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        getProView.widthAnchor == 42
        getProView.heightAnchor == 42
        getProView.layer.cornerRadius = 21
        // Add tap gesture recognizer to the view for getPro
        let tapGestureGetProView = UITapGestureRecognizer(target: self, action: #selector(handleGetProTapped))
        getProView.addGestureRecognizer(tapGestureGetProView)
        
        let animationView = LottieAnimationView(name: "proIcon")
        // Set up the animation properties
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop  // You can change this to .playOnce if you don't want a loop
        animationView.play()
    
        
        let searchView = UIView()
        searchView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        searchView.widthAnchor == 42
        searchView.heightAnchor == 42
        searchView.layer.cornerRadius = 21
        
        let hamburgerView = UIView()
        hamburgerView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        hamburgerView.widthAnchor == 42
        hamburgerView.heightAnchor == 42
        hamburgerView.layer.cornerRadius = 21
        
        // Add tap gesture recognizer to the view for hamburger
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHamBurgerTapped))
        hamburgerView.addGestureRecognizer(tapGesture)
        
        let getProImageView = UIImageView()
        getProImageView.contentMode = .scaleAspectFit
        getProImageView.image = UIImage(named: "getProIcon")
        
        let searchImageView = UIImageView()
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate)
        searchImageView.tintColor = UIColor(named: "appPrimaryTextColor")
        
        let hamburgerImageView = UIImageView()
        hamburgerImageView.contentMode = .scaleAspectFit
        hamburgerImageView.image = UIImage(named: "hamburgerIcon")?.withRenderingMode(.alwaysTemplate)
        hamburgerImageView.tintColor = UIColor(named: "appPrimaryTextColor")
        
        getProView.addSubview(animationView)
        searchView.addSubview(searchImageView)
        hamburgerView.addSubview(hamburgerImageView)
        
        animationView.edgeAnchors == getProView.edgeAnchors
        searchImageView.edgeAnchors == searchView.edgeAnchors
        hamburgerImageView.edgeAnchors == hamburgerView.edgeAnchors + 8
        
        navigationButtonsStackView.addArrangedSubview(getProView)
        navigationButtonsStackView.addArrangedSubview(searchView)
        navigationButtonsStackView.addArrangedSubview(hamburgerView)
        
        navigationButtonsView.addSubview(navigationButtonsStackView)
        navigationButtonsStackView.heightAnchor == 42
        navigationButtonsStackView.leadingAnchor == navigationButtonsView.leadingAnchor + 4
        navigationButtonsStackView.trailingAnchor == navigationButtonsView.trailingAnchor - 4
        navigationButtonsStackView.centerYAnchor == navigationButtonsView.centerYAnchor
        
        navBarContainer.addSubview(stackView)
        stackView.edgeAnchors == navBarContainer.edgeAnchors
    }

    /// If you think this is the last view you are appending please call appendEmptyViewToBottom().
    func appendViewToMainVStack(view: UIView,
                                topPadding: CGFloat? = nil,
                                leftPadding: CGFloat? = nil,
                                bottomPadding: CGFloat? = nil,
                                rightPadding: CGFloat? = nil) {
        let stackForPaddings = UIStackView()
        stackForPaddings.axis = .vertical
        
        if let topPadding {
            stackForPaddings.addArrangedSubview(getVerticalPadding(padding: topPadding))
        }
        
        let contentContainerStack = UIStackView()
        contentContainerStack.axis = .horizontal
        
        if let leftPadding {
            contentContainerStack.addArrangedSubview(getHorizontalPadding(padding: leftPadding))
        }
        
        contentContainerStack.addArrangedSubview(view)
        
        if let rightPadding {
            contentContainerStack.addArrangedSubview(getHorizontalPadding(padding: rightPadding))
        }
        
        stackForPaddings.addArrangedSubview(contentContainerStack)
        
        if let bottomPadding {
            stackForPaddings.addArrangedSubview(getVerticalPadding(padding: bottomPadding))
        }
        
        mainContentStack.addArrangedSubview(stackForPaddings)
        
        func getVerticalPadding(padding: CGFloat) -> UIView {
            let paddingView = UIView()
            paddingView.heightAnchor == padding
            return paddingView
        }
        
        func getHorizontalPadding(padding: CGFloat) -> UIView {
            let paddingView = UIView()
            paddingView.widthAnchor == padding
            return paddingView
        }
    }
    
    func appendEmptyViewToBottom() {
        mainContentStack.addArrangedSubview(UIView())
    }
    
    func showProgress() {
        DispatchQueue.main.async {
            // Show loading indicator
            SVProgressHUD.show()
            // SVProgressHUD.showProgress(0.5) // 50% progress
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setForegroundColor(UIColor(named: "appPrimaryTextColor") ?? .white)
            SVProgressHUD.setBackgroundColor(UIColor(named: "appBackgroundViewColor") ?? .gray)
            SVProgressHUD.setRingThickness(2)
        }
        
    }
    
    func showProgressForLogout() {
        DispatchQueue.main.async {
            // Show loading indicator
            SVProgressHUD.show()
            // SVProgressHUD.showProgress(0.5) // 50% progress
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setForegroundColor(UIColor(named: "appPrimaryTextColor") ?? .white)
            SVProgressHUD.setBackgroundColor(UIColor(named: "appBackgroundViewColor") ?? .gray)
            SVProgressHUD.show(withStatus: "Logout...")
            SVProgressHUD.setRingThickness(2)
        }
        
    }
    
    
    func hideProgress() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        
        
    }
    
    func addFooterView(footerView: UIView, height: CGFloat?) {
        self.footerView.addSubview(footerView)
        footerView.horizontalAnchors == self.footerView.horizontalAnchors - 16
        footerView.topAnchor == self.footerView.topAnchor
        footerView.bottomAnchor == self.footerView.bottomAnchor - 16
        if let height {
            footerView.heightAnchor == height
        } else {
            self.footerView.heightAnchor == footerView.bounds.height
        }
    }
    
    func removeFooterView(footerView: UIView) {
        footerView.removeFromSuperview()
        self.footerView.heightAnchor == 0
    }
    
    func showHideFooterView(isShowFooterView: Bool) {
        if(isShowFooterView) {
            self.footerView.isHidden = !isShowFooterView
        }
        else {
            self.footerView.isHidden = !isShowFooterView
        }
    }
    
    func updateTitle(title: String) {
        titleLabel.text = title
    }
    
    func updateUI() {
        //Updates on basic functionality
    }
    
    func checkboxButtonAction() {
        // Update in child controller
    }
    
    func imageButtonAction() {
        // Update in child controller
    }
    
    // Action function that gets called when the view is tapped
        @objc func handleGetProTapped() {
            print("GetPro was tapped!")
            // Perform any action you want when the view is tapped
        }
    
    // Action function that gets called when the view is tapped
        @objc func handleHamBurgerTapped() {
            print("Hamburger was tapped!")
            // Perform any action you want when the view is tapped
        }
    
    /// backButtonAction: Basically pops the ViewController
    /// For button created in child controller only
    func backButtonAction() {
        navigationController?.popViewController(animated: true)
        
        
    }
    
    /// backButtonAction: Basically dismisses the ViewController
    func crossButtonActionToDismiss() {
        dismiss(animated: true)
    }
    
    func hideFocusbandOptionFromNavBar() {
        focusbandButtonsStack.isHidden = true
    }
    
    func showFocusbandOptionFromNavBar() {
        focusbandButtonsStack.isHidden = false
    }
    
    func showCheckBoxInNavigation() {
        checkBoxButton.isHidden = false
    }
    
    func showCheckBoxChecked() {
        checkBoxButton.setImage(UIImage(named: "navBarChecked"), for: .normal)
    }
    
    func showCheckBoxUnChecked() {
        checkBoxButton.setImage(UIImage(named: "navBarUnchecked"), for: .normal)
    }
    
    func hideCheckBoxInNavigation() {
        checkBoxButton.isHidden = true
    }
    
    func changeTitle(titleOfNavigation: String) {
        self.titleLabel.text = titleOfNavigation
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allow gestures to begin when there is more than one view controller in the navigation stack
            return self.navigationController?.viewControllers.count ?? 0 >= 1
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Allow pinch and long press gestures to be recognized simultaneously
            if (gestureRecognizer is UILongPressGestureRecognizer && otherGestureRecognizer is UIPinchGestureRecognizer) ||
                (gestureRecognizer is UIPinchGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer) {
                return true
            }
            
            // Allow simultaneous recognition for other gestures as well, if needed
            return true
        }

//        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//            // Ensure pinch gesture takes precedence over long press if both are triggered
//            if gestureRecognizer is UIPinchGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
//                return true // Pinch should not fail because of long press
//            }
//            
//            return false
//        }
}



