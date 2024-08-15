//
//  OutOfStorageCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 22/07/2024.
//

import UIKit
import Anchorage

class OutOfStorageCollectionViewCell: UICollectionViewCell {
    private let storageBoxContainerView: UIView = {
        let containerView = UIView()
        containerView.layer.borderWidth = 1 // Adjust the border width
        containerView.layer.cornerRadius = 8 // Adjust the corner radius
        return containerView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.text = "Running Out of Storage"
        titleLabel.font = UIFont.cloudVaultBoldText(ofSize: 16)
        return titleLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Experience seamless navigation and top-notch services on our website"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.cloudVaultRegularText(ofSize: 12)
        return descriptionLabel
    }()
    private let storageImageView: UIImageView = {
        let storageImageView = UIImageView()
        storageImageView.contentMode = .scaleAspectFit
        return storageImageView
    }()
    private let storageCrossImageView: UIImageView = {
        let storageCrossImageView = UIImageView()
        storageCrossImageView.contentMode = .scaleAspectFit
        return storageCrossImageView
    }()
    var storageImageName: String = "" {
        didSet {
            storageImageView.image = UIImage(named: storageImageName)
        }
    }
    var storageCrossImageName: String = "" {
        didSet {
            storageCrossImageView.image = UIImage(named: storageCrossImageName)
        }
    }
    var storageBackgroundColor: UIColor = #colorLiteral(red: 0.8901960784, green: 0.1176470588, blue: 0.1411764706, alpha: 1) {
        didSet {
            titleLabel.textColor = storageBackgroundColor
            descriptionLabel.textColor = storageBackgroundColor.withAlphaComponent(0.59)
            storageBoxContainerView.backgroundColor = storageBackgroundColor.withAlphaComponent(0.22)
            storageBoxContainerView.layer.borderColor = storageBackgroundColor.withAlphaComponent(0.15).cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContainerView() {
        addSubview(storageBoxContainerView)
        storageBoxContainerView.edgeAnchors == edgeAnchors
        
        let storageBoxContainerStackView = UIStackView()
        storageBoxContainerStackView.backgroundColor = .clear
        storageBoxContainerStackView.axis = .horizontal
        storageBoxContainerStackView.spacing = DesignMetrics.Padding.size16
        
        let storageViewForImage = UIView()
        storageViewForImage.backgroundColor = .clear//.black
        storageViewForImage.widthAnchor == 60
        storageViewForImage.heightAnchor == 60
        
        storageViewForImage.addSubview(storageImageView)
        storageImageView.widthAnchor == 44
        storageImageView.heightAnchor == 44
        storageImageView.centerAnchors == storageViewForImage.centerAnchors
        
        let storageTitleAndDescriptionView = UIView()
        storageTitleAndDescriptionView.backgroundColor = .clear//.green
        
        let storageTitleAndDescriptionStackView = UIStackView()
        storageTitleAndDescriptionStackView.axis = .vertical
        storageTitleAndDescriptionStackView.spacing = DesignMetrics.Padding.size0
        
        storageTitleAndDescriptionStackView.addArrangedSubview(titleLabel)
        storageTitleAndDescriptionStackView.addArrangedSubview(descriptionLabel)
        storageTitleAndDescriptionView.addSubview(storageTitleAndDescriptionStackView)
        storageTitleAndDescriptionStackView.edgeAnchors == storageTitleAndDescriptionView.edgeAnchors + 4
        
        let storageCrossView = UIView()
        storageCrossView.backgroundColor = .clear//.yellow
        storageCrossView.widthAnchor == 20
        
        storageCrossView.addSubview(storageCrossImageView)
        storageCrossImageView.widthAnchor == DesignMetrics.Dimensions.width16
        storageCrossImageView.heightAnchor == DesignMetrics.Dimensions.height16
        storageCrossImageView.topAnchor == storageCrossView.topAnchor + 8
        storageCrossImageView.trailingAnchor == storageCrossView.trailingAnchor - 4
        
        storageBoxContainerStackView.addArrangedSubview(storageViewForImage)
        storageBoxContainerStackView.addArrangedSubview(storageTitleAndDescriptionView)
        storageBoxContainerStackView.addArrangedSubview(storageCrossView)
        
        storageBoxContainerView.addSubview(storageBoxContainerStackView)
        storageBoxContainerStackView.horizontalAnchors == storageBoxContainerView.horizontalAnchors + 12
        storageBoxContainerStackView.verticalAnchors == storageBoxContainerView.verticalAnchors + 12
    }
}
