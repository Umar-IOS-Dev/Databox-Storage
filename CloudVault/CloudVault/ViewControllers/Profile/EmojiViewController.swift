//
//  EmojiViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 18/07/2024.
//

import UIKit
import Anchorage

protocol EmojiSelectionViewDelegate: AnyObject {
    func didSelectEmoji(imageTag: Int)
}

class EmojiViewController: BaseViewController {
    
    private var personalityAllImagesArray = [UIImage]()
    weak var emojiSelectionDelegate: EmojiSelectionViewDelegate?
    
    init(allEmojiArray: [UIImage]) {
        self.personalityAllImagesArray = allEmojiArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "Chose your Personallity", showBackButton: true, hideBackground: true)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        configureTopView()
        configureMiddleView()
        configureBottomView()
    }
    
    private func configureTopView() {
        let choosePersonalityView = UIView()
        choosePersonalityView.backgroundColor = .white
        choosePersonalityView.layer.cornerRadius = DesignMetrics.Padding.size12
        choosePersonalityView.heightAnchor == DesignMetrics.Dimensions.height224
        
        let choosePersonalityStack = UIStackView()
        choosePersonalityStack.axis = .vertical
        choosePersonalityStack.distribution = .equalSpacing
        
        // First Emoji View
        let firstEmojiView = UIView()
        firstEmojiView.backgroundColor = .clear
        firstEmojiView.heightAnchor == 76
        
        let firstEmojiStackView = UIStackView()
        firstEmojiStackView.axis = .horizontal
        firstEmojiStackView.distribution = .equalSpacing
        
        let firstButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.9764705882, green: 0.2274509804, blue: 0.262745098, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[0], buttonTag: 0),
            createCircularButton(with: #colorLiteral(red: 0.9764705882, green: 0.4078431373, blue: 0.2274509804, alpha: 0.1014296344), buttonImage: personalityAllImagesArray[1], buttonTag: 1),
            createCircularButton(with: #colorLiteral(red: 0.9843137255, green: 0.5764705882, blue: 0.04705882353, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[2], buttonTag: 2)
        ]
        
        for button in firstButtons {
            firstEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        firstEmojiView.addSubview(firstEmojiStackView)
        firstEmojiStackView.edgeAnchors == firstEmojiView.edgeAnchors
        
        // Second Emoji View
        let secondEmojiView = UIView()
        secondEmojiView.backgroundColor = .clear
        secondEmojiView.heightAnchor == 76
        
        let secondEmojiStackView = UIStackView()
        secondEmojiStackView.axis = .horizontal
        secondEmojiStackView.distribution = .equalSpacing
        
        let secondButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.8470588235, green: 0.4235294118, blue: 0.3215686275, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[3], buttonTag: 3),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.8352941176, blue: 0.6823529412, alpha: 0.203523597), buttonImage: personalityAllImagesArray[4], buttonTag: 4),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.3607843137, blue: 0.2, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[5], buttonTag: 5)
        ]
        
        for button in secondButtons {
            secondEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        secondEmojiView.addSubview(secondEmojiStackView)
        secondEmojiStackView.edgeAnchors == secondEmojiView.edgeAnchors
        
        choosePersonalityStack.addArrangedSubview(firstEmojiView)
        choosePersonalityStack.addArrangedSubview(secondEmojiView)
        
        choosePersonalityView.addSubview(choosePersonalityStack)
        choosePersonalityStack.edgeAnchors == choosePersonalityView.edgeAnchors + DesignMetrics.Padding.size16
        appendViewToMainVStack(view: choosePersonalityView, topPadding: 24)
    }
    
    private func configureMiddleView() {
        let choosePersonalityView = UIView()
        choosePersonalityView.backgroundColor = .white
        choosePersonalityView.layer.cornerRadius = DesignMetrics.Padding.size12
        choosePersonalityView.heightAnchor == DesignMetrics.Dimensions.height224
        
        let choosePersonalityStack = UIStackView()
        choosePersonalityStack.axis = .vertical
        choosePersonalityStack.distribution = .equalSpacing
        
        // First Emoji View
        let firstEmojiView = UIView()
        firstEmojiView.backgroundColor = .clear
        firstEmojiView.heightAnchor == 76
        
        let firstEmojiStackView = UIStackView()
        firstEmojiStackView.axis = .horizontal
        firstEmojiStackView.distribution = .equalSpacing
        
        let firstButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.9921568627, green: 0.1529411765, blue: 0.4196078431, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[6], buttonTag: 6),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.6117647059, blue: 0.7882352941, alpha: 0.1014296344), buttonImage: personalityAllImagesArray[7], buttonTag: 7),
            createCircularButton(with: #colorLiteral(red: 0.6784313725, green: 0.8117647059, blue: 0.09803921569, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[8], buttonTag: 8)
        ]
        for button in firstButtons {
            firstEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        firstEmojiView.addSubview(firstEmojiStackView)
        firstEmojiStackView.edgeAnchors == firstEmojiView.edgeAnchors
        
        // Second Emoji View
        let secondEmojiView = UIView()
        secondEmojiView.backgroundColor = .clear
        secondEmojiView.heightAnchor == 76
        
        let secondEmojiStackView = UIStackView()
        secondEmojiStackView.axis = .horizontal
        secondEmojiStackView.distribution = .equalSpacing
        
        let secondButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.3333333333, green: 0.8039215686, blue: 0.4117647059, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[9], buttonTag: 9),
            createCircularButton(with: #colorLiteral(red: 0.9607843137, green: 0.5921568627, blue: 0.07450980392, alpha: 0.1030240222), buttonImage: personalityAllImagesArray[10], buttonTag: 10),
            createCircularButton(with: #colorLiteral(red: 0.9254901961, green: 0.2156862745, blue: 0.2705882353, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[11], buttonTag: 11)
        ]
        
        for button in secondButtons {
            secondEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        secondEmojiView.addSubview(secondEmojiStackView)
        secondEmojiStackView.edgeAnchors == secondEmojiView.edgeAnchors
        
        choosePersonalityStack.addArrangedSubview(firstEmojiView)
        choosePersonalityStack.addArrangedSubview(secondEmojiView)
        
        choosePersonalityView.addSubview(choosePersonalityStack)
        choosePersonalityStack.edgeAnchors == choosePersonalityView.edgeAnchors + DesignMetrics.Padding.size16
        appendViewToMainVStack(view: choosePersonalityView, topPadding: 24)
    }
    
    private func configureBottomView() {
        let choosePersonalityView = UIView()
        choosePersonalityView.backgroundColor = .white
        choosePersonalityView.layer.cornerRadius = DesignMetrics.Padding.size12
        choosePersonalityView.heightAnchor == DesignMetrics.Dimensions.height224
        
        let choosePersonalityStack = UIStackView()
        choosePersonalityStack.axis = .vertical
        choosePersonalityStack.distribution = .equalSpacing
        // First Emoji View
        let firstEmojiView = UIView()
        firstEmojiView.backgroundColor = .clear
        firstEmojiView.heightAnchor == 76
        
        let firstEmojiStackView = UIStackView()
        firstEmojiStackView.axis = .horizontal
        firstEmojiStackView.distribution = .equalSpacing
        
        let firstButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 0.6117647059, green: 0.8, blue: 0.3019607843, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[12], buttonTag: 12),
            createCircularButton(with: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), buttonImage: personalityAllImagesArray[13], buttonTag: 13),
            createCircularButton(with: #colorLiteral(red: 0.7882352941, green: 0.4352941176, blue: 0.1960784314, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[14], buttonTag: 14)
        ]
        
        for button in firstButtons {
            firstEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        firstEmojiView.addSubview(firstEmojiStackView)
        firstEmojiStackView.edgeAnchors == firstEmojiView.edgeAnchors
        // Second Emoji View
        let secondEmojiView = UIView()
        secondEmojiView.backgroundColor = .clear
        secondEmojiView.heightAnchor == 76
        
        let secondEmojiStackView = UIStackView()
        secondEmojiStackView.axis = .horizontal
        secondEmojiStackView.distribution = .equalSpacing
        
        let secondButtons: [UIButton] = [
            createCircularButton(with: #colorLiteral(red: 1, green: 0.4431372549, blue: 0.4980392157, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[15], buttonTag: 15),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.4431372549, blue: 0.4980392157, alpha: 0.09802827387), buttonImage: personalityAllImagesArray[16], buttonTag: 16),
            createCircularButton(with: #colorLiteral(red: 1, green: 0.4431372549, blue: 0.4980392157, alpha: 0.09988839286), buttonImage: personalityAllImagesArray[17], buttonTag: 17)
        ]
        
        for button in secondButtons {
            secondEmojiStackView.addArrangedSubview(button)
            button.widthAnchor == 76
            button.heightAnchor == 76
        }
        
        secondEmojiView.addSubview(secondEmojiStackView)
        secondEmojiStackView.edgeAnchors == secondEmojiView.edgeAnchors
        
        choosePersonalityStack.addArrangedSubview(firstEmojiView)
        choosePersonalityStack.addArrangedSubview(secondEmojiView)
        
        choosePersonalityView.addSubview(choosePersonalityStack)
        choosePersonalityStack.edgeAnchors == choosePersonalityView.edgeAnchors + DesignMetrics.Padding.size16
        
        appendViewToMainVStack(view: choosePersonalityView, topPadding: 24)
    }
    
    private func createCircularButton(with backgroundColor: UIColor, buttonImage: UIImage, buttonTag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.setTitle("", for: .normal)
        button.setImage(buttonImage, for: .normal)
        button.layer.cornerRadius = 38
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 76).isActive = true
        button.heightAnchor.constraint(equalToConstant: 76).isActive = true
        button.tag = buttonTag
        button.addTarget(self, action: #selector(choosePersonalityButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func choosePersonalityButtonTapped(_ sender: UIButton) {
        
        emojiSelectionDelegate?.didSelectEmoji(imageTag: sender.tag)
        self.navigationController?.popViewController(animated: true)
    }
}
