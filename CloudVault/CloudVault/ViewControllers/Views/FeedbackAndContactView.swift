//
//  FeedbackAndContactView.swift
//  CloudVault
//
//  Created by Appinators Technology on 25/07/2024.
//

import UIKit

class FeedbackAndContactView: UIView {
    
    let leftImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        // Setting up subtitleLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        // Adding constraints
        NSLayoutConstraint.activate([
            // Left ImageView Constraints
            leftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 44),
            leftImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.leftImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            // Subtitle Label Constraints
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        // Sample data for testing
        titleLabel.text = "Title"
        titleLabel.textColor =  UIColor(named: "appPrimaryTextColor")
        titleLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        
        subtitleLabel.text = "Subtitle"
        subtitleLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 10)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor =  UIColor(named: "appPrimaryTextColor")
    }
    
}
