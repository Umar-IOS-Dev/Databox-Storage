//
//  CreateProfileViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 15/07/2024.
//

import UIKit
import Anchorage

class CreateProfileViewController: BaseViewController {
    
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .clear
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = UIImage(named: "emoji1")
        return profileImageView
    }()
    private let personalityImagesArray: [UIImage] = {
        let imageNames = ["emoji1", "emoji2", "emoji3", "emoji4", "emoji5", "emoji6", "emoji7", "emoji8"]
        return imageNames.map { imageName in
            var imageView = UIImage()
            imageView = UIImage(named: imageName) ?? UIImage()
            return imageView
        }
    }()
    private let personalityAllImagesArray: [UIImage] = {
        let imageNames = ["emoji9", "emoji10", "emoji11", "emoji1", "emoji2", "emoji3", "emoji5", "emoji6", "emoji7", "emoji12", "emoji13", "emoji8", "emoji14", "emoji4", "emoji15", "emoji16", "emoji17", "emoji18"]
        return imageNames.map { imageName in
            var imageView = UIImage()
            imageView = UIImage(named: imageName) ?? UIImage()
            return imageView
        }
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Name Here"
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        return textField
    }()
    private let genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Gender Here"
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        return textField
    }()
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save & Continue", for: .normal)
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        let titleColorForDisableState: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.862745098, alpha: 1)
        button.isEnabled = true//false
        button.setTitleColor(titleColorForNormalState, for: .normal)
        button.setTitleColor(titleColorForDisableState, for: .disabled)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)//#colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        return button
    }()
    private var titleOfProfile = TitleOfProfile.guestUser
    private var createProfileWith = Profile.profileGuestUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        switch createProfileWith {
        case .profileGuestUser:
            configureUI(title: titleOfProfile.value, showBackButton: true, hideBackground: true, showMainNavigation: false)
        case .profilePhoneNumber:
            configureUI(title: titleOfProfile.value, showBackButton: false, hideBackground: true, showMainNavigation: false)
        case .profileGoogle:
            configureUI(title: titleOfProfile.value, showBackButton: false, hideBackground: true, showMainNavigation: false)
        }
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        configueInfoView()
        configureChoosePersonalityImageView()
        configureFooterView()
    }
    
    init(titleOfProfile: TitleOfProfile = .guestUser, createProfileWith: Profile) {
        self.titleOfProfile = titleOfProfile
        self.createProfileWith = createProfileWith
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configueInfoView() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        containerView.layer.cornerRadius = DesignMetrics.Padding.size12
        containerView.heightAnchor == DesignMetrics.Dimensions.height357
        
        let containerStack = UIStackView()
        containerStack.axis = .vertical
        containerStack.spacing = DesignMetrics.Padding.size12
        
        let profilePicContainerView = UIView()
        profilePicContainerView.backgroundColor = .clear
        profilePicContainerView.heightAnchor == DesignMetrics.Dimensions.height160
        
        let profilePicView = UIView()
        profilePicView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        profilePicView.layer.cornerRadius = DesignMetrics.Padding.size16
        
        profilePicContainerView.addSubview(profilePicView)
        profilePicView.topAnchor == profilePicContainerView.topAnchor + DesignMetrics.Padding.size16
        profilePicView.heightAnchor == DesignMetrics.Dimensions.height135
        profilePicView.widthAnchor == DesignMetrics.Dimensions.width127_75
        profilePicView.centerXAnchor == profilePicContainerView.centerXAnchor
        
        let profilePicStackView = UIStackView()
        profilePicStackView.axis = .vertical
        profilePicStackView.spacing = DesignMetrics.Padding.size0
        
        let fromGalleryView = CustomRoundedView()
        fromGalleryView.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        fromGalleryView.configureRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: DesignMetrics.Padding.size16)
        
        fromGalleryView.heightAnchor == DesignMetrics.Dimensions.height30
        profileImageView.heightAnchor == DesignMetrics.Dimensions.height80
        profileImageView.widthAnchor == DesignMetrics.Dimensions.width80
        
        let fromGalleryStackView = UIStackView()
        fromGalleryStackView.axis = .horizontal
        fromGalleryStackView.spacing = DesignMetrics.Padding.size4
        
        let camerImageView = UIImageView()
        camerImageView.heightAnchor == DesignMetrics.Dimensions.height16
        camerImageView.widthAnchor == DesignMetrics.Dimensions.width16
        camerImageView.image = UIImage(named: "cameraIcon")
        camerImageView.contentMode = .scaleAspectFit
        
        let fromGallerLabel = UILabel()
        fromGallerLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        fromGallerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        fromGallerLabel.textAlignment = .left
        fromGallerLabel.text = "From Gallery"
        fromGallerLabel.heightAnchor == DesignMetrics.Dimensions.height16
        
        fromGalleryStackView.addArrangedSubview(camerImageView)
        fromGalleryStackView.addArrangedSubview(fromGallerLabel)
        
        fromGalleryView.addSubview(fromGalleryStackView)
        fromGalleryStackView.verticalAnchors == fromGalleryView.verticalAnchors
        fromGalleryStackView.horizontalAnchors == fromGalleryView.horizontalAnchors + DesignMetrics.Padding.size20
        
        profilePicStackView.addArrangedSubview(profileImageView)
        profilePicStackView.addArrangedSubview(fromGalleryView)
        profilePicView.addSubview(profilePicStackView)
        profilePicStackView.edgeAnchors == profilePicView.edgeAnchors
        
        let containerStackForNameAndGender = UIStackView()
        containerStackForNameAndGender.axis = .vertical
        containerStackForNameAndGender.spacing = DesignMetrics.Padding.size12
        
        let containerStackForName = UIStackView()
        containerStackForName.axis = .vertical
        containerStackForName.spacing = DesignMetrics.Padding.size4
        
        let headingLabel = UILabel()
        headingLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 18)
        headingLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabel.textAlignment = .left
        headingLabel.text = "Your Name*"
        headingLabel.heightAnchor == DesignMetrics.Dimensions.height20
        
        let nameContainerView = UIView()
        nameContainerView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        nameContainerView.heightAnchor == DesignMetrics.Dimensions.height50
        nameContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        nameContainerView.addSubview(nameTextField)
        
        let containerStackForGender = UIStackView()
        containerStackForGender.axis = .vertical
        containerStackForGender.spacing = DesignMetrics.Padding.size4
        
        let headingLabelGender = UILabel()
        headingLabelGender.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 18)
        headingLabelGender.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabelGender.textAlignment = .left
        headingLabelGender.text = "Your Gender"
        headingLabelGender.heightAnchor == DesignMetrics.Padding.size20
        
        let genderContainerView = UIView()
        genderContainerView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        genderContainerView.heightAnchor == DesignMetrics.Dimensions.height50
        genderContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        genderContainerView.addSubview(genderTextField)
        genderTextField.edgeAnchors == genderContainerView.edgeAnchors + DesignMetrics.Padding.size8
        nameTextField.edgeAnchors == nameContainerView.edgeAnchors + DesignMetrics.Padding.size8
        
        switch createProfileWith {
        case .profileGuestUser: break
            
        case .profilePhoneNumber:
            headingLabelGender.text = "Mobile Number*"
            genderTextField.placeholder = "036464374712"
            
        case .profileGoogle:
            headingLabelGender.text = "Your Gmail*"
            genderTextField.placeholder = "hudammugfhal218@gmail.com"
        }
        
        containerStackForName.addArrangedSubview(headingLabel)
        containerStackForName.addArrangedSubview(nameContainerView)
        containerStackForGender.addArrangedSubview(headingLabelGender)
        containerStackForGender.addArrangedSubview(genderContainerView)
        
        containerStack.addArrangedSubview(profilePicContainerView)
        containerStackForNameAndGender.addArrangedSubview(containerStackForName)
        containerStackForNameAndGender.addArrangedSubview(containerStackForGender)
        containerStack.addArrangedSubview(containerStackForNameAndGender)
        
        containerView.addSubview(containerStack)
        containerStack.edgeAnchors == containerView.edgeAnchors + DesignMetrics.Padding.size12
        appendViewToMainVStack(view: containerView, topPadding: DesignMetrics.Padding.size24)
    }
    
    private func configureChoosePersonalityImageView() {
        let personalityContainerView = UIView()
        personalityContainerView.backgroundColor = .white
        personalityContainerView.layer.cornerRadius = DesignMetrics.Padding.size12
        personalityContainerView.heightAnchor == DesignMetrics.Dimensions.height210
        
        let personalityContainerStack = UIStackView()
        personalityContainerStack.axis = .vertical
        personalityContainerStack.spacing = DesignMetrics.Padding.size40
        
        let headingView = UIView()
        headingView.heightAnchor == DesignMetrics.Dimensions.height20
        
        let headingStackView = UIStackView()
        headingStackView.axis = .horizontal
        headingStackView.distribution = .fill
        headingStackView.spacing = DesignMetrics.Padding.size16
        
        let headingLabelGender = UILabel()
        headingLabelGender.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        headingLabelGender.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        headingLabelGender.textAlignment = .left
        headingLabelGender.text = "Choose your Personality"
        headingLabelGender.heightAnchor == DesignMetrics.Dimensions.height20
        
        let seeAllBtn = UIButton()
        seeAllBtn.setFont(FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14), for: .normal)
        seeAllBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1), for: .normal)
        seeAllBtn.setTitle("See All", for: .normal)
        seeAllBtn.backgroundColor = .clear
        seeAllBtn.heightAnchor == DesignMetrics.Dimensions.height20
        seeAllBtn.addTarget(self, action: #selector(seeAllButtonTapped(_:)), for: .touchUpInside)
        
        headingStackView.addArrangedSubview(headingLabelGender)
        headingStackView.addArrangedSubview(seeAllBtn)
        headingView.addSubview(headingStackView)
        headingStackView.edgeAnchors == headingView.edgeAnchors + DesignMetrics.Padding.size12
        
        let choosePersonalityView = UIView()
        choosePersonalityView.backgroundColor = .clear
        
        let choosePersonalityStack = UIStackView()
        choosePersonalityStack.axis = .vertical
        choosePersonalityStack.distribution = .equalSpacing
        
        // First Emoji View
        let firstEmojiView = UIView()
        firstEmojiView.backgroundColor = .clear
        firstEmojiView.heightAnchor == 54
        
        let firstEmojiStackView = UIStackView()
        firstEmojiStackView.axis = .horizontal
        firstEmojiStackView.distribution = .equalSpacing
        
        let firstButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.8470588235, green: 0.4235294118, blue: 0.3215686275, alpha: 0.09988839286), buttonImage: personalityImagesArray[0], buttonTag: 0),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.8352941176, blue: 0.6823529412, alpha: 0.2023543793), buttonImage: personalityImagesArray[1], buttonTag: 1),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.3607843137, blue: 0.2, alpha: 0.09988839286), buttonImage: personalityImagesArray[2], buttonTag: 2),
            createCircularButton(with: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), buttonImage: personalityImagesArray[3], buttonTag: 3)
        ]
        
        for button in firstButtons {
            firstEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 54
            button.heightAnchor == 54
        }
        
        
        firstEmojiView.addSubview(firstEmojiStackView)
        firstEmojiStackView.edgeAnchors == firstEmojiView.edgeAnchors
        // Second Emoji View
        let secondEmojiView = UIView()
        secondEmojiView.backgroundColor = .clear
        secondEmojiView.heightAnchor == 54
        
        let secondEmojiStackView = UIStackView()
        secondEmojiStackView.axis = .horizontal
        secondEmojiStackView.distribution = .equalSpacing
        // secondEmojiStackView.spacing = DesignMetrics.Padding.size4
        
        let secondButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.9921568627, green: 0.1529411765, blue: 0.4196078431, alpha: 0.09988839286), buttonImage: personalityImagesArray[4], buttonTag: 4),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.6117647059, blue: 0.7882352941, alpha: 0.09739051876), buttonImage: personalityImagesArray[5], buttonTag: 5),
            createCircularButton(with: #colorLiteral(red: 0.6784313725, green: 0.8117647059, blue: 0.09803921569, alpha: 0.09988839286), buttonImage: personalityImagesArray[6], buttonTag: 6),
            createCircularButton(with: #colorLiteral(red: 0.9254901961, green: 0.2156862745, blue: 0.2705882353, alpha: 0.09627444728), buttonImage: personalityImagesArray[7], buttonTag: 7)
        ]
        
        for button in secondButtons {
            secondEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 54
            button.heightAnchor == 54
        }
        
        secondEmojiView.addSubview(secondEmojiStackView)
        secondEmojiStackView.edgeAnchors == secondEmojiView.edgeAnchors
        
        choosePersonalityStack.addArrangedSubview(firstEmojiView)
        choosePersonalityStack.addArrangedSubview(secondEmojiView)
        
        choosePersonalityView.addSubview(choosePersonalityStack)
        choosePersonalityStack.edgeAnchors == choosePersonalityView.edgeAnchors
        
        personalityContainerStack.addArrangedSubview(headingView)
        personalityContainerStack.addArrangedSubview(choosePersonalityView)
        
        personalityContainerView.addSubview(personalityContainerStack)
        personalityContainerStack.verticalAnchors == personalityContainerView.verticalAnchors + DesignMetrics.Padding.size4
        personalityContainerStack.horizontalAnchors == personalityContainerView.horizontalAnchors + DesignMetrics.Padding.size16
        appendViewToMainVStack(view: personalityContainerView, topPadding: 24)
    }
    
    private func createCircularButton(with backgroundColor: UIColor, buttonImage: UIImage, buttonTag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.setTitle("", for: .normal)
        button.setImage(buttonImage, for: .normal)
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 54).isActive = true
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.tag = buttonTag
        button.addTarget(self, action: #selector(choosePersonalityButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func choosePersonalityButtonTapped(_ sender: UIButton) {
        if(sender.isEnabled) {
            profileImageView.image = personalityImagesArray[sender.tag]
        }
    }
    
    @objc private func seeAllButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        let emojiVC = EmojiViewController(allEmojiArray: personalityAllImagesArray)
        emojiVC.emojiSelectionDelegate = self
        self.navigationController?.pushViewController(emojiVC, animated: true)
    }
    
    
    private func configureFooterView() {
        let footerView = UIView()
        footerView.addSubview(saveButton)
        footerView.backgroundColor = .white
        saveButton.edgeAnchors == footerView.edgeAnchors + DesignMetrics.Padding.size16
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addFooterView(footerView: footerView, height: 93)
    }
    
    @objc func saveButtonTapped() {
        switch createProfileWith {
        case .profileGuestUser:
            if(nameTextField.text == "" || genderTextField.text == "") {
                self.showAlert(on: self, title: "DataBox", message: "Please fill all required fields to proceed.")
                return
            }
        case .profilePhoneNumber:
            
            if(nameTextField.text == "" || genderTextField.text == "") {
                self.showAlert(on: self, title: "DataBox", message: "Please fill all required fields to proceed.")
              return
            }
            
        case .profileGoogle:
            if(nameTextField.text == "" || genderTextField.text == "") {
                self.showAlert(on: self, title: "DataBox", message: "Please fill all required fields to proceed.")
              return
            }
        }
        
        showHomeViewController()
    }
    
    private func showHomeViewController() {
        let homeVC = CustomTabBarController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        // Set HomeViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}


extension CreateProfileViewController: EmojiSelectionViewDelegate {
    func didSelectEmoji(imageTag: Int) {
        profileImageView.image = personalityAllImagesArray[imageTag]
    }
}


enum TitleOfProfile{
    case guestUser
    case phoneNumberOrGoogle
    
    var value:String{
        switch self {
        case .guestUser: return "Create Guest User"
        case .phoneNumberOrGoogle: return "   Create Profile"
        }
    }
}

enum Profile{
    case profileGuestUser
    case profilePhoneNumber
    case profileGoogle
    
    var value:String{
        switch self {
        case .profileGuestUser: return "Create profile with guest"
        case .profilePhoneNumber: return "Create profile with phone number"
        case .profileGoogle: return "Create profile with google"
        }
    }
}
