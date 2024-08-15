//
//  CustomRoundedView.swift
//  CloudVault
//
//  Created by Appinators Technology on 15/07/2024.
//

import UIKit

class CustomRoundedView: UIView {

    var roundedCorners: UIRectCorner = []
        var cornerRadius: CGFloat = 0.0

        override func layoutSubviews() {
            super.layoutSubviews()
            roundCorners(corners: roundedCorners, radius: cornerRadius)
        }

        func configureRoundedCorners(corners: UIRectCorner, radius: CGFloat) {
            self.roundedCorners = corners
            self.cornerRadius = radius
            setNeedsLayout()
        }

}
