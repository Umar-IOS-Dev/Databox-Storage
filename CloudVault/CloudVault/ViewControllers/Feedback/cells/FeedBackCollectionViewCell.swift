//
//  FeedBackCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/08/2024.
//

import UIKit

class FeedBackCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedBackCollectionViewCell"
    
    
    var feedbackTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .left
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    var emailAndDateLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.clipsToBounds = true
        label.textAlignment = .left
        return label
    }()
    
    let feedbackOptionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "feedbackOptionIcon"), for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [feedbackTypeLabel, emailAndDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        let containerView = UIView()
        containerView.addSubview(stackView)
        containerView.addSubview(feedbackOptionsButton)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        feedbackOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            
           
            
            feedbackOptionsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            feedbackOptionsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            feedbackOptionsButton.widthAnchor.constraint(equalToConstant: 20),
            feedbackOptionsButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
       
        
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
    
    func configure(with feedBackType: String, email: String, feedbackDate: String) {
        emailAndDateLabel.text = "Email: \(email) Date: \(feedbackDate)"
        feedbackTypeLabel.text = feedBackType
    }
    
}

struct FeedBackData: Hashable {
    let feedbackType: String
    let feedbackEmail: String
    let feedbackDate: String
}
