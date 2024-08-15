//
//  SettingsViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/07/2024.
//

import UIKit
import Anchorage

class SettingsViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "    Settings", showBackButton: false, hideBackground: true)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        setupStorageView()
        setupSystemSettingView()
        setupPrivacyAndTermsView()
        setupFeedbackView()
        setupContactUsView()
    }
    
    private func setupStorageView() {
        let storageView = UIView()
        storageView.backgroundColor = .white
        storageView.layer.cornerRadius = DesignMetrics.Padding.size8
        storageView.heightAnchor == DesignMetrics.Dimensions.height135
        
        let storageStackView = UIStackView()
        storageStackView.axis = .vertical
        storageStackView.spacing = 16
        
        let storageSizeInfoView = UIView()
        storageSizeInfoView.backgroundColor = .clear
        storageSizeInfoView.heightAnchor == 20
        
        let storageSizeInfoStackView = UIStackView()
        storageSizeInfoStackView.axis = .horizontal
        storageSizeInfoStackView.distribution = .fillEqually
        
        let storageSizeLabel = UILabel()
        storageSizeLabel.textAlignment = .left
        storageSizeLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        storageSizeLabel.font = UIFont.cloudVaultBoldText(ofSize: 16)
        storageSizeLabel.text = "32.8GB of 64.0GB"
        
        let dataBoxStorageLabel = UILabel()
        dataBoxStorageLabel.textAlignment = .right
        dataBoxStorageLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        dataBoxStorageLabel.font = UIFont.cloudVaultSemiBoldText(ofSize: 12)
        dataBoxStorageLabel.text = "Databox Storage"
        
        storageSizeInfoStackView.addArrangedSubview(storageSizeLabel)
        storageSizeInfoStackView.addArrangedSubview(dataBoxStorageLabel)
        
        storageSizeInfoView.addSubview(storageSizeInfoStackView)
        storageSizeInfoStackView.verticalAnchors == storageSizeInfoView.verticalAnchors
        storageSizeInfoStackView.horizontalAnchors == storageSizeInfoView.horizontalAnchors + 12
        
        let storageGraphContainerView = UIView()
        storageGraphContainerView.backgroundColor = .clear
        storageGraphContainerView.heightAnchor == 18
        
        let storageGraphView = StorageUsageView(images: 20, videos: 6, documents: 0, audio: 12, files: 14, contacts: 8, free: 40)
        storageGraphContainerView.addSubview(storageGraphView)
        storageGraphView.verticalAnchors == storageGraphContainerView.verticalAnchors
        storageGraphView.horizontalAnchors == storageGraphContainerView.horizontalAnchors + 12
        
        let manageStorageView = CustomRoundedView()
        manageStorageView.backgroundColor = .black
        manageStorageView.configureRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: DesignMetrics.Padding.size8)
        
        let manageStorageBtn = UIButton()
        manageStorageBtn.setFont(UIFont.cloudVaultBoldText(ofSize: 14), for: .normal)
        manageStorageBtn.setTitleColor(.white, for: .normal)
        manageStorageBtn.setTitle("Manage Storage", for: .normal)
        manageStorageBtn.backgroundColor = .clear
        manageStorageBtn.addTarget(self, action: #selector(manageStorageBtnTapped(_:)), for: .touchUpInside)
        manageStorageView.addSubview(manageStorageBtn)
        manageStorageBtn.edgeAnchors == manageStorageView.edgeAnchors
        
        storageStackView.addArrangedSubview(storageSizeInfoView)
        storageStackView.addArrangedSubview(storageGraphContainerView)
        storageStackView.addArrangedSubview(manageStorageView)
        storageView.addSubview(storageStackView)
        storageStackView.topAnchor == storageView.topAnchor + 8
        storageStackView.horizontalAnchors == storageView.horizontalAnchors
        storageStackView.bottomAnchor == storageView.bottomAnchor
        appendViewToMainVStack(view: storageView, topPadding: 24)
        
    }
    
    @objc private func manageStorageBtnTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("manageStorageBtn Tapped")
        //        let emojiVC = EmojiViewController(allEmojiArray: personalityAllImagesArray)
        //        emojiVC.emojiSelectionDelegate = self
        //        self.navigationController?.pushViewController(emojiVC, animated: true)
    }
    
    @objc private func privacyPolicyBtnTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("privacyPolicyBtn Tapped")
    }
    
    @objc private func termsAndConditionBtnTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("termsAndConditionBtn Tapped")
    }
    
    
    private func setupSystemSettingView() {
        let systemSettingContainerView = UIView()
        systemSettingContainerView.backgroundColor = .white
        systemSettingContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        systemSettingContainerView.heightAnchor == DesignMetrics.Dimensions.height372
        
        let systemSettingStackView = UIStackView()
        systemSettingStackView.axis = .vertical
        systemSettingStackView.spacing = 20
        
        let settingTitleView = UIView()
        settingTitleView.heightAnchor == DesignMetrics.Dimensions.height20
        
        let settingTitleLabel = UILabel()
        settingTitleLabel.textAlignment = .left
        settingTitleLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        settingTitleLabel.font = UIFont.cloudVaultBoldText(ofSize: 16)
        settingTitleLabel.text = "System settings"
        
        settingTitleView.addSubview(settingTitleLabel)
        settingTitleLabel.verticalAnchors == settingTitleView.verticalAnchors
        settingTitleLabel.horizontalAnchors == settingTitleView.horizontalAnchors + 12
        
        let settingSeparateView = UIView()
        settingSeparateView.heightAnchor == 1
        settingSeparateView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1)
        
        let autoBackUpView = UIView()
        autoBackUpView.heightAnchor == 42
        
        
        let autoBackUpContentView = SystemSettingView()
        autoBackUpContentView.leftImageView.image = UIImage(named: "autoBackUpIcon")
        autoBackUpContentView.titleLabel.text = "Auto Backup"
        autoBackUpContentView.rightImageView.image = UIImage(named: "forwardArrow")
        
        autoBackUpView.addSubview(autoBackUpContentView)
        autoBackUpContentView.verticalAnchors == autoBackUpView.verticalAnchors + 4
        autoBackUpContentView.horizontalAnchors == autoBackUpView.horizontalAnchors + 12
        
        let notificationView = UIView()
        notificationView.heightAnchor == 42
        
        let notificationContentView = SystemSettingView()
        notificationContentView.leftImageView.image = UIImage(named: "notificationIcon")
        notificationContentView.titleLabel.text = "Notification"
        notificationContentView.rightImageView.image = UIImage(named: "forwardArrow")
        
        notificationView.addSubview(notificationContentView)
        notificationContentView.verticalAnchors == notificationView.verticalAnchors + 4
        notificationContentView.horizontalAnchors == notificationView.horizontalAnchors + 12
        
        let themeView = UIView()
        themeView.heightAnchor == 42
        
        let themeContentView = SystemSettingView()
        themeContentView.leftImageView.image = UIImage(named: "themeIcon")
        themeContentView.titleLabel.text = "Theme"
        themeContentView.rightImageView.image = UIImage(named: "forwardArrow")
        
        themeView.addSubview(themeContentView)
        themeContentView.verticalAnchors == themeView.verticalAnchors + 4
        themeContentView.horizontalAnchors == themeView.horizontalAnchors + 12
        
        let clearCacheView = UIView()
        clearCacheView.heightAnchor == 42
        
        
        let clearCacheContentView = SystemSettingView()
        clearCacheContentView.leftImageView.image = UIImage(named: "clearCacheIcon")
        clearCacheContentView.titleLabel.text = "Clear Cache"
        clearCacheContentView.rightImageView.image = UIImage(named: "forwardArrow")
        
        clearCacheView.addSubview(clearCacheContentView)
        clearCacheContentView.verticalAnchors == clearCacheView.verticalAnchors + 4
        clearCacheContentView.horizontalAnchors == clearCacheView.horizontalAnchors + 12
        
        let cacheSizeView = UIView()
        cacheSizeView.heightAnchor == 42
        
        let cacheSizeContentView = SystemSettingView()
        cacheSizeContentView.leftImageView.image = UIImage(named: "cacheSizeIcon")
        cacheSizeContentView.titleLabel.text = "Cache Size"
        cacheSizeContentView.rightImageView.image = UIImage(named: "forwardArrow")
        
        cacheSizeView.addSubview(cacheSizeContentView)
        cacheSizeContentView.verticalAnchors == cacheSizeView.verticalAnchors + 4
        cacheSizeContentView.horizontalAnchors == cacheSizeView.horizontalAnchors + 12
        
        // Adding tap gesture recognizers
        addTapGesture(to: notificationContentView, tag: 1)
        addTapGesture(to: autoBackUpContentView, tag: 2)
        addTapGesture(to: themeContentView, tag: 3)
        addTapGesture(to: clearCacheContentView, tag: 4)
        addTapGesture(to: cacheSizeContentView, tag: 5)
        
        systemSettingStackView.addArrangedSubview(settingTitleView)
        systemSettingStackView.addArrangedSubview(settingSeparateView)
        systemSettingStackView.addArrangedSubview(autoBackUpView)
        systemSettingStackView.addArrangedSubview(notificationView)
        systemSettingStackView.addArrangedSubview(themeView)
        systemSettingStackView.addArrangedSubview(clearCacheView)
        systemSettingStackView.addArrangedSubview(cacheSizeView)
        
        systemSettingContainerView.addSubview(systemSettingStackView)
        systemSettingStackView.verticalAnchors == systemSettingContainerView.verticalAnchors + 12
        systemSettingStackView.horizontalAnchors == systemSettingContainerView.horizontalAnchors
        appendViewToMainVStack(view: systemSettingContainerView, topPadding: 24)
    }
    
    private func setupPrivacyAndTermsView() {
        let privacyAndtermsContainerView = UIView()
        privacyAndtermsContainerView.backgroundColor = .white
        privacyAndtermsContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        privacyAndtermsContainerView.heightAnchor == DesignMetrics.Dimensions.height197
        
        let privacyAndtermsStackView = UIStackView()
        privacyAndtermsStackView.axis = .vertical
        privacyAndtermsStackView.spacing = 20
        
        let privacyAndTermsTitleView = UIView()
        privacyAndTermsTitleView.heightAnchor == DesignMetrics.Dimensions.height20
        
        let privacyAndTermsLabel = UILabel()
        privacyAndTermsLabel.textAlignment = .left
        privacyAndTermsLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        privacyAndTermsLabel.font = UIFont.cloudVaultBoldText(ofSize: 16)
        privacyAndTermsLabel.text = "Privacy & Terms"
        
        privacyAndTermsTitleView.addSubview(privacyAndTermsLabel)
        privacyAndTermsLabel.verticalAnchors == privacyAndTermsTitleView.verticalAnchors
        privacyAndTermsLabel.horizontalAnchors == privacyAndTermsTitleView.horizontalAnchors + 12
        
        let privacyAndTermsSeparateView = UIView()
        privacyAndTermsSeparateView.heightAnchor == 1
        privacyAndTermsSeparateView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1)
        
        let privacyPolicyView = UIView()
        privacyPolicyView.heightAnchor == 42
        
        let privacyPolicyContentView = PrivacyAndTermsView()
        privacyPolicyContentView.leftImageView.image = UIImage(named: "privacyPolicyIcon")
        privacyPolicyContentView.titleLabel.text = "Privacy Policy"
        privacyPolicyContentView.rightButton.setTitle("Read", for: .normal)
        privacyPolicyContentView.rightButton.addTarget(self, action: #selector(privacyPolicyBtnTapped(_:)), for: .touchUpInside)
        
        privacyPolicyView.addSubview(privacyPolicyContentView)
        privacyPolicyContentView.verticalAnchors == privacyPolicyView.verticalAnchors + 4
        privacyPolicyContentView.horizontalAnchors == privacyPolicyView.horizontalAnchors + 12
        
        let termsAndConditionsView = UIView()
        termsAndConditionsView.heightAnchor == 42
        
        let termsAndConditionsContentView = PrivacyAndTermsView()
        termsAndConditionsContentView.leftImageView.image = UIImage(named: "termsAndConditionIcon")
        termsAndConditionsContentView.titleLabel.text = "Terms And Conditions"
        termsAndConditionsContentView.rightButton.setTitle("Read", for: .normal)
        termsAndConditionsContentView.rightButton.addTarget(self, action: #selector(termsAndConditionBtnTapped(_:)), for: .touchUpInside)
        
        termsAndConditionsView.addSubview(termsAndConditionsContentView)
        termsAndConditionsContentView.verticalAnchors == termsAndConditionsView.verticalAnchors + 4
        termsAndConditionsContentView.horizontalAnchors == termsAndConditionsView.horizontalAnchors + 12
        
        privacyAndtermsStackView.addArrangedSubview(privacyAndTermsTitleView)
        privacyAndtermsStackView.addArrangedSubview(privacyAndTermsSeparateView)
        privacyAndtermsStackView.addArrangedSubview(privacyPolicyView)
        privacyAndtermsStackView.addArrangedSubview(termsAndConditionsView)
        
        privacyAndtermsContainerView.addSubview(privacyAndtermsStackView)
        privacyAndtermsStackView.verticalAnchors == privacyAndtermsContainerView.verticalAnchors + 12
        privacyAndtermsStackView.horizontalAnchors == privacyAndtermsContainerView.horizontalAnchors
        appendViewToMainVStack(view: privacyAndtermsContainerView, topPadding: 24)
    }
    
    private func setupFeedbackView() {
        let feedBackMainView = UIView()
        feedBackMainView.backgroundColor = .white
        
        feedBackMainView.layer.cornerRadius = DesignMetrics.Padding.size8
        feedBackMainView.heightAnchor == DesignMetrics.Dimensions.height78
        
        let feedbackContainerView = FeedbackAndContactView()
        feedbackContainerView.backgroundColor = .clear
        feedbackContainerView.leftImageView.image = UIImage(named: "feedbackIcon")
        feedbackContainerView.titleLabel.text = "Give Feedback"
        feedbackContainerView.subtitleLabel.text = "Your precision feedback would help us to make this product best for you"
        feedBackMainView.addSubview(feedbackContainerView)
        feedbackContainerView.verticalAnchors == feedBackMainView.verticalAnchors
        feedbackContainerView.horizontalAnchors == feedBackMainView.horizontalAnchors + 12
        appendViewToMainVStack(view: feedBackMainView, topPadding: 24)
    }
    
    private func setupContactUsView() {
        let contactUsMainView = UIView()
        contactUsMainView.backgroundColor = .white
        contactUsMainView.layer.cornerRadius = DesignMetrics.Padding.size8
        contactUsMainView.heightAnchor == DesignMetrics.Dimensions.height78
        
        let contactUsContainerView = FeedbackAndContactView()
        contactUsContainerView.backgroundColor = .clear
        contactUsContainerView.leftImageView.image = UIImage(named: "contactUsIcon")
        contactUsContainerView.titleLabel.text = "Contact Us"
        contactUsContainerView.subtitleLabel.text = "If you have any problem contact us we are here for you 24/7"
        
        contactUsMainView.addSubview(contactUsContainerView)
        contactUsContainerView.verticalAnchors == contactUsMainView.verticalAnchors
        contactUsContainerView.horizontalAnchors == contactUsMainView.horizontalAnchors + 12
        appendViewToMainVStack(view: contactUsMainView, topPadding: 24)
    }
    
    
    
    private func addTapGesture(to view: UIView, tag: Int) {
        view.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 1:
            handleNotificationContentTap()
        case 2:
            handleAutoBackUpContentTap()
        case 3:
            handleThemeContentTap()
        case 4:
            handleClearCacheContentTap()
        case 5:
            handleCacheSizeContentTap()
        default:
            break
        }
    }
    
    private func handleNotificationContentTap() {
        // Handle notification content tap
        print("Notification Tapped")
    }
    
    private func handleAutoBackUpContentTap() {
        // Handle auto backup content tap
        print("AutoBackup Tapped")
    }
    
    private func handleThemeContentTap() {
        // Handle theme content tap
        print("Theme Tapped")
    }
    
    private func handleClearCacheContentTap() {
        // Handle clear cache content tap
        print("Clear Cache Tapped")
    }
    
    private func handleCacheSizeContentTap() {
        // Handle cache size content tap
        print("Cache Size Tapped")
    }
    
}
