//
//  StorageHorizontalUsageView.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/08/2024.
//

import UIKit
import Anchorage

class StorageHorizontalUsageView: UIView {

    private let filledView = CustomRoundedView()
    private let backgroundView = UIView()
    
    init(filledPercentage: CGFloat, graphViewColor: UIColor, filledColor: UIColor) {
        super.init(frame: .zero)
        setupViews(filledPercentage: filledPercentage, containerColor: graphViewColor, filledColor: filledColor)
        setupConstraints(filledPercentage: filledPercentage)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(filledPercentage: CGFloat, containerColor: UIColor, filledColor: UIColor) {
        backgroundView.backgroundColor = containerColor
        filledView.backgroundColor = filledColor
        backgroundView.layer.cornerRadius = 4

        addSubview(backgroundView)
        backgroundView.addSubview(filledView)
    }

    private func setupConstraints(filledPercentage: CGFloat) {
        // Define the size of the view
        let viewHeight: CGFloat = 24
        let viewWidth: CGFloat = 238
        
        // Set the frame of the background view
        backgroundView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        backgroundView.layer.cornerRadius = 4
        
        // Set the frame of the filled view based on the filledPercentage
        let filledWidth = viewWidth * (filledPercentage / 100)
        
        // Apply constraints
        backgroundView.edgeAnchors == edgeAnchors
        
        filledView.leadingAnchor == backgroundView.leadingAnchor
        filledView.topAnchor == backgroundView.topAnchor
        filledView.bottomAnchor == backgroundView.bottomAnchor
        filledView.widthAnchor == backgroundView.widthAnchor * (filledPercentage / 100)
        filledView.configureRoundedCorners(corners: [.topLeft, .bottomLeft], radius: 4)
    }
}

