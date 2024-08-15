//
//  CardView.swift
//  CloudVault
//
//  Created by Appinators Technology on 09/07/2024.
//

import UIKit
import Anchorage

protocol CardViewDelegate: AnyObject {
    func didTapContinueButton()
}


class CardView: UIView {
    
    weak var cardDelegate: CardViewDelegate?
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultBoldText(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topImageContainerView: UIView = {
        let topView = UIView()
        topView.backgroundColor = #colorLiteral(red: 0.9375980496, green: 0.957516253, blue: 0.9958238006, alpha: 1)
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "OnBoardings/termsAndConditionImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.cloudVaultRegularText(ofSize: 12)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .justified
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultSemiBoldText(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.4582801871)
        label.text = "First read Terms & Conditions then continue"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let agreementTermsView: UIView = {
        let termsView = UIView()
        termsView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        return termsView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Agree and Continue", for: .normal)
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        let titleColorForDisableState: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
        button.isEnabled = false
        button.setTitleColor(titleColorForNormalState, for: .normal)
        button.setTitleColor(titleColorForDisableState, for: .disabled)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        return button
    }()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        setupView(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, description: String) {
        backgroundColor = UIColor(named: "appBackgroundColor")
        layer.cornerRadius = DesignMetrics.Padding.size8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        
        addSubview(scrollView)
        scrollView.edgeAnchors == edgeAnchors
        
        scrollView.addSubview(contentView)
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor
        
        contentView.addSubview(topImageContainerView)
        topImageContainerView.widthAnchor == DesignMetrics.Dimensions.width74
        topImageContainerView.heightAnchor == DesignMetrics.Dimensions.height74
        topImageContainerView.topAnchor == contentView.topAnchor + DesignMetrics.Padding.size12
        topImageContainerView.centerXAnchor == contentView.centerXAnchor
        topImageContainerView.layer.cornerRadius = DesignMetrics.Padding.size37
        
        topImageContainerView.addSubview(topImageView)
        topImageView.widthAnchor == DesignMetrics.Dimensions.width36
        topImageView.heightAnchor == DesignMetrics.Dimensions.height42
        topImageView.centerAnchors == topImageContainerView.centerAnchors
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor == topImageContainerView.bottomAnchor + DesignMetrics.Padding.size12
        titleLabel.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size12
        titleLabel.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size12
        titleLabel.text = title
        
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.topAnchor == titleLabel.bottomAnchor + DesignMetrics.Padding.size4
        subTitleLabel.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size12
        subTitleLabel.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size12
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor == subTitleLabel.bottomAnchor + DesignMetrics.Padding.size24
        descriptionLabel.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size16
        descriptionLabel.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size16
        descriptionLabel.heightAnchor == DesignMetrics.Dimensions.height110
        
        let attributedTextForDescription = setAttributedText(description, fontForText: UIFont.cloudVaultSemiBoldText(ofSize: 10))
        descriptionLabel.attributedText = attributedTextForDescription
        
        contentView.addSubview(agreementTermsView)
        agreementTermsView.topAnchor == descriptionLabel.bottomAnchor + DesignMetrics.Padding.size28
        agreementTermsView.leadingAnchor == contentView.leadingAnchor
        agreementTermsView.trailingAnchor == contentView.trailingAnchor
        agreementTermsView.heightAnchor == DesignMetrics.Dimensions.height60
        
        let agreementTermsStack = UIStackView()
        agreementTermsStack.spacing = DesignMetrics.Padding.size8
        agreementTermsStack.axis = .horizontal
        
        let checkBoxButton = UIButton()
        checkBoxButton.setImage(UIImage(named: "checkboxChecked"), for: .selected)
        checkBoxButton.setImage(UIImage(named: "checkboxUnchecked"), for: .normal)
        checkBoxButton.heightAnchor == DesignMetrics.Dimensions.height24
        checkBoxButton.widthAnchor == DesignMetrics.Dimensions.width24
        checkBoxButton.addTarget(self, action: #selector(checkBoxTapped(_:)), for: .touchUpInside)
        
        let checkTermsLabel = UILabel()
        checkTermsLabel.textAlignment = .left
        let checkTermsText = "By clicking continue button you are agree to the Privacy Policy and Terms & Conditions"
        checkTermsLabel.numberOfLines = 0
        checkTermsLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        let attributedTextForCheckTerms = setAttributedText(checkTermsText, fontForText: UIFont.cloudVaultSemiBoldText(ofSize: 12))
        checkTermsLabel.attributedText = attributedTextForCheckTerms
        
        agreementTermsStack.addArrangedSubview(checkBoxButton)
        agreementTermsStack.addArrangedSubview(checkTermsLabel)
        
        agreementTermsView.addSubview(agreementTermsStack)
        
        agreementTermsStack.leadingAnchor == agreementTermsView.leadingAnchor + DesignMetrics.Padding.size16
        agreementTermsStack.trailingAnchor == agreementTermsView.trailingAnchor - DesignMetrics.Padding.size16
        agreementTermsStack.verticalAnchors == agreementTermsView.verticalAnchors
        
        contentView.addSubview(continueButton)
        continueButton.topAnchor == agreementTermsView.bottomAnchor + DesignMetrics.Padding.size20
        continueButton.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size16
        continueButton.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size16
        continueButton.heightAnchor == DesignMetrics.Dimensions.height65
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        // Set content size of scrollView to fit all subviews
        contentView.bottomAnchor == continueButton.bottomAnchor + DesignMetrics.Padding.size16
    }
    
    @objc private func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        continueButton.isEnabled.toggle()
        if sender.isSelected {
            continueButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        } else {
            continueButton.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        }
    }
    
    @objc private func continueButtonTapped() {
        if continueButton.isEnabled {
            cardDelegate?.didTapContinueButton()
            print("Can move to next")
        }
    }
    
    func setAttributedText(_ text: String, fontForText: UIFont) -> NSAttributedString {
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = 4 // Adjust this value as needed

           let attributedString = NSAttributedString(string: text, attributes: [
               .paragraphStyle: paragraphStyle,
               .font: fontForText//UIFont.cloudVaultRegularText(ofSize: 12) // Adjust the font as needed
           ])
        return attributedString
          // descriptionLabel.attributedText = attributedString
       }
}


