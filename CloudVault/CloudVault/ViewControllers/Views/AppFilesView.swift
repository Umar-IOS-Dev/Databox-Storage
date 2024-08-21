//
//  AppFilesView.swift
//  CloudVault
//
//  Created by Appinators Technology on 23/07/2024.
//

import UIKit
import Anchorage

class AppFilesView: CustomRoundedView {
    private let fileImageView: UIImageView = {
        let fileImageView = UIImageView()
        fileImageView.contentMode = .scaleAspectFit
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        return fileImageView
    }()
    
    private let fileTitleLabel: UILabel = {
        let fileTitleLabel = UILabel()
        fileTitleLabel.textAlignment = .center
        fileTitleLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        fileTitleLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        return fileTitleLabel
    }()
    
    private let fileCounterLabel: UILabel = {
        let fileCounterLabel = UILabel()
        fileCounterLabel.textAlignment = .center
        fileCounterLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        fileCounterLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        return fileCounterLabel
    }()
    
    private let fileSizeLabel: UILabel = {
        let fileSizeLabel = UILabel()
        fileSizeLabel.textAlignment = .left
        fileSizeLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        fileSizeLabel.text = "00GB"
        return fileSizeLabel
    }()
    
    init(fileImage: UIImage, titleOfFile: String, totalCount: String, totalSize: String, labelColor: UIColor) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupFilesView(fileImage: fileImage, titleOfFile: titleOfFile, totalCount: totalCount, totalSize: totalSize, labelColor: labelColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupFilesView(fileImage: UIImage, titleOfFile: String, totalCount: String, totalSize: String, labelColor: UIColor) {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        
        let fileView = UIView()
        fileView.backgroundColor = .clear
        
        let fileSizeView = UIView()
        fileSizeView.widthAnchor == 20
        fileSizeView.backgroundColor = .clear
        
        let fileSizeLabel = UILabel()
        fileSizeLabel.textAlignment = .right
        fileSizeLabel.textColor = labelColor
        fileSizeLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12)
        fileSizeLabel.text = totalSize
        
        fileSizeView.addSubview(fileSizeLabel)
        fileSizeLabel.topAnchor == fileSizeView.topAnchor + 12
        fileSizeLabel.trailingAnchor == fileSizeView.trailingAnchor
        
        let fileStackView = UIStackView()
        fileStackView.axis = .vertical
        fileStackView.spacing = DesignMetrics.Padding.size8
        
        fileImageView.heightAnchor == 36
        fileImageView.widthAnchor == 36
        fileImageView.image = fileImage//.withRenderingMode(.alwaysTemplate)
       // fileImageView.tintColor = labelColor
        
        fileTitleLabel.text = titleOfFile
        fileCounterLabel.text = totalCount
        
        
        
        fileStackView.addArrangedSubview(fileImageView)
        fileStackView.addArrangedSubview(fileTitleLabel)
        fileStackView.addArrangedSubview(fileCounterLabel)
        
        fileView.addSubview(fileStackView)
        fileStackView.horizontalAnchors == fileView.horizontalAnchors
        fileStackView.verticalAnchors == fileView.verticalAnchors + 12
//        fileStackView.edgeAnchors == fileView.edgeAnchors
        
        mainStackView.addArrangedSubview(fileView)
        mainStackView.addArrangedSubview(fileSizeView)
        addSubview(mainStackView)
        mainStackView.edgeAnchors == edgeAnchors + 8
        
        
    }
    
   
    
}
