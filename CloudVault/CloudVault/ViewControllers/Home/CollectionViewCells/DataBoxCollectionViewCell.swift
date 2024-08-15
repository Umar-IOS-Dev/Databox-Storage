//
//  DataBoxCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 22/07/2024.
//

import UIKit
import Anchorage

class DataBoxCollectionViewCell: UICollectionViewCell {
    
    private let dataBoxContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 1 // Adjust the border width
        containerView.layer.borderColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1) // Adjust the border color
        containerView.layer.cornerRadius = 8 // Adjust the corner radius
        return containerView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        titleLabel.font = UIFont.cloudVaultBoldText(ofSize: 16)
        return titleLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.cloudVaultRegularText(ofSize: 12)
        return descriptionLabel
    }()
    private let dataBoxImageView: UIImageView = {
        let dataBoxImageView = UIImageView()
        dataBoxImageView.contentMode = .scaleAspectFit
        dataBoxImageView.image = UIImage(named: "dataBoxImage")
        return dataBoxImageView
    }()
    var titleOfDataBox: String = "" {
        didSet {
            titleLabel.text = titleOfDataBox
        }
    }
    var descriptionOfDataBox: String = "" {
        didSet {
            descriptionLabel.text = descriptionOfDataBox
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
        addSubview(dataBoxContainerView)
        dataBoxContainerView.edgeAnchors == edgeAnchors
        
        let dataBoxContainerStackView = UIStackView()
        dataBoxContainerStackView.axis = .horizontal
        dataBoxContainerStackView.spacing = DesignMetrics.Padding.size16
        
        let titleAndDescriptionView = UIView()
        titleAndDescriptionView.backgroundColor = .clear
        
        let titleAndDescriptionStackView = UIStackView()
        titleAndDescriptionStackView.axis = .vertical
        titleAndDescriptionStackView.spacing = DesignMetrics.Padding.size0
        
        titleAndDescriptionStackView.addArrangedSubview(titleLabel)
        titleAndDescriptionStackView.addArrangedSubview(descriptionLabel)
        
        titleAndDescriptionView.addSubview(titleAndDescriptionStackView)
        titleAndDescriptionStackView.horizontalAnchors == titleAndDescriptionView.horizontalAnchors
        titleAndDescriptionStackView.verticalAnchors == titleAndDescriptionView.verticalAnchors + DesignMetrics.Padding.size4
        
        let dataBoxViewForImage = UIView()
        dataBoxViewForImage.backgroundColor = .clear
        dataBoxViewForImage.widthAnchor == 120
        dataBoxViewForImage.heightAnchor == 60
        
        dataBoxViewForImage.addSubview(dataBoxImageView)
        dataBoxImageView.edgeAnchors == dataBoxViewForImage.edgeAnchors + 4
        
        dataBoxContainerStackView.addArrangedSubview(titleAndDescriptionView)
        dataBoxContainerStackView.addArrangedSubview(dataBoxViewForImage)
        
        dataBoxContainerView.addSubview(dataBoxContainerStackView)
        dataBoxContainerStackView.edgeAnchors == dataBoxContainerView.edgeAnchors + DesignMetrics.Padding.size8
    }
}

