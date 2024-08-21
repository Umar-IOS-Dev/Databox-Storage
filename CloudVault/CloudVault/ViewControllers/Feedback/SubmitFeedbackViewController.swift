//
//  SubmitFeedbackViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit
import Anchorage

class SubmitFeedbackViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .clear
        configureUI(title: "", showBackButton: false, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
//        setupSegmentedView()
    }
    
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        setupSegmentedView()
       
    }

    private func setupSegmentedView() {
        let issueTypeContainerView = UIView()
        issueTypeContainerView.backgroundColor = .red
        issueTypeContainerView.layer.cornerRadius = 8
        issueTypeContainerView.heightAnchor == 165
        
        let issueTypeMainstack = UIStackView()
        issueTypeMainstack.axis = .vertical
        issueTypeMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Type of Issue"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let issuesContainer = UIView()
        issuesContainer.backgroundColor = .green
        
        issueTypeMainstack.addArrangedSubview(headerLabel)
        issueTypeMainstack.addArrangedSubview(issuesContainer)
        
        issueTypeContainerView.addSubview(issueTypeMainstack)
        issueTypeMainstack.edgeAnchors == issueTypeContainerView.edgeAnchors + 10
        
        appendViewToMainVStack(view: issueTypeContainerView, topPadding: 24)
        
    }

}
