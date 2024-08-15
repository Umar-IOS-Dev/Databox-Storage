//
//  ImagesCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 29/07/2024.
//

import UIKit
import Anchorage

class ImagesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImagesCollectionViewCell"
    
    let imagesView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let selectedIcon: UIImageView = {
        let selectedIcon = UIImageView()
        selectedIcon.contentMode = .scaleAspectFit
        selectedIcon.image = UIImage(named: "selectedIcon")
        return selectedIcon
    }()

    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultSemiBoldText(ofSize: 10)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "verticalDotsWhite"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
    
    let imageNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultSemiBoldText(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.layer.cornerRadius = 8
        overlayView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 0.5)
        return overlayView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imagesView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(button)
        contentView.addSubview(imageNameLabel)
        contentView.addSubview(overlayView)
        
        imagesView.edgeAnchors == contentView.edgeAnchors
        
        sizeLabel.topAnchor == contentView.topAnchor + 8
        sizeLabel.leadingAnchor == contentView.leadingAnchor + 8
        
        button.topAnchor == contentView.topAnchor + 4
        button.trailingAnchor == contentView.trailingAnchor - 4
        button.widthAnchor == 14
        button.heightAnchor == 14
        
        imageNameLabel.bottomAnchor == contentView.bottomAnchor - 4
        imageNameLabel.centerXAnchor == contentView.centerXAnchor
        imageNameLabel.leadingAnchor >= contentView.leadingAnchor + 4
        imageNameLabel.trailingAnchor <= contentView.trailingAnchor - 4
        
        // Configure overlay view
        overlayView.frame = contentView.bounds
        overlayView.isHidden = true
        
        overlayView.addSubview(selectedIcon)
        selectedIcon.widthAnchor == DesignMetrics.Dimensions.width16
        selectedIcon.heightAnchor == DesignMetrics.Dimensions.height16
        selectedIcon.topAnchor == overlayView.topAnchor + DesignMetrics.Padding.size8
        selectedIcon.trailingAnchor == overlayView.trailingAnchor - DesignMetrics.Padding.size8
    }
    
    func configure(with data: MediaData) {
        imagesView.image = data.icon
        sizeLabel.text = data.size
        imageNameLabel.text = data.name
    }
    
    func setSelected(_ selected: Bool) {
        contentView.layer.borderColor = selected ? #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1) : UIColor.clear.cgColor
        contentView.layer.borderWidth = selected ? 1 : 0
        contentView.layer.cornerRadius = 8
        overlayView.isHidden = !selected
    }
}




// Background Decoration View
class SectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class ImagesCollectionViewCell1: UICollectionViewCell {
    static let reuseIdentifier = "ImagesCollectionViewCell1"
    
    let imagesView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let imageNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultBoldText(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .left
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultRegularText(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.clipsToBounds = true
        label.textAlignment = .left
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "verticalDots"), for: .normal)
        return button
    }()
    
    let selectedIcon: UIImageView = {
        let selectedIcon = UIImageView()
        selectedIcon.contentMode = .scaleAspectFit
        selectedIcon.image = UIImage(named: "selectedIcon")
        return selectedIcon
    }()
    
    private let overlayView: UIView = {
        let overlayView = UIView()
        overlayView.layer.cornerRadius = 8
        overlayView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 0.5)
        return overlayView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [imageNameLabel, sizeLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        let containerView = UIView()
        containerView.addSubview(imagesView)
        containerView.addSubview(stackView)
        containerView.addSubview(optionsButton)
        containerView.addSubview(overlayView)
        
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure overlay view
        overlayView.frame = containerView.bounds
        overlayView.isHidden = true
        
        overlayView.addSubview(selectedIcon)
        
        
        NSLayoutConstraint.activate([
            imagesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imagesView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imagesView.widthAnchor.constraint(equalToConstant: 60),
            imagesView.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.leadingAnchor.constraint(equalTo: imagesView.trailingAnchor, constant: 12),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            overlayView.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            optionsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            optionsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        selectedIcon.widthAnchor == DesignMetrics.Dimensions.width16
        selectedIcon.heightAnchor == DesignMetrics.Dimensions.height16
        selectedIcon.topAnchor == overlayView.topAnchor + DesignMetrics.Padding.size8
        selectedIcon.trailingAnchor == overlayView.trailingAnchor - DesignMetrics.Padding.size8
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: MediaData) {
        imagesView.image = data.icon
        sizeLabel.text = data.size
        imageNameLabel.text = data.name
    }
    
    func setSelected(_ selected: Bool) {
        contentView.layer.borderColor = selected ? #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1) : UIColor.clear.cgColor
        contentView.layer.borderWidth = selected ? 1 : 0
        overlayView.isHidden = !selected
    }
}
