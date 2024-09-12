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
    
    // Store the height constraint so we can modify it later
    private var filledViewHeightConstraint: NSLayoutConstraint?

    init(filledPercentage: CGFloat, graphViewColor: UIColor, filledColor: UIColor) {
        super.init(frame: .zero)
        setupViews(containerColor: graphViewColor, filledColor: filledColor)
        setupConstraints()
        setNeedsLayout()
        layoutIfNeeded() // Ensure layout updates are applied
        // Defer animation until layout is complete
        DispatchQueue.main.async {
            self.animateFill(to: filledPercentage)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(containerColor: UIColor, filledColor: UIColor) {
        backgroundView.backgroundColor = containerColor
        filledView.backgroundColor = filledColor
        backgroundView.layer.cornerRadius = 4

        addSubview(backgroundView)
        backgroundView.addSubview(filledView)
    }

    private func setupConstraints() {
        backgroundView.edgeAnchors == edgeAnchors

        // Set up filledView constraints
        filledView.leadingAnchor == backgroundView.leadingAnchor
        filledView.trailingAnchor == backgroundView.trailingAnchor
        filledView.bottomAnchor == backgroundView.bottomAnchor

        // Initially set the height to 0
        filledViewHeightConstraint = filledView.heightAnchor == 0
        filledViewHeightConstraint?.isActive = true
    }

    func animateFill(to filledPercentage: CGFloat, duration: TimeInterval = 2.0) {
        // Ensure layout updates are applied
        layoutIfNeeded()

        // Log the current height
        let backgroundHeight = backgroundView.frame.height
        print("BackgroundView height: \(backgroundHeight)")

        // Calculate the new height
        let targetHeight = backgroundHeight * (filledPercentage / 100)
        print("Target height for animation: \(targetHeight)")

        // Update the height constraint
        filledViewHeightConstraint?.constant = targetHeight

        // Animate the change
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded() // Animate layout changes
        }) { _ in
            // Optionally configure the rounded corners after the animation completes
            self.filledView.configureRoundedCorners(corners: [.bottomLeft, .bottomRight], radius: 4)
        }
    }
}


