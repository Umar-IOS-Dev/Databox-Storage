//
//  PrivacyAndTermsView.swift
//  CloudVault
//
//  Created by Appinators Technology on 25/07/2024.
//

import UIKit

class PrivacyAndTermsView: UIView {

    let leftImageView = UIImageView()
        let titleLabel = UILabel()
        let rightButton = UIButton(type: .system)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        private func setupUI() {
            // Setting up leftImageView
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(leftImageView)
            
            // Setting up titleLabel
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
            
            // Setting up rightButton
            rightButton.setTitleColor(.systemBlue, for: .normal)
            rightButton.backgroundColor = .clear
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            rightButton.translatesAutoresizingMaskIntoConstraints = false
            let buttonTitleColor =  UIColor(named: "appPrimaryTextColor")
            let attributedString = NSAttributedString(string: "Read",
                                                      attributes: [
                                                          NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                          NSAttributedString.Key.font: FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14),
                                                          NSAttributedString.Key.foregroundColor: buttonTitleColor
                                                      ])
            rightButton.setAttributedTitle(attributedString, for: .normal)
            addSubview(rightButton)
            
            // Adding constraints
            NSLayoutConstraint.activate([
                // Left ImageView Constraints
                leftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                leftImageView.widthAnchor.constraint(equalToConstant: 34),
                leftImageView.heightAnchor.constraint(equalToConstant: 34),
                
                // Right Button Constraints
                rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                rightButton.widthAnchor.constraint(equalToConstant: 80),  // Adjust width as needed
                
                // Title Label Constraints
                titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -8),
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            
            titleLabel.textColor =  UIColor(named: "appPrimaryTextColor")
            titleLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        }

}
