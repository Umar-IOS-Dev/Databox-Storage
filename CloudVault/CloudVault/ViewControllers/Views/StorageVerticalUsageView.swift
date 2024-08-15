//
//  StorageVerticalUsageView.swift
//  CloudVault
//
//  Created by Appinators Technology on 09/08/2024.
//

import UIKit
import Anchorage

class StorageVerticalUsageView: UIView {

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
            backgroundView.edgeAnchors == edgeAnchors

            filledView.leadingAnchor == backgroundView.leadingAnchor
            filledView.trailingAnchor == backgroundView.trailingAnchor
            filledView.bottomAnchor == backgroundView.bottomAnchor
            filledView.heightAnchor == backgroundView.heightAnchor * (filledPercentage / 100)
            filledView.configureRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 4)
        }
    
}
