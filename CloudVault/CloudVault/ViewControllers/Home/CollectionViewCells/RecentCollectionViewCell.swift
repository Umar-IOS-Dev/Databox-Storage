//
//  RecentCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 23/07/2024.
//

import UIKit
import Anchorage

class RecentCollectionViewCell: UICollectionViewCell {
    private let recentContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 1 // Adjust the border width
        containerView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // Adjust the border color
        containerView.layer.cornerRadius = 8 // Adjust the corner radius
        return containerView
    }()
    private let recentImageView: UIImageView = {
        let recentImageView = UIImageView()
        recentImageView.backgroundColor = .clear
        recentImageView.contentMode = .scaleAspectFit
        return recentImageView
    }()
    private let imageNameLabel: UILabel = {
        let imageNameLabel = UILabel()
        imageNameLabel.textAlignment = .left
        imageNameLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        imageNameLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        return imageNameLabel
    }()
    private let imageSizeLabel: UILabel = {
        let imageSizeLabel = UILabel()
        imageSizeLabel.textAlignment = .left
        imageSizeLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        imageSizeLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        return imageSizeLabel
    }()
    var recentImageName: String = "" {
        didSet {
            recentImageView.image = UIImage(named: recentImageName)
        }
    }
    var imageName: String = "" {
        didSet {
            imageNameLabel.text = imageName
        }
    }
    var imageSize: String = "" {
        didSet {
            imageSizeLabel.text = imageSize
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRecentContainerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRecentContainerView() {
        addSubview(recentContainerView)
        recentContainerView.edgeAnchors == edgeAnchors
        
        let recentContainerStackView = UIStackView()
        recentContainerStackView.axis = .vertical
        recentContainerStackView.spacing = 8
        
        recentImageView.widthAnchor == 107
        recentImageView.heightAnchor == 83
        
        let imageNameAndSizeView = UIView()
        imageNameAndSizeView.backgroundColor = .clear
        
        let imageNameAndSizeStackView = UIStackView()
        imageNameAndSizeStackView.axis = .horizontal
        imageNameAndSizeStackView.spacing = 10
        
        let recentImageIcon = UIImageView()
        recentImageIcon.backgroundColor = .clear
        recentImageIcon.contentMode = .scaleAspectFit
        recentImageIcon.image = UIImage(named: "recentImageIcon")
        recentImageIcon.widthAnchor == 14
        recentImageIcon.heightAnchor == 14
        
        let nameAndSizeView = UIView()
        nameAndSizeView.backgroundColor = .clear
        
        let nameAndSizeStackView = UIStackView()
        nameAndSizeStackView.axis = .vertical
        nameAndSizeStackView.distribution = .fillEqually
        
        nameAndSizeStackView.addArrangedSubview(imageNameLabel)
        nameAndSizeStackView.addArrangedSubview(imageSizeLabel)
        nameAndSizeView.addSubview(nameAndSizeStackView)
        nameAndSizeStackView.edgeAnchors == nameAndSizeView.edgeAnchors
        
        imageNameAndSizeStackView.addArrangedSubview(recentImageIcon)
        imageNameAndSizeStackView.addArrangedSubview(nameAndSizeView)
        imageNameAndSizeView.addSubview(imageNameAndSizeStackView)
        imageNameAndSizeStackView.edgeAnchors == imageNameAndSizeView.edgeAnchors
        
        recentContainerStackView.addArrangedSubview(recentImageView)
        recentContainerStackView.addArrangedSubview(imageNameAndSizeView)
        recentContainerView.addSubview(recentContainerStackView)
        recentContainerStackView.edgeAnchors == recentContainerView.edgeAnchors + 4
        
    }
}

struct RecentImageData {
    let recentImage: String
    let imageName: String
    let imageSize: String
}
