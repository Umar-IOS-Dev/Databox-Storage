//
//  AppFilesView.swift
//  CloudVault
//
//  Created by Appinators Technology on 23/07/2024.
//

import UIKit
import Anchorage

class AppFilesView: CustomRoundedView {
    private let fileImageView: UIImageView = {
        let fileImageView = UIImageView()
        fileImageView.contentMode = .scaleAspectFit
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        return fileImageView
    }()
    
    private let fileTitleLabel: UILabel = {
        let fileTitleLabel = UILabel()
        fileTitleLabel.textAlignment = .left
        fileTitleLabel.textColor = UIColor(named: "appPrimaryTextColor")
        fileTitleLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        return fileTitleLabel
    }()
    
    private let fileCounterLabel: UILabel = {
        let fileCounterLabel = UILabel()
        fileCounterLabel.textAlignment = .left
        fileCounterLabel.textColor = UIColor(named: "appPrimaryTextColor")
        fileCounterLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        return fileCounterLabel
    }()
    
    private let fileSizeLabel: UILabel = {
        let fileSizeLabel = UILabel()
        fileSizeLabel.textAlignment = .left
        fileSizeLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 11.38)
        fileSizeLabel.text = "00GB"
        return fileSizeLabel
    }()
    
    // Flag to track if the animation has been performed
        private var hasAnimated = false
    
    init(fileImage: UIImage, titleOfFile: String, totalCount: String, totalSize: String, labelColor: UIColor) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "appBackgroundViewColor") 
        setupFilesView(fileImage: fileImage, titleOfFile: titleOfFile, totalCount: totalCount, totalSize: totalSize, labelColor: labelColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupFilesView(fileImage: UIImage, titleOfFile: String, totalCount: String, totalSize: String, labelColor: UIColor) {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        
        let fileView = UIView()
        fileView.backgroundColor = .clear
        
        let fileSizeView = UIView()
        fileSizeView.widthAnchor == 20
        fileSizeView.backgroundColor = .clear
        
        let fileSizeLabel = UILabel()
        fileSizeLabel.textAlignment = .right
        fileSizeLabel.textColor = labelColor
        fileSizeLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        fileSizeLabel.text = totalSize
        
        fileSizeView.addSubview(fileSizeLabel)
        fileSizeLabel.topAnchor == fileSizeView.topAnchor + 12
        fileSizeLabel.trailingAnchor == fileSizeView.trailingAnchor - 4
        
        let fileStackView = UIStackView()
        fileStackView.axis = .vertical
        fileStackView.distribution = .equalSpacing
        //fileStackView.spacing = DesignMetrics.Padding.size0
        
        let viewForFileImageView = UIView()
        viewForFileImageView.backgroundColor = .clear
        
        let viewForFileTitleLabel = UIView()
        viewForFileTitleLabel.backgroundColor = .clear
        
        let viewForFileCounterLabel = UIView()
        viewForFileCounterLabel.backgroundColor = .clear
        
        viewForFileImageView.addSubview(fileImageView)
        viewForFileTitleLabel.addSubview(fileTitleLabel)
        viewForFileCounterLabel.addSubview(fileCounterLabel)
        
    
        
        fileImageView.heightAnchor == 36
        fileImageView.widthAnchor == 36
        fileImageView.verticalAnchors == viewForFileImageView.verticalAnchors
        fileImageView.leadingAnchor == viewForFileImageView.leadingAnchor + 10
        fileImageView.image = fileImage//.withRenderingMode(.alwaysTemplate)
       // fileImageView.tintColor = labelColor
        
        
        fileTitleLabel.verticalAnchors == viewForFileTitleLabel.verticalAnchors
        fileTitleLabel.leadingAnchor == viewForFileTitleLabel.leadingAnchor + 10
        fileTitleLabel.trailingAnchor == viewForFileTitleLabel.trailingAnchor
        
        fileCounterLabel.verticalAnchors == viewForFileCounterLabel.verticalAnchors
        fileCounterLabel.leadingAnchor == viewForFileCounterLabel.leadingAnchor + 10
        fileCounterLabel.trailingAnchor == viewForFileCounterLabel.trailingAnchor
        
        
        fileTitleLabel.text = titleOfFile
        fileCounterLabel.text = totalCount
        
        
        
        fileStackView.addArrangedSubview(viewForFileImageView)
        fileStackView.addArrangedSubview(viewForFileTitleLabel)
        fileStackView.addArrangedSubview(viewForFileCounterLabel)
        
        fileView.addSubview(fileStackView)
        fileStackView.horizontalAnchors == fileView.horizontalAnchors
        fileStackView.verticalAnchors == fileView.verticalAnchors + 16
//        fileStackView.edgeAnchors == fileView.edgeAnchors
        
        mainStackView.addArrangedSubview(fileView)
        mainStackView.addArrangedSubview(fileSizeView)
        addSubview(mainStackView)
        mainStackView.verticalAnchors == verticalAnchors
        mainStackView.horizontalAnchors == horizontalAnchors + 4
        
    }
    
    
    // Function to rotate the iconImageView
        func rotateIconImageView() {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = CGFloat.pi * 2 // Full rotation (360 degrees)
            rotationAnimation.duration = 20.0 // Duration for one full rotation (slow rotation)
            rotationAnimation.repeatCount = .infinity // Repeat indefinitely
            fileImageView.layer.add(rotationAnimation, forKey: "rotate")
        }
    
    // Function to animate icons
       func animateIcons() {
           // Check if the animation has already been performed
                  if hasAnimated { return }
           // Remove any previous animations to start fresh
              self.layer.removeAllAnimations()
              // Apply the animation (e.g., translation, rotation, etc.)
           UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn], animations: {
                  // Example: Move the icon from left to right
                  self.fileImageView.transform = CGAffineTransform(translationX: 20, y: 0)
              }, completion: { _ in
                  // Reset the transform at the end of the animation
                  self.fileImageView.transform = .identity
                   self.hasAnimated = true
              })
           
           
           
     // //       Check if the animation has already been performed
//                  if hasAnimated { return }
//                  
//                  // Remove any previous animations to start fresh
//                  self.layer.removeAllAnimations()
//                  
//                  // Make sure the layout is set up
//                  self.layoutIfNeeded()
//                  
//                  // Get the center of the screen (from superview bounds)
//                  guard let superview = self.superview else { return }
//                  let screenWidth = superview.bounds.width
//                  let screenHeight = superview.bounds.height
//                  let centerOfScreen = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
//                  
//                  // Calculate the distance from the icon’s original position to the center of the screen
//                  let translationX = centerOfScreen.x - self.fileImageView.center.x
//                  let translationY = centerOfScreen.y - self.fileImageView.center.y
//                  
//                  // Move the icon to the center of the screen
//                  self.transform = CGAffineTransform(translationX: translationX, y: translationY)
//                  
//                  // Animate it back to its original position
//                  UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
//                      // Reset the transform to move the icon back to its original place
//                      self.transform = .identity
//                  }, completion: { _ in
//                      // Set the flag to indicate that the animation has been performed
//                      self.hasAnimated = true
//                  })
           
           
           
           
           
       }
   
    
}
