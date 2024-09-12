//
//  OtpSuccessView.swift
//  CloudVault
//
//  Created by Appinators Technology on 13/07/2024.
//

import UIKit
import Anchorage

protocol OtpSuccessCardViewDelegate: AnyObject {
    func didTapCardButton()
}

class OtpSuccessView: UIView {

    weak var otpSuccessDelegate: OtpSuccessCardViewDelegate?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "successImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "appPrimaryTextColor")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "appSubTextColor")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cardButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "secondaryButtonBG")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(title: String, subTitle: String, buttonText: String, isButtonHidden: Bool) {
        super.init(frame: .zero)
        setupView(title: title, subTitle: subTitle, buttonText: buttonText, isButtonHidden: isButtonHidden)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String, subTitle: String, buttonText: String, isButtonHidden: Bool) {
        backgroundColor = UIColor(named: "appBackgroundColor")
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10

        cardButton.isHidden = isButtonHidden
        addSubview(scrollView)
        scrollView.edgeAnchors == edgeAnchors

        scrollView.addSubview(contentView)
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor

        contentView.addSubview(topImageView)
        topImageView.topAnchor == contentView.topAnchor + DesignMetrics.Padding.size16
        topImageView.centerXAnchor == contentView.centerXAnchor
        topImageView.widthAnchor == 200
        topImageView.heightAnchor == 200

        contentView.addSubview(titleLabel)
        titleLabel.topAnchor == topImageView.bottomAnchor + DesignMetrics.Padding.size16
        titleLabel.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size16
        titleLabel.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size16
        titleLabel.text = title

        contentView.addSubview(subTitleLabel)
        subTitleLabel.topAnchor == titleLabel.bottomAnchor + DesignMetrics.Padding.size16
        subTitleLabel.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size16
        subTitleLabel.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size16
        subTitleLabel.text = subTitle

        contentView.addSubview(cardButton)
        cardButton.topAnchor == subTitleLabel.bottomAnchor + DesignMetrics.Padding.size16
        cardButton.heightAnchor == 65
        cardButton.leadingAnchor == contentView.leadingAnchor + DesignMetrics.Padding.size16
        cardButton.trailingAnchor == contentView.trailingAnchor - DesignMetrics.Padding.size16
        cardButton.setTitle(buttonText, for: .normal)
        cardButton.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)

        contentView.bottomAnchor == cardButton.bottomAnchor + DesignMetrics.Padding.size16
    }

    @objc private func cardButtonTapped() {
        otpSuccessDelegate?.didTapCardButton()
        print("Otp success button tap")
    }
}

