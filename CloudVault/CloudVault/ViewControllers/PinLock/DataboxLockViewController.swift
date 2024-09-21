//
//  DataboxLockViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/09/2024.
//

import UIKit
import Anchorage

class DataboxLockViewController: BaseViewController {
    
    let spacer4View = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "Databox Lock", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
       setupMainView()
    }
    
    private func setupMainView() {
        let mainView = UIView()
        mainView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        mainView.layer.cornerRadius = DesignMetrics.Padding.size12
        mainView.heightAnchor == 500
        
        let mainVStackView = UIStackView()
        mainVStackView.axis = .vertical
        mainVStackView.spacing = 10
        
        let dataLockImageView = UIImageView()
        dataLockImageView.contentMode = .scaleAspectFit
        dataLockImageView.backgroundColor = .clear
        dataLockImageView.image = UIImage(named: "databoxLockImage")
        dataLockImageView.heightAnchor == 200
        
        let headerLabel = UILabel()
        headerLabel.text = "Protect Your Databox"
        headerLabel.textColor = UIColor(named: "appPrimaryTextColor")
        headerLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 22)
        headerLabel.heightAnchor == 22
         
        let spacer8View = UIView()
        spacer8View.backgroundColor = .clear
        spacer8View.heightAnchor == 8
        
       // let spacer4View = UIView()
        spacer4View.backgroundColor = .clear
        spacer4View.heightAnchor == 4
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Contrary to popular belief, Lorem Ipsum is not simply\nrandom text. It has roots in a piece of classical Latin literature from 45"
        descriptionLabel.textColor = UIColor(named: "appPrimaryTextColor")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        descriptionLabel.heightAnchor == 48
        
        
        let SecondaryHeaderLabel = UILabel()
        SecondaryHeaderLabel.text = "Chose Security Type to secure databox"
        SecondaryHeaderLabel.textColor = UIColor(named: "appPrimaryTextColor")
        SecondaryHeaderLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        SecondaryHeaderLabel.heightAnchor == 16
        
        let pinView = UIView()
        pinView.backgroundColor = UIColor(named: "termsButtonColor")
        pinView.layer.cornerRadius = 8
        pinView.heightAnchor == 56
        
        let faceIdView = UIView()
        faceIdView.backgroundColor = UIColor(named: "termsButtonColor")
        faceIdView.layer.cornerRadius = 8
        faceIdView.heightAnchor == 56
        
        
        
        
        mainVStackView.addArrangedSubview(dataLockImageView)
        mainVStackView.addArrangedSubview(headerLabel)
        mainVStackView.addArrangedSubview(descriptionLabel)
        mainVStackView.addArrangedSubview(spacer8View)
        mainVStackView.addArrangedSubview(SecondaryHeaderLabel)
        mainVStackView.addArrangedSubview(spacer4View)
        mainVStackView.addArrangedSubview(pinView)
        mainVStackView.addArrangedSubview(spacer4View)
        mainVStackView.addArrangedSubview(faceIdView)
        
        mainView.addSubview(mainVStackView)
        mainVStackView.edgeAnchors == mainView.edgeAnchors + 16
        
        appendViewToMainVStack(view: mainView, topPadding: 20)
    }

    

}
