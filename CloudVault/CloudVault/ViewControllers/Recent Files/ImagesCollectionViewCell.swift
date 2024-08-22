//
//  ImagesCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 29/07/2024.
//

import UIKit
import Anchorage
import Photos
import SDWebImage

class ImagesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImagesCollectionViewCell"
    private var imageRequestID: PHImageRequestID?
    
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

    
    var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
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
    
    var imageNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
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
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()

            // Remove the target for the button to avoid multiple actions being added
            button.removeTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
        }

        func configureCell() {
            // Add the target-action after configuring the cell
            button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
        }

        @objc private func verticalDotTapped(_ sender: UIButton) {
            // Handle button tap action
        }
    
    private func setupViews() {
        contentView.addSubview(imagesView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(button)
        contentView.addSubview(imageNameLabel)
        contentView.addSubview(overlayView)
        contentView.layer.cornerRadius = 8
        
        imagesView.edgeAnchors == contentView.edgeAnchors
        
        sizeLabel.topAnchor == contentView.topAnchor + 8
        sizeLabel.leadingAnchor == contentView.leadingAnchor + 8
        
        button.topAnchor == contentView.topAnchor + 4
        button.trailingAnchor == contentView.trailingAnchor - 4
        button.widthAnchor == 30
        button.heightAnchor == 30
        
        imageNameLabel.bottomAnchor == contentView.bottomAnchor - 4
        imageNameLabel.centerXAnchor == contentView.centerXAnchor
        imageNameLabel.leadingAnchor >= contentView.leadingAnchor + 4
        imageNameLabel.trailingAnchor <= contentView.trailingAnchor - 4
        
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
        overlayView.isHidden = !selected
    }
    
//    func setImage(with asset: PHAsset, targetSize: CGSize) {
//            let options = PHImageRequestOptions()
//            options.isSynchronous = false
//            options.deliveryMode = .highQualityFormat
//            
//            let imageManager = PHImageManager.default()
//            
//            // Fetch a blurred placeholder image
//            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak self] (image, _) in
//                guard let self = self else { return }
//                
//                // Set the blurred image as a placeholder
//                let blurredImage = image?.sd_blurredImage(withRadius: 10)
//                self.imagesView.sd_setImage(with: nil, placeholderImage: blurredImage)
//                
//                // Load the full-resolution image asynchronously
//                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (highResImage, _) in
//                    self.imagesView.sd_setImage(with: nil, placeholderImage: highResImage)
//                }
//            }
//        }
    
    
//    func setImage(with asset: PHAsset, targetSize: CGSize) {
//        let options = PHImageRequestOptions()
//        options.isSynchronous = false
//        options.deliveryMode = .highQualityFormat
//
//        let imageManager = PHImageManager.default()
//
//        // Fetch image
//        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak self] (image, _) in
//            guard let self = self else { return }
//            
//            // Set the image
//            self.imagesView.sd_setImage(with: nil, placeholderImage: image)
//        }
//    }
    
//    func setImage(with asset: PHAsset, targetSize: CGSize) {
//           // Cancel any ongoing request for this cell before starting a new one
//           cancelImageLoad()
//
//           let options = PHImageRequestOptions()
//           options.isSynchronous = false
//           options.deliveryMode = .highQualityFormat
//           
//           let imageManager = PHImageManager.default()
//
//           // Fetch a blurred placeholder image
//           let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak self] (image, _) in
//               guard let self = self else { return }
//               
//               // Set the blurred image as a placeholder
//               let blurredImage = image?.sd_blurredImage(withRadius: 10)
//               self.imagesView.sd_setImage(with: nil, placeholderImage: blurredImage)
//               
//               // Load the full-resolution image asynchronously
//               let highResRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (highResImage, _) in
//                   self.imagesView.sd_setImage(with: nil, placeholderImage: highResImage)
//               }
//               
//               // Store the request ID for cancellation if needed
//               self.imageRequestID = highResRequestID
//           }
//           
//           // Store the request ID for cancellation if needed
//           self.imageRequestID = requestID
//       }
//
//       func cancelImageLoad() {
//           // Cancel the ongoing request if any
//           if let requestID = imageRequestID {
//               PHImageManager.default().cancelImageRequest(requestID)
//           }
//       }
    
    
    
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
    private var imageRequestID: PHImageRequestID?
    
    let imagesView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    var imageNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .left
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
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
    
//    func setImage(with asset: PHAsset, targetSize: CGSize) {
//            let options = PHImageRequestOptions()
//            options.isSynchronous = false
//            options.deliveryMode = .highQualityFormat
//            
//            let imageManager = PHImageManager.default()
//            
//            // Fetch a blurred placeholder image
//            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak self] (image, _) in
//                guard let self = self else { return }
//                
//                // Set the blurred image as a placeholder
//                let blurredImage = image?.sd_blurredImage(withRadius: 10)
//                self.imagesView.sd_setImage(with: nil, placeholderImage: blurredImage)
//                
//                // Load the full-resolution image asynchronously
//                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (highResImage, _) in
//                    self.imagesView.sd_setImage(with: nil, placeholderImage: highResImage)
//                }
//            }
//        }
//    func setImage(with asset: PHAsset, targetSize: CGSize) {
//           // Cancel any ongoing request for this cell before starting a new one
//           cancelImageLoad()
//
//           let options = PHImageRequestOptions()
//           options.isSynchronous = false
//           options.deliveryMode = .highQualityFormat
//           
//           let imageManager = PHImageManager.default()
//
//           // Fetch a blurred placeholder image
//           let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak self] (image, _) in
//               guard let self = self else { return }
//               
//               // Set the blurred image as a placeholder
//               let blurredImage = image?.sd_blurredImage(withRadius: 10)
//               self.imagesView.sd_setImage(with: nil, placeholderImage: blurredImage)
//               
//               // Load the full-resolution image asynchronously
//               let highResRequestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (highResImage, _) in
//                   self.imagesView.sd_setImage(with: nil, placeholderImage: highResImage)
//               }
//               
//               // Store the request ID for cancellation if needed
//               self.imageRequestID = highResRequestID
//           }
//           
//           // Store the request ID for cancellation if needed
//           self.imageRequestID = requestID
//       }
//
//       func cancelImageLoad() {
//           // Cancel the ongoing request if any
//           if let requestID = imageRequestID {
//               PHImageManager.default().cancelImageRequest(requestID)
//           }
//       }
    
    
}
