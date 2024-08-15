//
//  DateHeaderView.swift
//  CloudVault
//
//  Created by Appinators Technology on 29/07/2024.
//

import UIKit
import Anchorage

class DateHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "DateHeaderView"
       
        let label: UILabel = {
           let label = UILabel()
            label.font = UIFont.cloudVaultSemiBoldText(ofSize: 16)
           label.textColor = .black
           return label
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           addSubview(label)
           label.edgeAnchors == edgeAnchors + 8
           backgroundColor = .clear
           layer.cornerRadius = 8
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configure(with date: String) {
           label.text = date
       }
}
