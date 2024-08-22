//
//  HomeViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/07/2024.
//

import UIKit
import Anchorage

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .clear
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = UIImage(named: "emoji1")
        return profileImageView
    }()
    private let storageView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        containerView.layer.cornerRadius = DesignMetrics.Padding.size12
        containerView.heightAnchor == 250
        return containerView
    }()
    private let filesContainerView: UIView = {
        let filesContainerView = UIView()
        filesContainerView.backgroundColor = .clear//#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        filesContainerView.layer.cornerRadius = DesignMetrics.Padding.size12
        filesContainerView.heightAnchor == 233
        return filesContainerView
    }()
    private let storageGraphView: StorageUsageView = {
        let storageView = StorageUsageView(images: 2, videos: 2, documents: 2, audio: 2, files: 2, contacts: 2, free: 88)
        return storageView
    }()
    private let sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1)
        sliderView.heightAnchor == 98
        sliderView.layer.cornerRadius = 8
        return sliderView
    }()
    private let gotoAllButton: UIButton = {
        let seeAllBtn = UIButton()
        seeAllBtn.setFont(FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 12), for: .normal)
        seeAllBtn.setTitleColor(#colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1), for: .normal)
        seeAllBtn.setTitle("Go To All", for: .normal)
        seeAllBtn.backgroundColor = .clear
        return seeAllBtn
    }()
    private let storageLabel: UILabel = {
        let storageLabel = UILabel()
        storageLabel.textAlignment = .left
        storageLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        storageLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 20)
        storageLabel.text = "Storage Overview"
        return storageLabel
    }()
    private let usedStorageLabel: UILabel = {
        let usedStorageLabel = UILabel()
        usedStorageLabel.textAlignment = .left
        usedStorageLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.5409491922)
        usedStorageLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 10)
        usedStorageLabel.text = "01GB used from out of 100GB"
        return usedStorageLabel
    }()
    private let arrowButton: UIButton = {
        let arrowButton = UIButton()
        arrowButton.contentMode = .scaleAspectFit
        arrowButton.setImage(UIImage(named: "forwardArrow"), for: .normal)
        return arrowButton
    }()
    private let sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let recentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.alpha = 0.1
        return pageControl
    }()
    private let imagesViewContainer: AppFilesView = {
        let imagesViewContainer = AppFilesView(fileImage: UIImage(named: "imagesIcon") ?? UIImage.appIcon, titleOfFile: "Images", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 1, green: 0.3607843137, blue: 0.2196078431, alpha: 1))
        imagesViewContainer.configureRoundedCorners(corners: [.topLeft], radius: DesignMetrics.Padding.size8)
        return imagesViewContainer
    }()
    private let videosViewContainer: AppFilesView = {
        let videosViewContainer = AppFilesView(fileImage: UIImage(named: "videosIconHome") ?? UIImage.appIcon, titleOfFile: "Videos", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 0.04705882353, green: 0.6549019608, blue: 1, alpha: 1))
        return videosViewContainer
    }()
    private let documentsViewContainer: AppFilesView = {
        let documentsViewContainer = AppFilesView(fileImage: UIImage(named: "documentsIconHome") ?? UIImage.appIcon, titleOfFile: "Documents", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 0, green: 0.8588235294, blue: 0.6509803922, alpha: 1))
        documentsViewContainer.configureRoundedCorners(corners: [.topRight], radius: DesignMetrics.Padding.size8)
        return documentsViewContainer
    }()
    private let audioViewContainer: AppFilesView = {
        let audioViewContainer = AppFilesView(fileImage: UIImage(named: "audiosIconHome") ?? UIImage.appIcon, titleOfFile: "Audio", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 0.8039215686, green: 0, blue: 0.8745098039, alpha: 1))
        audioViewContainer.configureRoundedCorners(corners: [.bottomLeft], radius: DesignMetrics.Padding.size8)
        return audioViewContainer
    }()
    private let filesViewContainer: AppFilesView = {
        let filesViewContainer = AppFilesView(fileImage: UIImage(named: "filesIcon") ?? UIImage.appIcon, titleOfFile: "Files", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 1, green: 0.768627451, blue: 0.1294117647, alpha: 1))
        return filesViewContainer
    }()
    private let contactsViewContainer: AppFilesView = {
        let contactsViewContainer = AppFilesView(fileImage: UIImage(named: "contactIcon") ?? UIImage.appIcon, titleOfFile: "Contacts", totalCount: "000", totalSize: "00GB", labelColor: #colorLiteral(red: 0.2352941176, green: 0.8549019608, blue: 0.01960784314, alpha: 1))
        contactsViewContainer.configureRoundedCorners(corners: [.bottomRight], radius: DesignMetrics.Padding.size8)
        return contactsViewContainer
    }()
    private let numberOfSlides = 7
    private var timer: Timer?
    private let recentFilesArray: [RecentImageData] = [RecentImageData(recentImage: "recentImage", imageName: "School Crush", imageSize: "Size: 120 KB"), RecentImageData(recentImage: "recentImage1", imageName: "Lilly", imageSize: "Size: 2.5 MB"), RecentImageData(recentImage: "recentImage2", imageName: "Hair Girl", imageSize: "Size: 891 KB"), RecentImageData(recentImage: "recentImage", imageName: "School Crush", imageSize: "Size: 120 KB"), RecentImageData(recentImage: "recentImage", imageName: "School Crush", imageSize: "Size: 120 KB"), RecentImageData(recentImage: "recentImage", imageName: "School Crush", imageSize: "Size: 120 KB"), RecentImageData(recentImage: "recentImage", imageName: "School Crush", imageSize: "Size: 120 KB")]
    
    private var sideMenuView: SideMenuView!
    private var sideMenuLeadingConstraint: NSLayoutConstraint!
    private let overlayView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "", hideBackground: true, showMainNavigation: true)
        configurePageControl()
        startAutoScroll()
        setupSidemenu()
        setupOverlayView()
        //setupLoadingView()
       // self.view.isUserInteractionEnabled = false
//        showProgress()
       // scheduleLocalNotification()
    }
    
    func scheduleLocalNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Test Notification"
            content.body = "This is a test notification."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully!")
                }
            }
        }
    
    private func setupOverlayView() {
            // Add overlay view to the main view, excluding the side menu area
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.isHidden = true // Initially hidden
            overlayView.alpha = 0
            view.addSubview(overlayView)
            
            // Set up overlay constraints to cover the main content area, not the side menu
            overlayView.topAnchor == view.topAnchor
            overlayView.bottomAnchor == view.bottomAnchor
            overlayView.leadingAnchor == view.leadingAnchor + 250
            overlayView.trailingAnchor == view.trailingAnchor
            
            // Add tap gesture to overlay to hide side menu
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSideMenu))
            overlayView.addGestureRecognizer(tapGesture)
        }
    
    override func handleHamBurgerTapped() {
        print("this is correct hamburger")
        toggleSideMenu()
    }
    
    private func setupSidemenu() {
            // Sample menu titles and icons
            let menuTitles = ["Home", "Settings", "Profile", "Help", "Logout"]
            let menuIcons = [UIImage(named: "audioIcon"), UIImage(named: "contactsIcon"), UIImage(named: "documentsIcon"), UIImage(named: "folderIcon"), UIImage(named: "photosIcon")]
            
            // Initialize SideMenuView
            sideMenuView = SideMenuView(menuTitles: menuTitles, menuIcons: menuIcons.compactMap { $0 })
            
            // Add SideMenuView to the view controller's view
            view.addSubview(sideMenuView)
            
            // Set initial layout constraints for SideMenuView
            sideMenuView.topAnchor == view.topAnchor
            sideMenuView.bottomAnchor == view.bottomAnchor
            sideMenuView.widthAnchor == 250 // Set the width of the side menu

            // Initially, position the menu off-screen
            sideMenuLeadingConstraint = sideMenuView.leadingAnchor == view.leadingAnchor - 250
            
            // Call to layout to apply constraints
            view.layoutIfNeeded()

            // Configure additional properties if needed
            sideMenuView.userNameLabel.text = "John Doe"
            sideMenuView.emailLabel.text = "john.doe@example.com"
            sideMenuView.storageInfoLabel.text = "Storage: 10 GB used of 50 GB"
            
            // Example: Adding a background color to the menu
            sideMenuView.backgroundColor = UIColor.white
        }
        
    
    
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        configureStorageView()
        configureSliderCollectionView()
        setupFilesView()
        setupRecentHeadingView()
        setupRecentContainerView()
    }
    
    

    // Function to show the side menu
        func showSideMenu() {
            sideMenuLeadingConstraint.constant = 0 // Move the menu on-screen
            overlayView.isHidden = false

            UIView.animate(withDuration: 0.3) {
                self.overlayView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }

        // Function to hide the side menu
        @objc func hideSideMenu() {
            sideMenuLeadingConstraint.constant = -250 // Move the menu off-screen

            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.alpha = 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.overlayView.isHidden = true
            }
        }
        
        // Toggle the side menu visibility
        func toggleSideMenu() {
            if sideMenuLeadingConstraint.constant == 0 {
                hideSideMenu()
            } else {
                showSideMenu()
            }
        }
    
    private func configureStorageView() {
        let storageStackView = UIStackView()
        storageStackView.axis = .vertical
        storageStackView.spacing = DesignMetrics.Padding.size20
        
        let storageLabelView = UIView()
        storageLabelView.backgroundColor = .clear
        
        let storageLabelStackView = UIStackView()
        storageLabelStackView.axis = .horizontal
        storageLabelStackView.spacing = DesignMetrics.Padding.size16
        
        let storageLabelStackContentView = UIView()
        storageLabelStackContentView.backgroundColor = .clear
        
        let stackViewForStorageLabels = UIStackView()
        stackViewForStorageLabels.axis = .vertical
        stackViewForStorageLabels.distribution = .equalSpacing
        stackViewForStorageLabels.spacing = DesignMetrics.Padding.size0
        
        stackViewForStorageLabels.addArrangedSubview(storageLabel)
        stackViewForStorageLabels.addArrangedSubview(usedStorageLabel)
        
        storageLabelStackContentView.addSubview(stackViewForStorageLabels)
        stackViewForStorageLabels.verticalAnchors == storageLabelStackContentView.verticalAnchors + 8
        stackViewForStorageLabels.horizontalAnchors == storageLabelStackContentView.horizontalAnchors
        
        let storageLabelStackArrowView = UIView()
        storageLabelStackArrowView.backgroundColor = .clear
        storageLabelStackArrowView.widthAnchor == 60
        
        let innerViewforArrow = UIView()
        innerViewforArrow.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 0.9882352941, alpha: 1)
        innerViewforArrow.widthAnchor == 30
        innerViewforArrow.heightAnchor == 30
        
        storageLabelStackArrowView.addSubview(innerViewforArrow)
        innerViewforArrow.addSubview(arrowButton)
        innerViewforArrow.centerAnchors == storageLabelStackArrowView.centerAnchors
        arrowButton.centerAnchors == innerViewforArrow.centerAnchors
        arrowButton.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
        
        storageLabelStackView.addArrangedSubview(storageLabelStackContentView)
        storageLabelStackView.addArrangedSubview(storageLabelStackArrowView)
        
        storageLabelView.addSubview(storageLabelStackView)
        storageLabelStackView.edgeAnchors == storageLabelView.edgeAnchors + 8
        
        storageGraphView.heightAnchor == 20
        storageGraphView.layer.cornerRadius = 8
        
        storageStackView.addArrangedSubview(storageLabelView)
        storageStackView.addArrangedSubview(storageGraphView)
        storageStackView.addArrangedSubview(sliderView)
        
        storageView.addSubview(storageStackView)
        storageStackView.edgeAnchors == storageView.edgeAnchors + 8
        
        let forwardArrowView = UIView()
        forwardArrowView.backgroundColor = .green
        appendViewToMainVStack(view: storageView)
    }
    
    private func configureSliderCollectionView() {
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.register(DataBoxCollectionViewCell.self, forCellWithReuseIdentifier: "slideCell")
        sliderCollectionView.register(OutOfStorageCollectionViewCell.self, forCellWithReuseIdentifier: "storageCell")
        sliderCollectionView.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: "reviewsCell")
        
        sliderView.addSubview(sliderCollectionView)
        sliderCollectionView.layer.cornerRadius = 8
        sliderCollectionView.edgeAnchors == sliderView.edgeAnchors
        
        sliderView.addSubview(pageControl)
        pageControl.centerXAnchor == sliderView.centerXAnchor
        pageControl.bottomAnchor == sliderView.bottomAnchor + DesignMetrics.Padding.size4
    }
    
    private func configureRecentCollectionView() {
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.backgroundColor = .clear
        recentCollectionView.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: "recentCell")
        setupRecentContainerWithData()
    }
    
     func configurePageControl() {
        pageControl.numberOfPages = numberOfSlides
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextSlide), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextSlide() {
        let visibleRect = CGRect(origin: sliderCollectionView.contentOffset, size: sliderCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = sliderCollectionView.indexPathForItem(at: visiblePoint) {
            let nextIndex = (visibleIndexPath.item + 1) % numberOfSlides
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            sliderCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func setupFilesView() {
        let filesContainerStackView = UIStackView()
        filesContainerStackView.axis = .vertical
        filesContainerStackView.spacing = 2//DesignMetrics.Padding.size0
        filesContainerStackView.distribution = .fillEqually
        
        let upperView = UIView()
        upperView.backgroundColor = .clear
        upperView.heightAnchor == 116
        
        let upperStackView = UIStackView()
        upperStackView.axis = .horizontal
        upperStackView.spacing = 2
        upperStackView.distribution = .fillEqually
        
        upperStackView.addArrangedSubview(imagesViewContainer)
        upperStackView.addArrangedSubview(videosViewContainer)
        upperStackView.addArrangedSubview(documentsViewContainer)
        upperView.addSubview(upperStackView)
        upperStackView.edgeAnchors == upperView.edgeAnchors
        
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 2
        bottomStackView.distribution = .fillEqually
        
        bottomStackView.addArrangedSubview(audioViewContainer)
        bottomStackView.addArrangedSubview(filesViewContainer)
        bottomStackView.addArrangedSubview(contactsViewContainer)
        bottomView.addSubview(bottomStackView)
        bottomStackView.edgeAnchors == bottomView.edgeAnchors
        
        filesContainerStackView.addArrangedSubview(upperView)
        filesContainerStackView.addArrangedSubview(bottomView)
        filesContainerView.addSubview(filesContainerStackView)
        filesContainerStackView.edgeAnchors == filesContainerView.edgeAnchors
        appendViewToMainVStack(view: filesContainerView, topPadding: 24)
    }
    
    private func setupRecentHeadingView() {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.heightAnchor == 16
        
        let recentFileLabel = UILabel()
        recentFileLabel.textAlignment = .left
        recentFileLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        recentFileLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        recentFileLabel.text = "Recent Files"
        
        
        gotoAllButton.heightAnchor == DesignMetrics.Dimensions.height20
        gotoAllButton.addTarget(self, action: #selector(seeAllButtonTapped(_:)), for: .touchUpInside)
        
        containerView.addSubview(recentFileLabel)
        containerView.addSubview(gotoAllButton)
        
        recentFileLabel.leadingAnchor == containerView.leadingAnchor + 8
        recentFileLabel.centerYAnchor == containerView.centerYAnchor
        gotoAllButton.trailingAnchor == containerView.trailingAnchor - 8
        gotoAllButton.centerYAnchor == containerView.centerYAnchor
        appendViewToMainVStack(view: containerView, topPadding: 16)
    }
    
    private func setupRecentContainerView() {
        if(recentFilesArray.count > 0) {
            gotoAllButton.isHidden = true
            configureRecentCollectionView()
            
        }
        else {
            gotoAllButton.isHidden = false
            setupRecentContainerWithNoData()
        }
    }
    
    private func setupRecentContainerWithData() {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.heightAnchor == 125
        containerView.addSubview(recentCollectionView)
        recentCollectionView.edgeAnchors == containerView.edgeAnchors
        appendViewToMainVStack(view: containerView, topPadding: 16)
    }
    
    private func setupRecentContainerWithNoData() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = DesignMetrics.Padding.size8
        containerView.heightAnchor == 125
        
        let emptyRecentImageView = UIImageView()
        emptyRecentImageView.backgroundColor = .clear
        emptyRecentImageView.contentMode = .scaleAspectFit
        emptyRecentImageView.image = UIImage(named: "emptyRecentImage")
        
        let noRecentFileLabel = UILabel()
        noRecentFileLabel.textAlignment = .center
        noRecentFileLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.1486500851)
        noRecentFileLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 10)
        noRecentFileLabel.text = "No Recent File Found Here"
        
        containerView.addSubview(emptyRecentImageView)
        containerView.addSubview(noRecentFileLabel)
        
        emptyRecentImageView.heightAnchor == 47
        emptyRecentImageView.widthAnchor == 47
        emptyRecentImageView.centerXAnchor == containerView.centerXAnchor
        emptyRecentImageView.centerYAnchor == containerView.centerYAnchor - DesignMetrics.Padding.size16
        
        noRecentFileLabel.topAnchor == emptyRecentImageView.bottomAnchor + 16
        noRecentFileLabel.centerXAnchor == emptyRecentImageView.centerXAnchor
        appendViewToMainVStack(view: containerView, topPadding: 16)
    }
    
    @objc private func arrowButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("arrow Tapped")
        let storageVC = StorageViewController()
        self.navigationController?.pushViewController(storageVC, animated: true)
    }
    
    @objc private func seeAllButtonTapped(_ sender: UIButton) {
        guard navigationController != nil else { print("not navigation")
            return }
        print("recent Tapped")
        //        let emojiVC = EmojiViewController(allEmojiArray: personalityAllImagesArray)
        //        emojiVC.emojiSelectionDelegate = self
        //        self.navigationController?.pushViewController(emojiVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSlides
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == sliderCollectionView) {
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! DataBoxCollectionViewCell
                cell.titleOfDataBox = "Try Databox Website"
                cell.descriptionOfDataBox = "Experience seamless navigation and top-notch services on our website"
                cell.backgroundColor = #colorLiteral(red: 0.9969579577, green: 0.9919913411, blue: 0.9963858724, alpha: 1)
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! DataBoxCollectionViewCell
                cell.titleOfDataBox = "End-To- Encryption"
                cell.descriptionOfDataBox = "Protect your data with our end-to-end encryption, to make it secure"
                cell.backgroundColor = #colorLiteral(red: 0.9969579577, green: 0.9919913411, blue: 0.9963858724, alpha: 1)
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! DataBoxCollectionViewCell
                cell.titleOfDataBox = "File Manager"
                cell.descriptionOfDataBox = "Organize and access your files effortlessly with our intuitive File Manager"
                cell.backgroundColor = #colorLiteral(red: 0.9969579577, green: 0.9919913411, blue: 0.9963858724, alpha: 1)
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storageCell", for: indexPath) as! OutOfStorageCollectionViewCell
                cell.storageBackgroundColor = #colorLiteral(red: 0.8901960784, green: 0.1176470588, blue: 0.1411764706, alpha: 1)
                cell.storageImageName = "storageRedImage"
                cell.storageCrossImageName = "storageRedCross"
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storageCell", for: indexPath) as! OutOfStorageCollectionViewCell
                cell.storageBackgroundColor = #colorLiteral(red: 0.4980392157, green: 0.6745098039, blue: 0, alpha: 1)
                cell.storageImageName = "storageGreenImage"
                cell.storageCrossImageName = "storageGreenCross"
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! ReviewsCollectionViewCell
                cell.reviewUserImageName = "reviewUserImage"
                cell.backgroundColor = #colorLiteral(red: 0.9969579577, green: 0.9919913411, blue: 0.9963858724, alpha: 1)
                return cell
            }
        }
        else if collectionView == recentCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentCell", for: indexPath) as! RecentCollectionViewCell
            cell.recentImageName = recentFilesArray[indexPath.item].recentImage
            cell.imageName = recentFilesArray[indexPath.item].imageName
            cell.imageSize = recentFilesArray[indexPath.item].imageSize
            return cell
        }
        else {
            return  UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == sliderCollectionView) {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: 118, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView != sliderCollectionView) {
//            let imageName = recentFilesArray[indexPath.item].recentImage
//            let options = [
//                BottomSheetOption(icon: UIImage(named: "shareIcon")!, title: "Share"),
//                BottomSheetOption(icon: UIImage(named: "accessIcon")!, title: "Manage Access"),
//                BottomSheetOption(icon: UIImage(named: "favouriteIcon")!, title: "Add To Favourite"),
//                BottomSheetOption(icon: UIImage(named: "offlineIcon")!, title: "Make Available Offline"),
//                BottomSheetOption(icon: UIImage(named: "linkCopyIcon")!, title: "Copy Link"),
//                BottomSheetOption(icon: UIImage(named: "copyIcon")!, title: "Make a Copy"),
//                BottomSheetOption(icon: UIImage(named: "sendIcon")!, title: "Send a Copy"),
//                BottomSheetOption(icon: UIImage(named: "openWithIcon")!, title: "Open With"),
//                BottomSheetOption(icon: UIImage(named: "downloadIcon")!, title: "Download in Device"),
//                BottomSheetOption(icon: UIImage(named: "renameIcon")!, title: "Rename"),
//                BottomSheetOption(icon: UIImage(named: "moveIcon")!, title: "Move"),
//                BottomSheetOption(icon: UIImage(named: "deleteIcon")!, title: "Delete"),
//                // Add more options here
//            ]
//            let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: options)
//            self.navigationController?.pushViewController(imagePreviewVC, animated: true)
            
            let recentController = RecentFilesViewController()
            self.navigationController?.pushViewController(recentController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(page)
    }
}



