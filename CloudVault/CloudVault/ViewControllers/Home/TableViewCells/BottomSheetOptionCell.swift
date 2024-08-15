//
//  BottomSheetOptionCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/07/2024.
//

import UIKit
import Anchorage

class BottomSheetOptionCell: UITableViewCell {
    
     let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor == 16
        imageView.widthAnchor == 16
        return imageView
    }()
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.cloudVaultSemiBoldText(ofSize: 16)
        label.heightAnchor == 20
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .leading
        addSubview(stackView)
        stackView.leadingAnchor == leadingAnchor + 16
        stackView.trailingAnchor == trailingAnchor - 16
        stackView.topAnchor == topAnchor + 8
        stackView.bottomAnchor == bottomAnchor - 8
    }
    
    func configure(with option: BottomSheetOption) {
        iconImageView.image = option.icon
        titleLabel.text = option.title
        if((option.title == "Delete") || (option.title == "Cancel")) {
            titleLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.3019607843, blue: 0.3019607843, alpha: 0.1850818452)
        }
        else {
            titleLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            backgroundColor = .white
        }
    }
}

struct BottomSheetOption {
    let icon: UIImage
    let title: String
}

