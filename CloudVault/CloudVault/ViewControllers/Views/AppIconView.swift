//
//  AppIconView.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/07/2024.
//

import UIKit
import Anchorage

class AppIconView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(backgroundImage: UIImage, iconImage: UIImage) {
        super.init(frame: .zero)
        setupView(backgroundImage: backgroundImage, iconImage: iconImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(backgroundImage: UIImage, iconImage: UIImage) {
        addSubview(backgroundImageView)
        addSubview(iconImageView)
        
        backgroundImageView.image = backgroundImage
        iconImageView.image = iconImage
        
        backgroundImageView.edgeAnchors == edgeAnchors
        iconImageView.centerAnchors == centerAnchors
        iconImageView.widthAnchor == DesignMetrics.Dimensions.width148
        iconImageView.heightAnchor == DesignMetrics.Dimensions.height148
    }
    
}





