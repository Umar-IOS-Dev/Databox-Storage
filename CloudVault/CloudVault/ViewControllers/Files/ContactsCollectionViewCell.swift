//
//  ContactsCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/08/2024.
//

import UIKit
import Anchorage
import Contacts

class ContactsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ContactsCollectionViewCell"
    
    let contactView: UIView = {
        let contactView = UIView()
        contactView.clipsToBounds = true
        contactView.layer.cornerRadius = 8
        return contactView
    }()
    
    let contactNameInitialLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 20)
        label.textColor = .white
       // label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1)
        return containerView
    }()
    
    let selectedIcon: UIImageView = {
        let selectedIcon = UIImageView()
        selectedIcon.contentMode = .scaleAspectFit
        selectedIcon.image = UIImage(named: "selectedIcon")
        return selectedIcon
    }()

    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
       // label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "verticalDotsWhite"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
       // button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()
    
    let documentNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .center
       // label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        contentView.addSubview(containerView)
        containerView.addSubview(contactView)
        
        containerView.addSubview(sizeLabel)
        containerView.addSubview(button)
        containerView.addSubview(documentNameLabel)
        containerView.addSubview(overlayView)
        
        containerView.edgeAnchors == contentView.edgeAnchors
        
        sizeLabel.topAnchor == containerView.topAnchor + 8
        sizeLabel.leadingAnchor == containerView.leadingAnchor + 8
        
        button.topAnchor == containerView.topAnchor + 4
        button.trailingAnchor == containerView.trailingAnchor - 4
        button.widthAnchor == 14
        button.heightAnchor == 14
        
        contactView.heightAnchor == 40
        contactView.widthAnchor == 40
        contactView.centerXAnchor == containerView.centerXAnchor
        contactView.topAnchor == button.bottomAnchor
        
        contactView.addSubview(contactNameInitialLabel)
        
        contactNameInitialLabel.edgeAnchors == contactView.edgeAnchors
        
        documentNameLabel.bottomAnchor == containerView.bottomAnchor - 4
        documentNameLabel.centerXAnchor == containerView.centerXAnchor
        documentNameLabel.leadingAnchor >= containerView.leadingAnchor + 4
        documentNameLabel.trailingAnchor <= containerView.trailingAnchor - 4
        
        // Configure overlay view
        overlayView.frame = contentView.bounds
        overlayView.isHidden = true
        
        overlayView.addSubview(selectedIcon)
        selectedIcon.widthAnchor == DesignMetrics.Dimensions.width16
        selectedIcon.heightAnchor == DesignMetrics.Dimensions.height16
        selectedIcon.topAnchor == overlayView.topAnchor + DesignMetrics.Padding.size8
        selectedIcon.trailingAnchor == overlayView.trailingAnchor - DesignMetrics.Padding.size8
    }
    
    func configure(with data: CNContact, contactViewColor: UIColor) {
        if let firstLetter = data.givenName.first {
            let firstLetterString = String(firstLetter)
            print("The first letter is \(firstLetterString)")
            contactNameInitialLabel.text = firstLetterString
        }
        contactView.backgroundColor = contactViewColor
//        sizeLabel.text = data.size
        documentNameLabel.text = data.givenName
    }
    
    func setSelected(_ selected: Bool) {
        containerView.layer.borderColor = selected ? #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1) : UIColor.clear.cgColor
        containerView.layer.borderWidth = selected ? 1 : 0
        containerView.layer.cornerRadius = 8
        overlayView.isHidden = !selected
    }
}
