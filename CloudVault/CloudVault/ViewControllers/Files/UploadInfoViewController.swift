//
//  UploadInfoViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 06/08/2024.
//

import UIKit
import Anchorage


class UploadInfoViewController: BaseViewController {

    private let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topView.layer.cornerRadius = DesignMetrics.Padding.size12
        topView.heightAnchor == 500
        return topView
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        bottomView.layer.cornerRadius = DesignMetrics.Padding.size12
        bottomView.heightAnchor == 200
        return bottomView
    }()
   
    private let purchaseStorageButton: UIButton = {
        let purchaseImageView = UIButton()
        purchaseImageView.backgroundColor = .clear
        purchaseImageView.contentMode = .scaleAspectFill
        purchaseImageView.setImage(UIImage(named: "purchaseStorageImage"), for: .normal)
        return purchaseImageView
    }()
    private let currentPercentLabel: UILabel = {
        let currentPercentLabel = UILabel()
        currentPercentLabel.textAlignment = .center
        currentPercentLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        currentPercentLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 80)
        return currentPercentLabel
    }()
    private var timer: Timer?
    private var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureUI(title: "Upload to Databox", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
        
        startUpdatingLabel()
        showProgress()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        self.configureTopView()
        self.configureBottomView()
    }

    private func configureTopView() {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = DesignMetrics.Padding.size8
        
        let fileNameLabel = UILabel()
        fileNameLabel.textAlignment = .center
        fileNameLabel.textColor = #colorLiteral(red: 0.3176470588, green: 0.3607843137, blue: 0.4235294118, alpha: 1)
        fileNameLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        fileNameLabel.text = "File Name"
        fileNameLabel.heightAnchor == DesignMetrics.Dimensions.height24
        
        let fileNameSubLabel = UILabel()
        fileNameSubLabel.textAlignment = .center
        fileNameSubLabel.textColor = #colorLiteral(red: 0.3176470588, green: 0.3607843137, blue: 0.4235294118, alpha: 1)
        fileNameSubLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 16)
        fileNameSubLabel.text = "All images upload to databox"
        fileNameSubLabel.heightAnchor == DesignMetrics.Dimensions.height20
        
        let uploadImageView = UIImageView()
        uploadImageView.backgroundColor = .clear
        uploadImageView.contentMode = .scaleAspectFit
        uploadImageView.image = UIImage(named: "documentUploadImage")
        uploadImageView.heightAnchor == DesignMetrics.Dimensions.height244
        uploadImageView.widthAnchor == DesignMetrics.Dimensions.width244
        
        let percentageStackView = UIStackView()
        percentageStackView.axis = .horizontal
        percentageStackView.spacing = 0
        
        currentPercentLabel.text = "\(counter)/"
        
        let totalPercentLabel = UILabel()
        totalPercentLabel.textAlignment = .left
        totalPercentLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        totalPercentLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 36)
        totalPercentLabel.text = "100%"
        
        let sizeInfoLabel = UILabel()
        sizeInfoLabel.textAlignment = .center
        sizeInfoLabel.textColor = #colorLiteral(red: 0.3176470588, green: 0.3607843137, blue: 0.4235294118, alpha: 1)
        sizeInfoLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        sizeInfoLabel.text = "40MB Data remains from 45MB"
        sizeInfoLabel.heightAnchor == DesignMetrics.Dimensions.height16
        
        let cancelButtonView = UIView()
        cancelButtonView.backgroundColor = .clear
        cancelButtonView.heightAnchor == DesignMetrics.Dimensions.height48
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.3882352941, alpha: 0.08346619898)
        cancelButton.setTitle("Cancel Uploading", for: .normal)
        cancelButton.setFont(FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 14), for: .normal)
        let titleColorForButton = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
        cancelButton.setTitleColor(titleColorForButton, for: .normal)
        cancelButton.heightAnchor == DesignMetrics.Dimensions.height48
        cancelButton.widthAnchor == DesignMetrics.Dimensions.width190
        cancelButton.layer.cornerRadius = 24
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        
        cancelButtonView.addSubview(cancelButton)
        cancelButton.centerAnchors == cancelButtonView.centerAnchors
        
        percentageStackView.addArrangedSubview(currentPercentLabel)
        percentageStackView.addArrangedSubview(totalPercentLabel)
        
        let percentageContainerView = UIView()
        percentageContainerView.backgroundColor = .clear
       
        percentageContainerView.addSubview(percentageStackView)
        percentageStackView.verticalAnchors == percentageContainerView.verticalAnchors
        percentageStackView.widthAnchor == DesignMetrics.Dimensions.width272
        percentageStackView.centerXAnchor == percentageContainerView.centerXAnchor
        
        containerStackView.addArrangedSubview(fileNameLabel)
        containerStackView.addArrangedSubview(fileNameSubLabel)
        containerStackView.addArrangedSubview(uploadImageView)
        containerStackView.addArrangedSubview(percentageContainerView)
        containerStackView.addArrangedSubview(sizeInfoLabel)
        containerStackView.addArrangedSubview(cancelButtonView)
        
        topView.addSubview(containerStackView)
        containerStackView.edgeAnchors == topView.edgeAnchors + 8
        
        appendViewToMainVStack(view: topView, topPadding: 24)
    }
    
    private func configureBottomView() {
        bottomView.addSubview(purchaseStorageButton)
        purchaseStorageButton.addTarget(self, action: #selector(purchaseStorageButtonTapped(_:)), for: .touchUpInside)
        purchaseStorageButton.edgeAnchors == bottomView.edgeAnchors
        appendViewToMainVStack(view: bottomView)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("Cancel upload Tapped")
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func purchaseStorageButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("purchaseStorageButton Tapped")
    }
    
   
    
    private func startUpdatingLabel() {
        // Timer interval is calculated as 3 seconds divided by 100 updates
        let interval = 5.0 / 100.0
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLabel() {
        currentPercentLabel.text = "\(counter)/"
        counter += 1

        if counter > 100 {
            timer?.invalidate()
            timer = nil
            notifyCompletion()
        }
    }

    private func notifyCompletion() {
        // Perform the notification action here
        hideProgress()
        print("Label text reached 100")
        let cardVC = OtpSuccessViewController(title: "Uploading Completed", subTitle: "All data that you selected successfully upload to databox", buttonTitle: "Cancel", loginAsGuest: true, createProfileWith: .profileGoogle, isButtonHidden: true, successViewHeight: 340)
        
        let transitionDelegate = CardTransitioningDelegate()
        cardVC.transitioningDelegate = transitionDelegate
        cardVC.modalPresentationStyle = .custom
        cardVC.delegate = self
        present(cardVC, animated: true, completion: nil)
        print("goto Main ViewController")
    }
}

extension UploadInfoViewController: OtpSuccesCardControllerDelegate {
    func showContent() {
        
    }
}
