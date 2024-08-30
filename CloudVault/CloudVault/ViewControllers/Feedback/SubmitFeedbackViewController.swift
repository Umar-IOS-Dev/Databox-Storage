//
//  SubmitFeedbackViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit
import Anchorage

class SubmitFeedbackViewController: BaseViewController {
    
    private let problemTextView: UITextView = {
            let textView = UITextView()
            textView.text = "Write the problem that you face....."
            textView.textColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
            textView.textAlignment = .center
            textView.backgroundColor = .clear
            textView.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            textView.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
            return textView
        }()
    
    private let emailOrPhoneTextField: UITextField = {
            let emailOrPhoneTextField = UITextField()
        emailOrPhoneTextField.placeholder = "Databoxhelpcenter@gmail.com"
        emailOrPhoneTextField.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        emailOrPhoneTextField.tintColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        emailOrPhoneTextField.backgroundColor = .clear
        emailOrPhoneTextField.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
            return emailOrPhoneTextField
        }()
    
    private let characterCountLabel: UILabel = {
        let characterCountLabel = UILabel()
        characterCountLabel.text = "0/50"
        characterCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        characterCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        return characterCountLabel
    }()
    
    private let screenShotDotedView: UIView = {
        let screenShotDotedView = UIView()
        screenShotDotedView.backgroundColor = .clear
        screenShotDotedView.layer.cornerRadius = 8
        return screenShotDotedView
    }()
    
    private let screenShotImageView: UIImageView = {
        let screenShotImageView = UIImageView()
        screenShotImageView.layer.cornerRadius = 8
        screenShotImageView.contentMode = .scaleAspectFit
        screenShotImageView.image = UIImage(named: "placeHolderImage")
        return screenShotImageView
    }()
    
    private let submitFeedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Feedback", for: .normal)
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        let titleColorForDisableState: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
        button.isEnabled = false
        button.setTitleColor(titleColorForNormalState, for: .normal)
        button.setTitleColor(titleColorForDisableState, for: .disabled)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(named: "appBackgroundColor")
        problemTextView.delegate = self
        configureUI(title: "", showBackButton: false, hideBackground: true, showMainNavigation: false, showAsSubViewController: true)
        hideFocusbandOptionFromNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Apply the dotted border after the view has been laid out
        screenShotDotedView.setDottedBorder(color: #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1), lineWidth: 2.0)
    }
    
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        setupSegmentedView()
        setupProblemDescriptionView()
        setupEmailOrPhoneView()
        setupTakeScreenshotView()
        configureFooterView()
    }

    private func setupSegmentedView() {
        let issueTypeContainerView = UIView()
        issueTypeContainerView.backgroundColor = .white
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
        issuesContainer.backgroundColor = .clear
        
        // Create the first horizontal stack view
            let firstHorizontalStack = UIStackView()
            firstHorizontalStack.axis = .horizontal
            firstHorizontalStack.spacing = 12
            firstHorizontalStack.distribution = .fillEqually
            
            // Create the second horizontal stack view
            let secondHorizontalStack = UIStackView()
            secondHorizontalStack.axis = .horizontal
            secondHorizontalStack.spacing = 12
        secondHorizontalStack.distribution = .fillEqually
            // Create buttons and add them to the horizontal stacks
            for i in 1...3 {
                var button1 = UIButton()//createButton(title: "Option \(i)")
                var button2 = UIButton()//createButton(title: "Option \(i + 3)")
                switch i {
                case 1:
                    button1 = createButton(title: "Storage Issue")
                    button2 = createButton(title: "Ads")
                case 2:
                    button1 = createButton(title: "Backup")
                    button2 = createButton(title: "Errors")
                case 3:
                    button1 = createButton(title: "Uploading")
                    button2 = createButton(title: "Others")
                default:
                    break
                }
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
    
    private func setupProblemDescriptionView() {
        let problemDescriptionContainerView = UIView()
        problemDescriptionContainerView.backgroundColor = .white
        problemDescriptionContainerView.layer.cornerRadius = 8
        problemDescriptionContainerView.heightAnchor == 186
        
        let problemDescriptionMainstack = UIStackView()
        problemDescriptionMainstack.axis = .vertical
        problemDescriptionMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Describe Your Problem"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let problemContainer = UIView()
        problemContainer.layer.cornerRadius = 8
        problemContainer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        
        problemDescriptionMainstack.addArrangedSubview(headerLabel)
        problemDescriptionMainstack.addArrangedSubview(problemContainer)
        
        problemContainer.addSubview(problemTextView)
        problemTextView.edgeAnchors == problemContainer.edgeAnchors + 16
        
        problemDescriptionContainerView.addSubview(problemDescriptionMainstack)
        problemDescriptionMainstack.edgeAnchors == problemDescriptionContainerView.edgeAnchors + 20
        appendViewToMainVStack(view: problemDescriptionContainerView, topPadding: 24)
    }
    
    private func setupEmailOrPhoneView() {
        let emailOrPhoneContainerView = UIView()
        emailOrPhoneContainerView.backgroundColor = .white
        emailOrPhoneContainerView.layer.cornerRadius = 8
        emailOrPhoneContainerView.heightAnchor == 122
        
        let emailOrPhoneMainstack = UIStackView()
        emailOrPhoneMainstack.axis = .vertical
        emailOrPhoneMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Email or Phone"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let emailOrPhoneContainer = UIView()
        emailOrPhoneContainer.layer.cornerRadius = 8
        emailOrPhoneContainer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        
        emailOrPhoneMainstack.addArrangedSubview(headerLabel)
        emailOrPhoneMainstack.addArrangedSubview(emailOrPhoneContainer)
        
        // TextField setup
        emailOrPhoneContainer.addSubview(emailOrPhoneTextField)
        emailOrPhoneTextField.topAnchor == emailOrPhoneContainer.topAnchor
        emailOrPhoneTextField.leadingAnchor == emailOrPhoneContainer.leadingAnchor + 20
        emailOrPhoneTextField.trailingAnchor == emailOrPhoneContainer.trailingAnchor - 20
        emailOrPhoneTextField.bottomAnchor == emailOrPhoneContainer.bottomAnchor
        
        // Set the delegate
        emailOrPhoneTextField.delegate = self
        
        // Character count label
        emailOrPhoneContainer.addSubview(characterCountLabel)
        
        // Constraints for character count label
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterCountLabel.trailingAnchor.constraint(equalTo: emailOrPhoneTextField.trailingAnchor, constant: -5),
            characterCountLabel.bottomAnchor.constraint(equalTo: emailOrPhoneTextField.bottomAnchor, constant: -5)
        ])
        
        emailOrPhoneContainerView.addSubview(emailOrPhoneMainstack)
        emailOrPhoneMainstack.edgeAnchors == emailOrPhoneContainerView.edgeAnchors + 20
        appendViewToMainVStack(view: emailOrPhoneContainerView, topPadding: 24)
        
        // TextField character count update
        emailOrPhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let characterCount = textField.text?.count ?? 0
        characterCountLabel.text = "\(characterCount)/50"
    }
    
    private func setupTakeScreenshotView() {
        let screenShotContainerView = UIView()
        screenShotContainerView.backgroundColor = .white
        screenShotContainerView.layer.cornerRadius = 8
        screenShotContainerView.heightAnchor == 142
        
        let screenShotMainstack = UIStackView()
        screenShotMainstack.axis = .vertical
        screenShotMainstack.spacing = 10
        
        let headerLabel = UILabel()
        headerLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        headerLabel.text = "Take Screenshot (Optional)"
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headerLabel.heightAnchor == 20
        
        let screenShotContainer = UIView()
        screenShotContainer.layer.cornerRadius = 8
        screenShotContainer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        
        screenShotMainstack.addArrangedSubview(headerLabel)
        screenShotMainstack.addArrangedSubview(screenShotContainer)
        
        screenShotDotedView.addSubview(screenShotImageView)
        screenShotImageView.edgeAnchors == screenShotDotedView.edgeAnchors
        
        screenShotContainer.addSubview(screenShotDotedView)
        screenShotDotedView.edgeAnchors == screenShotContainer.edgeAnchors + 12
        
        screenShotContainerView.addSubview(screenShotMainstack)
        screenShotMainstack.edgeAnchors == screenShotContainerView.edgeAnchors + 20
        appendViewToMainVStack(view: screenShotContainerView, topPadding: 24)
    }
    
    private func configureFooterView() {
        let footerView = UIView()
        footerView.addSubview(submitFeedbackButton)
        footerView.backgroundColor = .white//#colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        submitFeedbackButton.edgeAnchors == footerView.edgeAnchors + DesignMetrics.Padding.size16
        submitFeedbackButton.addTarget(self, action: #selector(submitFeedbackButtonTapped), for: .touchUpInside)
        addFooterView(footerView: footerView, height: 93)
    }
    
    @objc func submitFeedbackButtonTapped() {
        print("submitFeedbackButtonTapped")
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    @objc private func handleButtonTap(_ sender: UIButton) {
        for i in 1...6 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
                button.setTitleColor(.white, for: .normal)
            }
        }
        sender.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        sender.setTitleColor(.white, for: .normal)
        submitFeedbackButton.isEnabled = true
        submitFeedbackButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
    }

}

extension SubmitFeedbackViewController: UITextViewDelegate ,UITextFieldDelegate {
    // UITextViewDelegate methods
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1) {
                textView.text = nil
                textView.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Write the problem that you face....."
                textView.textColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
            }
        }
    
    // Restrict the maximum number of characters to 50
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 50
    }
}
