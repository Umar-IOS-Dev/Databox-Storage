//
//  OnboardingViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 08/07/2024.
//

import UIKit
import Anchorage

protocol OnboardingViewControllerDelegate: AnyObject {
    func didTapNextButton(on viewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController {
    var pageIndex: Int = 0
    var titleText: String = ""
    var pageIndexImageName: String = ""
    var progressButtonImageName: String = ""
    var progressButtonPercentage: Double = 0.0
    var gifImageName: String = ""
    weak var delegate: OnboardingViewControllerDelegate?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 32)
        label.textAlignment = .center
        label.textColor = UIColor(named: "appPrimaryTextColor")
        label.numberOfLines = 0
        return label
    }()
    let subHeadingLabel: UILabel = {
        let label = UILabel()
        label.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor(named: "onBoardingSubTextColor")
        label.numberOfLines = 0
        label.text = "data storage gives you extra space to backup, upload & share \n data with end-to-end encrypted"
        return label
    }()
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(named: "appPrimaryTextColor"), for: .normal)
        button.titleLabel?.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let gifView: UIView = {
        let gifContainer = UIView()
        // gifContainer.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        gifContainer.translatesAutoresizingMaskIntoConstraints = false
        return gifContainer
    }()
    let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let pageControlImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let progressButton: ProgressButton = {
        let button = ProgressButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressButton.setProgress(to: progressButtonPercentage, animated: true) // Set progress to 70%
    }
    
    private func setupUI() {
        view.addSubview(skipButton)
        skipButton.widthAnchor == DesignMetrics.Dimensions.width40
        skipButton.heightAnchor == DesignMetrics.Dimensions.height24
        skipButton.topAnchor == view.safeAreaLayoutGuide.topAnchor + DesignMetrics.Padding.size24
        skipButton.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor - DesignMetrics.Padding.size16
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        view.addSubview(gifView)
        gifView.widthAnchor == view.widthAnchor * 0.90
        gifView.heightAnchor == view.heightAnchor * 0.30
        gifView.topAnchor == skipButton.bottomAnchor + DesignMetrics.Padding.size24
        gifView.centerXAnchor == view.centerXAnchor
        
        gifView.addSubview(gifImageView)
        gifImageView.sizeAnchors == gifView.sizeAnchors
        updateGifImage()
        view.addSubview(titleLabel)
        titleLabel.topAnchor == gifView.bottomAnchor + DesignMetrics.Padding.size24
        titleLabel.leadingAnchor == gifView.leadingAnchor
        titleLabel.trailingAnchor == gifView.trailingAnchor
        titleLabel.text = titleText
        
        view.addSubview(subHeadingLabel)
        subHeadingLabel.topAnchor == titleLabel.bottomAnchor + DesignMetrics.Padding.size16
        subHeadingLabel.leadingAnchor == titleLabel.leadingAnchor + DesignMetrics.Padding.size16
        subHeadingLabel.trailingAnchor == titleLabel.trailingAnchor - DesignMetrics.Padding.size16
        
        view.addSubview(pageControlImageView)
        pageControlImageView.widthAnchor == DesignMetrics.Dimensions.width88
        pageControlImageView.heightAnchor == DesignMetrics.Dimensions.height12
        pageControlImageView.topAnchor == subHeadingLabel.bottomAnchor + DesignMetrics.Padding.size32
        pageControlImageView.centerXAnchor == view.centerXAnchor
        pageControlImageView.image = UIImage(named: pageIndexImageName)
        
        view.addSubview(progressButton)
        progressButton.widthAnchor == DesignMetrics.Dimensions.width76
        progressButton.heightAnchor == DesignMetrics.Dimensions.height76
        progressButton.topAnchor == pageControlImageView.bottomAnchor + DesignMetrics.Padding.size32
       // progressButton.layer.cornerRadius = 37
       // progressButton.layer.borderWidth = 2
        //progressButton.layer.borderColor = UIColor.white.cgColor
        progressButton.centerXAnchor == view.centerXAnchor
        
       // progressButton.setImage(UIImage(named: progressButtonImageName), for: .normal)
    }
    
    func updateGifImage() {
        if let gif = try? UIImage(gifName: gifImageName) {
            gifImageView.setGifImage(gif)
        }
    }
    
    @objc func skipButtonTapped(){
        // Navigate to main app or target view controller
        if let onboardingPageVC = parent as? OnboardingPageViewController {
            onboardingPageVC.navigateOutOfOnboarding()
        }
    }
    
    @objc func nextButtonTapped() {
        delegate?.didTapNextButton(on: self)
    }
}
