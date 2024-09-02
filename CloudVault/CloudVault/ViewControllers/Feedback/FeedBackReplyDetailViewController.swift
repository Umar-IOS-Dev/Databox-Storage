//
//  FeedBackReplyDetailViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 28/08/2024.
//

import UIKit
import Anchorage

class FeedBackReplyDetailViewController: BaseViewController {
    
    private let feedbackTextView: UITextView = {
            let textView = UITextView()
            textView.text = "Your feedback is crucial in shaping our product to better meet your needs. Share your thoughts with us to help us create an even better experience for you."
            textView.textColor = #colorLiteral(red: 0.0862745098, green: 0.09411764706, blue: 0.01960784314, alpha: 1)
            textView.textAlignment = .left
            textView.backgroundColor = .clear
            textView.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            textView.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
            return textView
        }()
    
    private let replyDataboxTextView: UITextView = {
            let textView = UITextView()
            textView.text = "Your feedback is crucial in shaping our product to better meet your needs. Share your thoughts with us to help us create an even better experience for you."
            textView.textColor = #colorLiteral(red: 0.0862745098, green: 0.09411764706, blue: 0.01960784314, alpha: 1)
            textView.textAlignment = .left
            textView.backgroundColor = .clear
            textView.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            textView.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
            return textView
        }()
    
    private let firstLabel: UILabel = {
        let firstLabel = UILabel()
        firstLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        firstLabel.textAlignment = .left
        firstLabel.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical"
        firstLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        return firstLabel
    }()
    
    private let secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        secondLabel.textAlignment = .left
        secondLabel.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical"
        secondLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        return secondLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "Feedback Reply", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        configureFeedbackView()
        configureReplyView()
    }
    
    private func configureFeedbackView() {
            let feedbackContainerView = UIView()
        feedbackContainerView.backgroundColor = .white
        feedbackContainerView.layer.cornerRadius = 8
        feedbackContainerView.heightAnchor == 227
        
        let feedbackMainstack = UIStackView()
        feedbackMainstack.axis = .vertical
        feedbackMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Your Feedback"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let feedbackContainer = UIView()
        feedbackContainer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        feedbackContainer.layer.cornerRadius = 8
        
        feedbackContainer.addSubview(feedbackTextView)
        feedbackTextView.topAnchor == feedbackContainer.topAnchor
        feedbackTextView.leadingAnchor == feedbackContainer.leadingAnchor
        feedbackTextView.trailingAnchor == feedbackContainer.trailingAnchor
        feedbackTextView.bottomAnchor == feedbackContainer.bottomAnchor
        
        feedbackMainstack.addArrangedSubview(headerLabel)
        feedbackMainstack.addArrangedSubview(feedbackContainer)
        
        feedbackContainerView.addSubview(feedbackMainstack)
        feedbackMainstack.edgeAnchors == feedbackContainerView.edgeAnchors + 16
        
        appendViewToMainVStack(view: feedbackContainerView, topPadding: 24)
    }
    
    private func configureReplyView() {
            let replyContainerView = UIView()
        replyContainerView.backgroundColor = .white
        replyContainerView.layer.cornerRadius = 8
        replyContainerView.heightAnchor == 227
        
        let replyMainstack = UIStackView()
        replyMainstack.axis = .vertical
        replyMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Reply From Databox"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let replyContainer = UIView()
        replyContainer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        replyContainer.layer.cornerRadius = 8
        
        replyContainer.addSubview(replyDataboxTextView)
        replyDataboxTextView.topAnchor == replyContainer.topAnchor
        replyDataboxTextView.leadingAnchor == replyContainer.leadingAnchor
        replyDataboxTextView.trailingAnchor == replyContainer.trailingAnchor
        replyDataboxTextView.bottomAnchor == replyContainer.bottomAnchor
        
        replyMainstack.addArrangedSubview(headerLabel)
        replyMainstack.addArrangedSubview(replyContainer)
        
        replyContainerView.addSubview(replyMainstack)
        replyMainstack.edgeAnchors == replyContainerView.edgeAnchors + 16
        
        appendViewToMainVStack(view: replyContainerView, topPadding: 24)
    }
    
    private func configureFeedbackFirstLabel() {
        let firstAndSecondLabelVstack = UIStackView()
        firstAndSecondLabelVstack.axis = .vertical
        firstAndSecondLabelVstack.spacing = 10
        
    }
    

}
