//
//  ReviewsCollectionViewCell.swift
//  CloudVault
//
//  Created by Appinators Technology on 23/07/2024.
//

import UIKit
import Anchorage

class ReviewsCollectionViewCell: UICollectionViewCell {
    private let reviewsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 1 // Adjust the border width
        containerView.layer.borderColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1) // Adjust the border color
        containerView.layer.cornerRadius = 8 // Adjust the corner radius
        return containerView
    }()
    
    private let reviewUserImageView: UIImageView = {
        let reviewUserImageView = UIImageView()
        reviewUserImageView.contentMode = .scaleAspectFit
        return reviewUserImageView
    }()
    
    private let ratingFilledStarImageView: UIImageView = {
        let ratingFilledStarImageView = UIImageView()
        ratingFilledStarImageView.contentMode = .scaleAspectFit
        ratingFilledStarImageView.image = UIImage(named: "ratingFillStarImage")
        return ratingFilledStarImageView
    }()
    
    private let ratingEmptyStarImageView: UIImageView = {
        let ratingEmptyStarImageView = UIImageView()
        ratingEmptyStarImageView.contentMode = .scaleAspectFit
        ratingEmptyStarImageView.image = UIImage(named: "ratingEmptyStarImage")
        return ratingEmptyStarImageView
    }()
    
    
    private let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textAlignment = .left
        userNameLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        userNameLabel.text = "Jorg Colan"
        userNameLabel.numberOfLines = 0
        userNameLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        return userNameLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .left
        dateLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        dateLabel.text = "(23 Jun 2024)"
        dateLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 10)
        return dateLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Dropbox has been an absolute game-changer for me! Its seamless integration across all devices"
        descriptionLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        return descriptionLabel
    }()
    
    var reviewUserImageName: String = "" {
        didSet {
            reviewUserImageView.image = UIImage(named: reviewUserImageName)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupReviewsContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupReviewsContainerView() {
        addSubview(reviewsContainerView)
        reviewsContainerView.edgeAnchors == edgeAnchors
        
        let reviewsContainerStackView = UIStackView()
        reviewsContainerStackView.backgroundColor = .clear
        reviewsContainerStackView.axis = .horizontal
        reviewsContainerStackView.spacing = DesignMetrics.Padding.size16
        
        let reviewsViewForImage = UIView()
        reviewsViewForImage.backgroundColor = .clear
        reviewsViewForImage.widthAnchor == 62
        reviewsViewForImage.heightAnchor == 62
        
        reviewsViewForImage.addSubview(reviewUserImageView)
        reviewUserImageView.widthAnchor == 62
        reviewUserImageView.heightAnchor == 62
        reviewUserImageView.centerAnchors == reviewsViewForImage.centerAnchors
        
        let reviewRatingAndDescriptionView = UIView()
        reviewRatingAndDescriptionView.backgroundColor = .clear
        
        let reviewRatingAndDescriptionStackView = UIStackView()
        reviewRatingAndDescriptionStackView.axis = .vertical
        reviewRatingAndDescriptionStackView.spacing = 0
        
        let titleAndRatingView = UIView()
        titleAndRatingView.backgroundColor = .clear
        titleAndRatingView.heightAnchor == 16
        
        let titleAndRatingStackView = UIStackView()
        titleAndRatingStackView.axis = .horizontal
        titleAndRatingStackView.distribution = .fillEqually
        
        let starView = UIView()
        starView.backgroundColor = .clear
        
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.distribution = .equalSpacing
        
        for _ in 0..<4 {
            let ratingFilledStarImageView = UIImageView(image: UIImage(named: "ratingFillStarImage"))
            ratingFilledStarImageView.widthAnchor == 13.3
            //            ratingFilledStarImageView.heightAnchor == 12
            starStackView.addArrangedSubview(ratingFilledStarImageView)
        }
        
        ratingEmptyStarImageView.widthAnchor == 13.3
        
        starStackView.addArrangedSubview(ratingEmptyStarImageView)
        
        starView.addSubview(starStackView)
        starStackView.edgeAnchors == starView.edgeAnchors
        
        titleAndRatingStackView.addArrangedSubview(userNameLabel)
        titleAndRatingStackView.addArrangedSubview(dateLabel)
        titleAndRatingStackView.addArrangedSubview(starView)
        
        titleAndRatingView.addSubview(titleAndRatingStackView)
        titleAndRatingStackView.edgeAnchors == titleAndRatingView.edgeAnchors
        
        let descriptionView = UIView()
        descriptionView.backgroundColor = .clear
        
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.edgeAnchors == descriptionView.edgeAnchors
        
        reviewRatingAndDescriptionStackView.addArrangedSubview(titleAndRatingView)
        reviewRatingAndDescriptionStackView.addArrangedSubview(descriptionView)
        reviewRatingAndDescriptionView.addSubview(reviewRatingAndDescriptionStackView)
        reviewRatingAndDescriptionStackView.edgeAnchors == reviewRatingAndDescriptionView.edgeAnchors
        
        reviewsContainerStackView.addArrangedSubview(reviewsViewForImage)
        reviewsContainerStackView.addArrangedSubview(reviewRatingAndDescriptionView)
        reviewsContainerView.addSubview(reviewsContainerStackView)
        reviewsContainerStackView.horizontalAnchors == reviewsContainerView.horizontalAnchors + 8
        reviewsContainerStackView.verticalAnchors == reviewsContainerView.verticalAnchors + 12
    }
}
