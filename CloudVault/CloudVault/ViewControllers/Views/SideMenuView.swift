//
//  SideMenuView.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/08/2024.
//

import UIKit
import Anchorage

class SideMenuView: UIView {
    
    let profileImageView = UIImageView()
    let userNameLabel = UILabel()
    let emailLabel = UILabel()
    let imagesGraphView = StorageHorizontalUsageView(filledPercentage: 54, graphViewColor: #colorLiteral(red: 0.3098039216, green: 0.3529411765, blue: 0.4196078431, alpha: 0.2471035289), filledColor: UIColor(named: "appPrimaryTextColor") ?? .blue)
    let storageInfoLabel = UILabel()
    private let separatorView = UIView()
    let proButtonView = UIView()
    var menuItems = [UIView]()
    var mainStack = UIStackView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    init(menuTitles: [String], menuIcons: [UIImage]) {
        super.init(frame: .zero)
        setupViews(menuTitles: menuTitles, menuIcons: menuIcons)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(menuTitles: [], menuIcons: [])
        setupConstraints()
    }
    
    private func setupViews(menuTitles: [String], menuIcons: [UIImage]) {
        // Profile Image
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 42
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .clear // Placeholder
        profileImageView.image = UIImage(named: "profilePic")
        
        // Labels
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userNameLabel.textColor = UIColor(named: "appPrimaryTextColor")
        
        emailLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        emailLabel.textColor = UIColor(named: "onBoardingSubTextColor")
        
        storageInfoLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        storageInfoLabel.textColor = UIColor(named: "onBoardingSubTextColor")
        
        // Separator
        separatorView.backgroundColor = UIColor(named: "appDeselectedTabbarColor")
        
        // Action Button
        proButtonView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        proButtonView.layer.cornerRadius = 8
        
        let proButtonHStackContainer = UIStackView()
        proButtonHStackContainer.axis = .horizontal
        proButtonHStackContainer.spacing = 8
       
        
        let proImageView = UIImageView()
        proImageView.contentMode = .scaleAspectFit
        proImageView.image = UIImage(named: "sidebarProIcon")
        proImageView.widthAnchor == 30
        
        let proTitleLabel = UILabel()
        proTitleLabel.textColor = .white
        proTitleLabel.text = "Get More Storage"
        proTitleLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 12)
        
        let proArrowView = UIView()
        proArrowView.widthAnchor == 20
        
        let proArrowImageView = UIImageView()
        proArrowImageView.contentMode = .scaleAspectFit
        proArrowImageView.image = UIImage(named: "arrowWhite")
        proArrowImageView.heightAnchor == 16
        proArrowImageView.widthAnchor == 16
        
        proArrowView.addSubview(proArrowImageView)
        
        proArrowImageView.centerAnchors == proArrowView.centerAnchors
        
        proButtonHStackContainer.addArrangedSubview(proImageView)
        proButtonHStackContainer.addArrangedSubview(proTitleLabel)
        proButtonHStackContainer.addArrangedSubview(proArrowView)
        
        proButtonView.addSubview(proButtonHStackContainer)
        proButtonHStackContainer.leadingAnchor == proButtonView.leadingAnchor + 8
        proButtonHStackContainer.trailingAnchor == proButtonView.trailingAnchor - 8
        proButtonHStackContainer.heightAnchor == 30
        proButtonHStackContainer.centerYAnchor == proButtonView.centerYAnchor
        proButtonHStackContainer.backgroundColor = .clear
        
        // Menu Items
        for (index, title) in menuTitles.enumerated() {
            let menuItemView = createMenuItem(title: title, icon: menuIcons[index])
            menuItems.append(menuItemView)
        }
        
        // Menu Items
        for (index, title) in menuTitles.enumerated() {
            let menuItemView = createMenuItem(title: title, icon: menuIcons[index])
            menuItems.append(menuItemView)
        }
        
        // Spacer view to fill remaining space
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        
        // Adding to the content view
        mainStack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel, emailLabel, imagesGraphView, storageInfoLabel, separatorView, proButtonView] + menuItems )
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        contentView.addSubview(mainStack)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        
        // Ensure the scrollView and contentView expand properly
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.edgeAnchors == self.edgeAnchors
        
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor
        
        // Align mainStack with padding
        mainStack.edgeAnchors == contentView.edgeAnchors
        mainStack.leadingAnchor == contentView.leadingAnchor + 16
        mainStack.trailingAnchor == contentView.trailingAnchor - 16
        
        // Constraints for profileImageView
        profileImageView.sizeAnchors == CGSize(width: 84, height: 84)
        profileImageView.topAnchor == contentView.topAnchor + 40 // Space from top
        
        // Constraints for userNameLabel
        userNameLabel.leadingAnchor == contentView.leadingAnchor + 16
        userNameLabel.topAnchor == profileImageView.bottomAnchor + 16
        
        // Constraints for emailLabel
        emailLabel.leadingAnchor == contentView.leadingAnchor + 16
        emailLabel.topAnchor == userNameLabel.bottomAnchor + 16
        
        // Constraints for imagesGraphView
        imagesGraphView.heightAnchor == 4
        
        // Constraints for separatorView
        separatorView.heightAnchor == 2
        
        // Constraints for actionButton
        proButtonView.sizeAnchors == CGSize(width: 178, height: 46)
        
        // Constraints for menuItems
        menuItems.forEach { menuItem in
            menuItem.heightAnchor == 46
            menuItem.widthAnchor == proButtonView.widthAnchor
        }
        
        // Set constraints for contentView's height to match mainStack's height
        contentView.topAnchor == scrollView.topAnchor
        contentView.bottomAnchor == scrollView.bottomAnchor
        mainStack.topAnchor == contentView.topAnchor
        mainStack.bottomAnchor == contentView.bottomAnchor
        contentView.heightAnchor == mainStack.heightAnchor
    }
    
    private func createMenuItem(title: String, icon: UIImage) -> UIView {
        let iconView = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        iconView.tintColor = UIColor(named: "appPrimaryTextColor")
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = UIColor(named: "appPrimaryTextColor")
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let menuItemStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        menuItemStack.axis = .horizontal
        menuItemStack.spacing = 20
        menuItemStack.alignment = .center

        let menuItemView = UIView()
        menuItemView.addSubview(menuItemStack)

        // Aligning the icon and label with consistent leading space
        iconView.leadingAnchor == menuItemView.leadingAnchor
        iconView.widthAnchor == 40
        titleLabel.leadingAnchor == iconView.trailingAnchor + 28
        titleLabel.trailingAnchor <= menuItemView.trailingAnchor - 16
        menuItemStack.edgeAnchors == menuItemView.edgeAnchors
        
        return menuItemView
    }
}



