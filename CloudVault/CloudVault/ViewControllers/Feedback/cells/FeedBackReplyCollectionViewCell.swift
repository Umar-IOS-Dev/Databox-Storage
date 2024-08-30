//
//  FeedBackReplyCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 28/08/2024.
//

import UIKit

class FeedBackReplyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FeedBackReplyCollectionViewCell"
    
    var feedbackTypeLabel: UILabel = {
            let label = UILabel()
            label.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
            label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            label.textAlignment = .left
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
            return label
        }()

        var dateLabel: UILabel = {
            let label = UILabel()
            label.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
            label.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            label.clipsToBounds = true
            label.textAlignment = .left
            return label
        }()

        let checkReplyButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
            button.setFont(FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12), for: .normal)
            button.setTitle("Check Reply", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
            button.isHidden = true // Hide by default
            return button
        }()

        let blueLabel: UILabel = {
            let label = UILabel()
            label.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
            label.textColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
            label.textAlignment = .right
            label.text = "Wait For Reply..."
            label.isHidden = true // Hide by default
            return label
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .white
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true

            let stackView = UIStackView(arrangedSubviews: [feedbackTypeLabel, dateLabel])
            stackView.axis = .vertical
            stackView.spacing = 4

            let containerView = UIView()
            containerView.addSubview(stackView)
            containerView.addSubview(checkReplyButton)
            containerView.addSubview(blueLabel)

            stackView.translatesAutoresizingMaskIntoConstraints = false
            checkReplyButton.translatesAutoresizingMaskIntoConstraints = false
            blueLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -120),

                checkReplyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                checkReplyButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                checkReplyButton.widthAnchor.constraint(equalToConstant: 100),
                checkReplyButton.heightAnchor.constraint(equalToConstant: 38),

                blueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                blueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])

            contentView.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(with feedBackType: String, feedbackDate: String, showButton: Bool) {
            dateLabel.text = "Date: \(feedbackDate)"
            feedbackTypeLabel.text = feedBackType

            if showButton {
                checkReplyButton.isHidden = false
                blueLabel.isHidden = true
            } else {
                checkReplyButton.isHidden = true
                blueLabel.isHidden = false
            }
        }
}

struct FeedBackReplyData: Hashable {
    let feedbackType: String
    let feedbackDate: String
    let isShowFeedBackButton: Bool
}
