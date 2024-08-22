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
        configureUI(title: "", showBackButton: false, hideBackground: true, showMainNavigation: false, showAsSubViewController: true)
        hideFocusbandOptionFromNavBar()
//        setupSegmentedView()
    }
    
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
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
        
        // Create the first horizontal stack view
            let firstHorizontalStack = UIStackView()
            firstHorizontalStack.axis = .horizontal
            firstHorizontalStack.spacing = 12
            
            // Create the second horizontal stack view
            let secondHorizontalStack = UIStackView()
            secondHorizontalStack.axis = .horizontal
            secondHorizontalStack.spacing = 12
            // Create buttons and add them to the horizontal stacks
            for i in 1...3 {
                let button1 = createButton(title: "Option \(i)")
                let button2 = createButton(title: "Option \(i + 3)")
                
                firstHorizontalStack.addArrangedSubview(button1)
                secondHorizontalStack.addArrangedSubview(button2)
                
                button1.tag = i
                button2.tag = i + 3
                
                button1.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
                button2.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            }
        // Create a vertical stack view to contain the two horizontal stacks
            let verticalStack = UIStackView(arrangedSubviews: [firstHorizontalStack, secondHorizontalStack])
            verticalStack.axis = .vertical
            verticalStack.spacing = 12
            
        issuesContainer.addSubview(verticalStack)
        verticalStack.topAnchor == issuesContainer.topAnchor
        verticalStack.leadingAnchor == issuesContainer.leadingAnchor
        verticalStack.trailingAnchor == issuesContainer.trailingAnchor
        verticalStack.bottomAnchor == issuesContainer.bottomAnchor
        
        issueTypeMainstack.addArrangedSubview(headerLabel)
        issueTypeMainstack.addArrangedSubview(issuesContainer)
        
        issueTypeContainerView.addSubview(issueTypeMainstack)
        issueTypeMainstack.edgeAnchors == issueTypeContainerView.edgeAnchors + 20
        
        appendViewToMainVStack(view: issueTypeContainerView, topPadding: 24)
        
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    @objc private func handleButtonTap(_ sender: UIButton) {
        for i in 1...6 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
                button.setTitleColor(.white, for: .normal)
            }
        }
        sender.backgroundColor = #colorLiteral(red: 0.2, green: 0.8, blue: 0.4, alpha: 1)
        sender.setTitleColor(.black, for: .normal)
    }

}
