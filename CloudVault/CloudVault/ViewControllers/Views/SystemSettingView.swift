//
//  SystemSettingView.swift
//  CloudVault
//
//  Created by Appinators Technology on 25/07/2024.
//

import UIKit

class SystemSettingView: UIView {

    let leftImageView = UIImageView()
       let titleLabel = UILabel()
       let rightImageView = UIImageView()
       
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
           
           // Setting up rightImageView
           rightImageView.contentMode = .scaleAspectFit
           rightImageView.translatesAutoresizingMaskIntoConstraints = false
           addSubview(rightImageView)
           
           // Adding constraints
           NSLayoutConstraint.activate([
               // Left ImageView Constraints
               leftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
               leftImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
               leftImageView.widthAnchor.constraint(equalToConstant: 34),
               leftImageView.heightAnchor.constraint(equalToConstant: 34),
               
               // Right ImageView Constraints
               rightImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
               rightImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
               rightImageView.widthAnchor.constraint(equalToConstant: 20),
               rightImageView.heightAnchor.constraint(equalToConstant: 20),
               
               // Title Label Constraints
               titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 16),
               titleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -8),
               titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
           ])
           
           titleLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
           titleLabel.font = UIFont.cloudVaultSemiBoldText(ofSize: 14)
       }

}
