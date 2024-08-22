//
//  StorageViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 08/08/2024.
//

import UIKit
import Anchorage

class StorageViewController: BaseViewController {
    private let topView: UIView = {
        let topView = UIView()
        topView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topView.layer.cornerRadius = DesignMetrics.Padding.size12
        topView.heightAnchor == 600
        return topView
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .clear//#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bottomView.layer.cornerRadius = DesignMetrics.Padding.size12
        bottomView.heightAnchor == 200
        return bottomView
    }()
   
    private let purchaseStorageButton: UIButton = {
        let purchaseStorageButton = UIButton()
        purchaseStorageButton.backgroundColor = .clear
        purchaseStorageButton.contentMode = .scaleAspectFill
        purchaseStorageButton.setImage(UIImage(named: "get100GBStorageImage"), for: .normal)
        return purchaseStorageButton
    }()
    private let currentStorageLabel: UILabel = {
        let currentStorageLabel = UILabel()
        currentStorageLabel.textAlignment = .right
        currentStorageLabel.textColor =  #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
       // currentStorageLabel.backgroundColor = .orange
        currentStorageLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 100)
        currentStorageLabel.adjustsFontSizeToFitWidth = true
        return currentStorageLabel
    }()
    private let percentSignLabel: UILabel = {
        let percentSignLabel = UILabel()
        percentSignLabel.textAlignment = .left
        percentSignLabel.textColor =  #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
       // percentSignLabel.backgroundColor = .red
        percentSignLabel.text = "%"
        percentSignLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 56)
        percentSignLabel.adjustsFontSizeToFitWidth = true
        return percentSignLabel
    }()
    private let storageSubLabel: UILabel = {
        let storageSubLabel = UILabel()
        storageSubLabel.textAlignment = .center
        storageSubLabel.textColor =  #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
       // percentSignLabel.backgroundColor = .red
        storageSubLabel.text = "Storage are in your used"
        storageSubLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        return storageSubLabel
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI(title: "Databox Storage", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        self.configureTopView()
        self.configureBottomView()
    }
    
    private func configureTopView() {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = DesignMetrics.Padding.size8
        
        let currentStorageView = UIStackView()
        currentStorageView.backgroundColor = .clear
        
        let currentStorageStackView = UIStackView()
        currentStorageStackView.axis = .horizontal
        currentStorageStackView.spacing = 0
        currentStorageStackView.backgroundColor = .clear
        currentStorageStackView.heightAnchor == 140
        
        currentStorageLabel.text = "40"
        percentSignLabel.widthAnchor == 70
        
        currentStorageStackView.addArrangedSubview(currentStorageLabel)
        currentStorageStackView.addArrangedSubview(percentSignLabel)
        
        currentStorageView.addSubview(currentStorageStackView)
        currentStorageStackView.verticalAnchors == currentStorageView.verticalAnchors
        currentStorageStackView.widthAnchor == 200
        currentStorageStackView.centerXAnchor == currentStorageView.centerXAnchor + 16
      //  currentStorageStackView.backgroundColor = .red
        
        let storageUsedView = UIStackView()
        storageUsedView.backgroundColor =  #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        storageUsedView.layer.cornerRadius = 18
        
        let storageUsedLabel = UILabel()
        let firstPartText = "40 GB "
        let secondPartText = "Data are used from "
        let thirdPartText = "100 GB"
        let completeText = "40 GB Data are used from 100 GB"
        storageUsedLabel.textAlignment = .center
        storageUsedLabel.attributedText = completeText.styledStringWithThreeParts(firstPart: firstPartText, secondPart: secondPartText, thirdPart: thirdPartText)
        storageUsedView.addSubview(storageUsedLabel)
        storageUsedLabel.edgeAnchors == storageUsedView.edgeAnchors + 4
        
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        
        let insightsDataStackView = UIStackView()
        insightsDataStackView.axis = .vertical
        insightsDataStackView.spacing = 12
        
        let insightDataSizeHStackView = UIStackView()
        insightDataSizeHStackView.axis = .horizontal
        insightDataSizeHStackView.distribution = .fillEqually
        insightDataSizeHStackView.spacing = 8
        
        let imagesDataSizeLabel = UILabel()
        imagesDataSizeLabel.text = "16GB"
        //imagesDataSizeLabel.backgroundColor = .black
        imagesDataSizeLabel.textAlignment = .center
        imagesDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        imagesDataSizeLabel.textColor = #colorLiteral(red: 1, green: 0.631372549, blue: 0.2941176471, alpha: 1)
        
        let audiosDataSizeLabel = UILabel()
        audiosDataSizeLabel.text = "10GB"
       // audiosDataSizeLabel.backgroundColor = .black
        audiosDataSizeLabel.textAlignment = .center
        audiosDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        audiosDataSizeLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.4196078431, blue: 0.9215686275, alpha: 1)
        
        let contactsDataSizeLabel = UILabel()
        contactsDataSizeLabel.text = "05GB"
       // contactsDataSizeLabel.backgroundColor = .black
        contactsDataSizeLabel.textAlignment = .center
        contactsDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        contactsDataSizeLabel.textColor = #colorLiteral(red: 0.2745098039, green: 0.8666666667, blue: 0.2980392157, alpha: 1)
        
        let filesDataSizeLabel = UILabel()
        filesDataSizeLabel.text = "14GB"
       // filesDataSizeLabel.backgroundColor = .black
        filesDataSizeLabel.textAlignment = .center
        filesDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        filesDataSizeLabel.textColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0.3450980392, alpha: 1)
        
        let videosDataSizeLabel = UILabel()
        videosDataSizeLabel.text = "08GB"
      //  videosDataSizeLabel.backgroundColor = .black
        videosDataSizeLabel.textAlignment = .center
        videosDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        videosDataSizeLabel.textColor = #colorLiteral(red: 0.3098039216, green: 0.768627451, blue: 0.9137254902, alpha: 1)
        
        let documentsDataSizeLabel = UILabel()
        documentsDataSizeLabel.text = "11GB"
       // documentsDataSizeLabel.backgroundColor = .black
        documentsDataSizeLabel.textAlignment = .center
        documentsDataSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 10)
        documentsDataSizeLabel.textColor = #colorLiteral(red: 0.9843137255, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
        
        insightDataSizeHStackView.addArrangedSubview(imagesDataSizeLabel)
        //imagesDataSizeLabel.widthAnchor == 24
        insightDataSizeHStackView.addArrangedSubview(audiosDataSizeLabel)
        //audiosDataSizeLabel.widthAnchor == 24
        insightDataSizeHStackView.addArrangedSubview(contactsDataSizeLabel)
        //contactsDataSizeLabel.widthAnchor == 24
        insightDataSizeHStackView.addArrangedSubview(filesDataSizeLabel)
        //filesDataSizeLabel.widthAnchor == 24
        insightDataSizeHStackView.addArrangedSubview(videosDataSizeLabel)
        //videosDataSizeLabel.widthAnchor == 24
        insightDataSizeHStackView.addArrangedSubview(documentsDataSizeLabel)
       // documentsDataSizeLabel.widthAnchor == 24
        
        let insightGraphStackView = UIStackView()
        insightGraphStackView.axis = .horizontal
        insightGraphStackView.distribution = .fillEqually
        insightGraphStackView.spacing = 8
        
        
        let imagesGraphContainerView = UIView()
        let audiosGraphContainerView = UIView()
        let contactsGraphContainerView = UIView()
        let filesGraphContainerView = UIView()
        let videosGraphContainerView = UIView()
        let documentsGraphContainerView = UIView()
        
        let imagesGraphView = StorageVerticalUsageView(filledPercentage: 54, graphViewColor: #colorLiteral(red: 1, green: 0.3176470588, blue: 0.09803921569, alpha: 0.09970238095), filledColor: #colorLiteral(red: 1, green: 0.631372549, blue: 0.2941176471, alpha: 1))
        
        let audiosGraphView = StorageVerticalUsageView(filledPercentage: 34, graphViewColor: #colorLiteral(red: 0.9098039216, green: 0.4196078431, blue: 0.9215686275, alpha: 0.1031834609), filledColor: #colorLiteral(red: 0.9098039216, green: 0.4196078431, blue: 0.9215686275, alpha: 1))
        
        let contactsGraphView = StorageVerticalUsageView(filledPercentage: 10, graphViewColor: #colorLiteral(red: 0.2745098039, green: 0.8666666667, blue: 0.2980392157, alpha: 0.1), filledColor: #colorLiteral(red: 0.2745098039, green: 0.8666666667, blue: 0.2980392157, alpha: 1))
        
        let filesGraphView = StorageVerticalUsageView(filledPercentage: 70, graphViewColor: #colorLiteral(red: 1, green: 0.8156862745, blue: 0.3450980392, alpha: 0.1), filledColor: #colorLiteral(red: 1, green: 0.8156862745, blue: 0.3450980392, alpha: 1))
        
        let videosGraphView = StorageVerticalUsageView(filledPercentage: 30, graphViewColor: #colorLiteral(red: 0.3098039216, green: 0.768627451, blue: 0.9137254902, alpha: 0.1), filledColor: #colorLiteral(red: 0.3098039216, green: 0.768627451, blue: 0.9137254902, alpha: 1))
        
        let documentsGraphView = StorageVerticalUsageView(filledPercentage: 47, graphViewColor: #colorLiteral(red: 0.9843137255, green: 0.4470588235, blue: 0.4470588235, alpha: 0.1), filledColor: #colorLiteral(red: 0.9843137255, green: 0.4470588235, blue: 0.4470588235, alpha: 1))
        
        
        imagesGraphContainerView.addSubview(imagesGraphView)
        imagesGraphView.widthAnchor == 24
        imagesGraphView.topAnchor == imagesGraphContainerView.topAnchor
        imagesGraphView.bottomAnchor == imagesGraphContainerView.bottomAnchor
        imagesGraphView.centerXAnchor == imagesGraphContainerView.centerXAnchor
        
        audiosGraphContainerView.addSubview(audiosGraphView)
        audiosGraphView.widthAnchor == 24
        audiosGraphView.topAnchor == audiosGraphContainerView.topAnchor
        audiosGraphView.bottomAnchor == audiosGraphContainerView.bottomAnchor
        audiosGraphView.centerXAnchor == audiosGraphContainerView.centerXAnchor
        
        contactsGraphContainerView.addSubview(contactsGraphView)
        contactsGraphView.widthAnchor == 24
        contactsGraphView.topAnchor == contactsGraphContainerView.topAnchor
        contactsGraphView.bottomAnchor == contactsGraphContainerView.bottomAnchor
        contactsGraphView.centerXAnchor == contactsGraphContainerView.centerXAnchor
        
        filesGraphContainerView.addSubview(filesGraphView)
        filesGraphView.widthAnchor == 24
        filesGraphView.topAnchor == filesGraphContainerView.topAnchor
        filesGraphView.bottomAnchor == filesGraphContainerView.bottomAnchor
        filesGraphView.centerXAnchor == filesGraphContainerView.centerXAnchor
        
        videosGraphContainerView.addSubview(videosGraphView)
        videosGraphView.widthAnchor == 24
        videosGraphView.topAnchor == videosGraphContainerView.topAnchor
        videosGraphView.bottomAnchor == videosGraphContainerView.bottomAnchor
        videosGraphView.centerXAnchor == videosGraphContainerView.centerXAnchor
        
        documentsGraphContainerView.addSubview(documentsGraphView)
        documentsGraphView.widthAnchor == 24
        documentsGraphView.topAnchor == documentsGraphContainerView.topAnchor
        documentsGraphView.bottomAnchor == documentsGraphContainerView.bottomAnchor
        documentsGraphView.centerXAnchor == documentsGraphContainerView.centerXAnchor
        
        
        insightGraphStackView.addArrangedSubview(imagesGraphContainerView)
        imagesGraphContainerView.heightAnchor == 238
//        imagesGraphView.widthAnchor == 24
        
        insightGraphStackView.addArrangedSubview(audiosGraphContainerView)
        audiosGraphContainerView.heightAnchor == 238
//        audiosGraphView.widthAnchor == 24
       
        insightGraphStackView.addArrangedSubview(contactsGraphContainerView)
        contactsGraphContainerView.heightAnchor == 238
//        contactsGraphView.widthAnchor == 24
        
        insightGraphStackView.addArrangedSubview(filesGraphContainerView)
        filesGraphContainerView.heightAnchor == 238
//        filesGraphView.widthAnchor == 24
        
        insightGraphStackView.addArrangedSubview(videosGraphContainerView)
        videosGraphContainerView.heightAnchor == 238
//        videosGraphView.widthAnchor == 24
        
        insightGraphStackView.addArrangedSubview(documentsGraphContainerView)
        documentsGraphContainerView.heightAnchor == 238
//        documentsGraphView.widthAnchor == 24
        
        let imagesLabel = UILabel()
        imagesLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        imagesLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        imagesLabel.textAlignment = .center
        imagesLabel.adjustsFontSizeToFitWidth = true
      //  imagesLabel.minimumScaleFactor = 0.5
        imagesLabel.text = "Images"
        
        let audiosLabel = UILabel()
        audiosLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        audiosLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        audiosLabel.textAlignment = .center
        audiosLabel.adjustsFontSizeToFitWidth = true
     //   audiosLabel.minimumScaleFactor = 0.5
        audiosLabel.text = "Audio"
        
        let contactsLabel = UILabel()
        contactsLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        contactsLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        contactsLabel.textAlignment = .center
        contactsLabel.adjustsFontSizeToFitWidth = true
     //   contactsLabel.minimumScaleFactor = 0.5
        contactsLabel.text = "Contacts"
        
        let filesLabel = UILabel()
        filesLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        filesLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        filesLabel.textAlignment = .center
        filesLabel.adjustsFontSizeToFitWidth = true
       // filesLabel.minimumScaleFactor = 0.5
        filesLabel.text = "Files"
        
        let videosLabel = UILabel()
        videosLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        videosLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        videosLabel.textAlignment = .center
        videosLabel.adjustsFontSizeToFitWidth = true
       // videosLabel.minimumScaleFactor = 0.5
        videosLabel.text = "Videos"
        
        let documentsLabel = UILabel()
        documentsLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 11)
        documentsLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        documentsLabel.textAlignment = .center
        documentsLabel.adjustsFontSizeToFitWidth = true
       // documentsLabel.minimumScaleFactor = 0.5
        documentsLabel.text = "Document"
        
        let insightDataLebelHStackView = UIStackView()
        insightDataLebelHStackView.axis = .horizontal
        insightDataLebelHStackView.distribution = .fillEqually
        insightDataLebelHStackView.spacing = 8
        
        insightDataLebelHStackView.addArrangedSubview(imagesLabel)
        insightDataLebelHStackView.addArrangedSubview(audiosLabel)
        insightDataLebelHStackView.addArrangedSubview(contactsLabel)
        insightDataLebelHStackView.addArrangedSubview(filesLabel)
        insightDataLebelHStackView.addArrangedSubview(videosLabel)
        insightDataLebelHStackView.addArrangedSubview(documentsLabel)
        
        let imagesCountLabel = UILabel()
        imagesCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        imagesCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        imagesCountLabel.textAlignment = .center
        imagesCountLabel.text = "10"
        
        let audiosCountLabel = UILabel()
        audiosCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        audiosCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        audiosCountLabel.textAlignment = .center
        audiosCountLabel.text = "08"
        
        let contactsCountLabel = UILabel()
        contactsCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        contactsCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        contactsCountLabel.textAlignment = .center
        contactsCountLabel.text = "09"
        
        let filesCountLabel = UILabel()
        filesCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        filesCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        filesCountLabel.textAlignment = .center
        filesCountLabel.text = "06"
        
        let videosCountLabel = UILabel()
        videosCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        videosCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        videosCountLabel.textAlignment = .center
        videosCountLabel.text = "11"
        
        let documentsCountLabel = UILabel()
        documentsCountLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 8)
        documentsCountLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5984534439)
        documentsCountLabel.textAlignment = .center
        documentsCountLabel.text = "07"
        
        
        let insightCountLebelHStackView = UIStackView()
        insightCountLebelHStackView.axis = .horizontal
        insightCountLebelHStackView.distribution = .fillEqually
        insightCountLebelHStackView.spacing = 8
        
        insightCountLebelHStackView.addArrangedSubview(imagesCountLabel)
        insightCountLebelHStackView.addArrangedSubview(audiosCountLabel)
        insightCountLebelHStackView.addArrangedSubview(contactsCountLabel)
        insightCountLebelHStackView.addArrangedSubview(filesCountLabel)
        insightCountLebelHStackView.addArrangedSubview(videosCountLabel)
        insightCountLebelHStackView.addArrangedSubview(documentsCountLabel)
        
        let imagesRoundedView = UIView()
        imagesRoundedView.layer.cornerRadius = 6
        imagesRoundedView.backgroundColor = #colorLiteral(red: 1, green: 0.631372549, blue: 0.2941176471, alpha: 1)
        
        let audiosRoundedView = UIView()
        audiosRoundedView.layer.cornerRadius = 6
        audiosRoundedView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.4196078431, blue: 0.9215686275, alpha: 1)
        
        let contactsRoundedView = UIView()
        contactsRoundedView.layer.cornerRadius = 6
        contactsRoundedView.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.8666666667, blue: 0.2980392157, alpha: 1)
        
        let filesRoundedView = UIView()
        filesRoundedView.layer.cornerRadius = 6
        filesRoundedView.backgroundColor = #colorLiteral(red: 1, green: 0.8156862745, blue: 0.3450980392, alpha: 1)
        
        let videosRoundedView = UIView()
        videosRoundedView.layer.cornerRadius = 6
        videosRoundedView.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.768627451, blue: 0.9137254902, alpha: 1)
        
        let documentsRoundedView = UIView()
        documentsRoundedView.layer.cornerRadius = 6
        documentsRoundedView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
        
        let imagesRoundedContainerView = UIView()
        let audiosRoundedContainerView = UIView()
        let contactsRoundedContainerView = UIView()
        let filesRoundedContainerView = UIView()
        let videosRoundedContainerView = UIView()
        let documentsRoundedContainerView = UIView()
        
        imagesRoundedContainerView.addSubview(imagesRoundedView)
        imagesRoundedView.heightAnchor == 12
        imagesRoundedView.widthAnchor == 12
        imagesRoundedView.centerAnchors == imagesRoundedContainerView.centerAnchors
        
        audiosRoundedContainerView.addSubview(audiosRoundedView)
        audiosRoundedView.heightAnchor == 12
        audiosRoundedView.widthAnchor == 12
        audiosRoundedView.centerAnchors == audiosRoundedContainerView.centerAnchors
        
        contactsRoundedContainerView.addSubview(contactsRoundedView)
        contactsRoundedView.heightAnchor == 12
        contactsRoundedView.widthAnchor == 12
        contactsRoundedView.centerAnchors == contactsRoundedContainerView.centerAnchors
        
        filesRoundedContainerView.addSubview(filesRoundedView)
        filesRoundedView.heightAnchor == 12
        filesRoundedView.widthAnchor == 12
        filesRoundedView.centerAnchors == filesRoundedContainerView.centerAnchors
        
        videosRoundedContainerView.addSubview(videosRoundedView)
        videosRoundedView.heightAnchor == 12
        videosRoundedView.widthAnchor == 12
        videosRoundedView.centerAnchors == videosRoundedContainerView.centerAnchors
        
        documentsRoundedContainerView.addSubview(documentsRoundedView)
        documentsRoundedView.heightAnchor == 12
        documentsRoundedView.widthAnchor == 12
        documentsRoundedView.centerAnchors == documentsRoundedContainerView.centerAnchors
        
        let insightRoundedHStackView = UIStackView()
        insightRoundedHStackView.axis = .horizontal
        insightRoundedHStackView.distribution = .fillEqually
        insightRoundedHStackView.spacing = 8
        
        insightRoundedHStackView.addArrangedSubview(imagesRoundedContainerView)
        imagesRoundedView.heightAnchor == 12
        insightRoundedHStackView.addArrangedSubview(audiosRoundedContainerView)
        audiosRoundedView.heightAnchor == 12
        insightRoundedHStackView.addArrangedSubview(contactsRoundedContainerView)
        contactsRoundedView.heightAnchor == 12
        insightRoundedHStackView.addArrangedSubview(filesRoundedContainerView)
        filesRoundedView.heightAnchor == 12
        insightRoundedHStackView.addArrangedSubview(videosRoundedContainerView)
        videosRoundedView.heightAnchor == 12
        insightRoundedHStackView.addArrangedSubview(documentsRoundedContainerView)
        documentsRoundedView.heightAnchor == 12
        
        
        insightsDataStackView.addArrangedSubview(insightDataSizeHStackView)
        insightsDataStackView.addArrangedSubview(insightGraphStackView)
        insightsDataStackView.addArrangedSubview(insightDataLebelHStackView)
        insightsDataStackView.addArrangedSubview(insightCountLebelHStackView)
        insightsDataStackView.addArrangedSubview(insightRoundedHStackView)
        
        
        let tempView = UIView()
        tempView.backgroundColor = .lightGray
        
        containerStackView.addArrangedSubview(currentStorageView)
        containerStackView.addArrangedSubview(storageSubLabel)
        containerStackView.addArrangedSubview(storageUsedView)
        containerStackView.addArrangedSubview(spacerView)
        containerStackView.addArrangedSubview(insightsDataStackView)
        containerStackView.addArrangedSubview(tempView)
        
        
        storageUsedView.heightAnchor == 36
        storageUsedView.leadingAnchor == containerStackView.leadingAnchor + 8
        storageUsedView.trailingAnchor == containerStackView.trailingAnchor - 8
        spacerView.heightAnchor == 16
        //insightsDataStackView.heightAnchor == 280
        
        
        topView.addSubview(containerStackView)
        //containerStackView.edgeAnchors == topView.edgeAnchors + 8
        containerStackView.topAnchor == topView.topAnchor + 8
        containerStackView.leadingAnchor == topView.leadingAnchor
        containerStackView.trailingAnchor == topView.trailingAnchor - 8
        containerStackView.bottomAnchor == topView.bottomAnchor - 8
        
        
        appendViewToMainVStack(view: topView, topPadding: 24)
    }
    
    private func configureBottomView() {
        bottomView.addSubview(purchaseStorageButton)
        purchaseStorageButton.addTarget(self, action: #selector(purchaseStorageButtonTapped(_:)), for: .touchUpInside)
        purchaseStorageButton.topAnchor == bottomView.topAnchor - 28
        purchaseStorageButton.leadingAnchor == bottomView.leadingAnchor - 30
        purchaseStorageButton.trailingAnchor == bottomView.trailingAnchor - 10
        purchaseStorageButton.bottomAnchor == bottomView.bottomAnchor - 28
        appendViewToMainVStack(view: bottomView)
    }
    
    @objc private func purchaseStorageButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("purchaseStorageButton Tapped")
    }
    
}
