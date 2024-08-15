//
//  PhotosViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 01/08/2024.
//

import UIKit
import Anchorage
import Photos
import AVKit

class PhotosViewController: BaseViewController {
    
    private let filterContainerView: UIView = {
        let filterContainerView = UIView()
        filterContainerView.backgroundColor = .white
        filterContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        filterContainerView.heightAnchor == DesignMetrics.Dimensions.height51
        return filterContainerView
    }()
    private let filterNameLabel: UILabel = {
        let filterNameLabel = UILabel()
        filterNameLabel.textAlignment = .left
        filterNameLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        filterNameLabel.font = UIFont.cloudVaultSemiBoldText(ofSize: 14)
        filterNameLabel.text = "By Date"
        return filterNameLabel
    }()
    private let listViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "listViewDeselectedIcon"), for: .normal)
        return button
    }()
    private let gridViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "gridViewSelectedIcon"), for: .normal)
        return button
    }()
    private let uploadButton: UIButton = {
        let button = UIButton()
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        button.isEnabled = true//false
        button.setTitle("Upload Photos", for: .normal)
        button.setTitleColor(titleColorForNormalState, for: .normal)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        return button
    }()
    private let uploadSizeLabel: UILabel = {
        let uploadSizeLabel = UILabel()
        uploadSizeLabel.textAlignment = .left
        uploadSizeLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        uploadSizeLabel.font = UIFont.cloudVaultBoldText(ofSize: 28)
        uploadSizeLabel.text = "0.0 MB"
        return uploadSizeLabel
    }()
    private let uploadSubHeadingLabel: UILabel = {
        let uploadSubHeadingLabel = UILabel()
        uploadSubHeadingLabel.textAlignment = .left
        uploadSubHeadingLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        uploadSubHeadingLabel.font = UIFont.cloudVaultRegularText(ofSize: 12)
        uploadSubHeadingLabel.text = "selected to upload on databox"
        return uploadSubHeadingLabel
    }()
    private var currentViewType: ViewType = .grid
    private var currentMediaType: MediaType = .image
    private var filesDataSource: [String: [MediaData]] = [:]
    private var sortedSectionKeys: [String] = []
    private var selectedIndexPaths: Set<IndexPath> = []
    private var selectedDocumentURLs: [URL] = []
    var documentInteractionController: UIDocumentInteractionController?
    private var dataSource: UICollectionViewDiffableDataSource<String, MediaData>!
    private var assets: [PHAsset] = []
    private let imageManager = PHCachingImageManager()
    private var assetMapping: [IndexPath: PHAsset] = [:]
    private let spacerString:String = "    "
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
        collectionView.register(DocumentTableViewCell.self, forCellWithReuseIdentifier: DocumentTableViewCell.reuseIdentifier)
        collectionView.register(DateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private var _selectedItemSize = 0.0
    // Computed property for selectedItemSize
    var selectedItemSize: Double {
        get {
            return _selectedItemSize
        }
        set {
            _selectedItemSize = newValue.rounded(toPlaces: 2)
            // Optional: Perform additional actions when the section is updated
            self.uploadSizeLabel.text = "\(_selectedItemSize) MB"
            print("Selected item size has been updated to \(_selectedItemSize)")
        }
    }
    
    
    
    init(currentMediaType: MediaType) {
        self.currentMediaType = currentMediaType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        
        switch currentMediaType {
        case .image:
            configureUI(title: "Photos", showBackButton: true, hideBackground: true, showMainNavigation: false)
            requestPhotosPermission()
        case .video:
            configureUI(title: "Videos", showBackButton: true, hideBackground: true, showMainNavigation: false)
            requestPhotosPermission()
        case .favourite:
            configureUI(title: "\(spacerString)Favourite Files", showBackButton: false, hideBackground: true, showMainNavigation: false)
            requestPhotosPermission()
        case .shared:
            configureUI(title: "\(spacerString)Shared Files", showBackButton: false, hideBackground: true, showMainNavigation: false)
            requestPhotosPermission()
        case .document:
            configureUI(title: "Documents", showBackButton: true, hideBackground: true, showMainNavigation: false)
            
        }
        
        hideFocusbandOptionFromNavBar()
        showHideFooterView(isShowFooterView: false)
        configureDataSource()
        // setupData() // Moved setupData here to ensure dataSource is initialized before applying snapshot
        collectionView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch currentMediaType {
        case .image, .video, .favourite, .shared:
            break
        case .document:
            if(filesDataSource.count == 0) {
                presentDocumentPicker()
            }
        }
        
    }
    
    private func presentDocumentPicker() {
        var documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = true
            present(documentPicker, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
           // documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .import)
        }
        
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        filterView()
        setupCollectionView()
        configureFooterView()
    }
    
    private func configureFooterView() {
        let footerView = UIView()
        
        let footerStackView = UIStackView()
        footerStackView.axis = .horizontal
        footerStackView.distribution = .fillEqually
        footerStackView.backgroundColor = .white
        
        let uploadSizeViewForLabel = UIView()
        uploadSizeViewForLabel.backgroundColor = .clear//.brown
        
        let uploadSizeStackView = UIStackView()
        uploadSizeStackView.axis = .vertical
        uploadSizeStackView.spacing = DesignMetrics.Padding.size4
        
        uploadSizeStackView.addArrangedSubview(uploadSizeLabel)
        uploadSizeStackView.addArrangedSubview(uploadSubHeadingLabel)
        
        uploadSizeViewForLabel.addSubview(uploadSizeStackView)
        uploadSizeStackView.edgeAnchors == uploadSizeViewForLabel.edgeAnchors + DesignMetrics.Padding.size16
        
        let uploadButtonView = UIView()
        uploadButtonView.backgroundColor = .clear//.green
        
        uploadButtonView.addSubview(uploadButton)
        uploadButton.edgeAnchors == uploadButtonView.edgeAnchors + DesignMetrics.Padding.size16
        
        switch currentMediaType {
        case .image:
            uploadButton.setTitle("Upload Photos", for: .normal)
        case .video:
            uploadButton.setTitle("Upload Videos", for: .normal)
        case .favourite:
            uploadButton.setTitle("Upload", for: .normal)
        case .shared:
            uploadButton.setTitle("Upload", for: .normal)
        case .document:
            uploadButton.setTitle("Upload Documents", for: .normal)
        }
        uploadButton.addTarget(self, action: #selector(self.uploadButtonTapped(_:)), for: .touchUpInside)
        
        footerStackView.addArrangedSubview(uploadSizeViewForLabel)
        footerStackView.addArrangedSubview(uploadButtonView)
        
        footerView.addSubview(footerStackView)
        footerStackView.edgeAnchors == footerView.edgeAnchors
        
        addFooterView(footerView: footerView, height: 88)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch self.currentViewType {
            case .grid:
                // Grid layout
                let itemWidth: CGFloat = 82
                let itemHeight: CGFloat = 82
                let maxItemsPerRow: CGFloat = 3
                let totalSpacing: CGFloat = 5 * (maxItemsPerRow - 1)
                let availableWidth = environment.container.effectiveContentSize.width
                let numberOfItemsPerRow = min(maxItemsPerRow, floor((availableWidth + 5) / (itemWidth + 5)))
                let adjustedItemWidth = (availableWidth - (numberOfItemsPerRow - 1) * 5) / numberOfItemsPerRow
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(adjustedItemWidth - 10), heightDimension: .absolute(itemHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(itemHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(5)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
                backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 44, leading: 0, bottom: 0, trailing: 0)
                section.decorationItems = [backgroundItem]
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
                
            case .list:
                // List layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
                backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 44, leading: 0, bottom: 0, trailing: 0)
                section.decorationItems = [backgroundItem]
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            }
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        return layout
    }
    
    @objc private func listViewButtonTapped(_ sender: UIButton) {
        currentViewType = .list
        listViewButton.setImage(UIImage(named: "listViewSelectedIcon"), for: .normal)
        gridViewButton.setImage(UIImage(named: "gridViewDeselectedIcon"), for: .normal)
        collectionView.register(ImagesCollectionViewCell1.self, forCellWithReuseIdentifier: ImagesCollectionViewCell1.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.reloadData()
    }
    
    @objc private func gridViewButtonTapped(_ sender: UIButton) {
        currentViewType = .grid
        listViewButton.setImage(UIImage(named: "listViewDeselectedIcon"), for: .normal)
        gridViewButton.setImage(UIImage(named: "gridViewSelectedIcon"), for: .normal)
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.reloadData()
    }
    
    func requestPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.showPhotoGallery()
                }
                
                print("Authorized Gallery")
            case .denied, .restricted, .notDetermined:
                // Handle permission denial
                print("denied")
                self.handlePermissionDenied()
                break
            default:
                break
            }
        }
    }
    
    private func showPhotoGallery() {
        fetchFiles()
    }
    
    private func fetchFiles() {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            var fetchResult: PHFetchResult<PHAsset>?
            
            switch currentMediaType {
            case .image, .favourite, .shared:
                fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                fetchResult?.enumerateObjects { (asset, index, stop) in
                    self.getPhotoDetails(asset: asset)
                }
            case .video:
                fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                fetchResult?.enumerateObjects { (asset, index, stop) in
                    self.getPhotoDetails(asset: asset)
                }
            case .document:
                for url in selectedDocumentURLs {
                    self.getDocumentDetails(url: url)
                }
            }
            
            sortSectionKeys()
            applySnapshot()
            hideProgress()
        }
    
    func getPhotoDetails(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImageDataAndOrientation(for: asset, options: options) { (data, dataUTI, orientation, info) in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            let sizeInBytes = data.count // Size in bytes
            let sizeInMB = Double(sizeInBytes) / (1024 * 1024) // Convert bytes to MB
            let sizeInGB = sizeInMB / 1024 // Convert MB to GB
            
            let formattedSizeInMB = String(format: "%.2f MB", sizeInMB)
            let formattedSizeInGB = String(format: "%.2f GB", sizeInGB)
            
            let dateCreated = asset.creationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let dateCreatedString = dateFormatter.string(from: dateCreated ?? Date())
            
            let imageName = "\(asset.localIdentifier)"
            let imageInfo = MediaData(icon: image, size: "\(formattedSizeInMB)", name: imageName, createdAt: dateCreatedString,type: .video, asset: asset, url: nil)
            
            self.filesDataSource[dateCreatedString, default: []].append(imageInfo)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getDocumentDetails(url: URL) {
            let fileManager = FileManager.default
            let attributes = try? fileManager.attributesOfItem(atPath: url.path)
            let fileSize = attributes?[.size] as? NSNumber
            let sizeInBytes = fileSize?.intValue ?? 0
            let sizeInMB = Double(sizeInBytes) / (1024 * 1024) // Convert bytes to MB
            
            let formattedSizeInMB = String(format: "%.2f MB", sizeInMB)
            
            let dateCreated = attributes?[.creationDate] as? Date ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let dateCreatedString = dateFormatter.string(from: dateCreated)
            
            let documentName = url.lastPathComponent
            let documentIcon = UIImage(named: "documentsImage") ?? UIImage() // Placeholder icon for documents
            
        let documentInfo = MediaData(icon: documentIcon, size: "\(formattedSizeInMB)", name: documentName, createdAt: dateCreatedString, type: .document, asset: nil, url: url)
            
            self.filesDataSource[dateCreatedString, default: []].append(documentInfo)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    
    
    func handlePermissionDenied() {
        // Code to handle permission denial
        // Show an alert to the user explaining why the permission is needed
        DispatchQueue.main.async {
            self.showSettingsAlert()
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Photos Permission Denied",
            message: "Please allow access to your photos in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { success in
                    // Possibly handle success or failure
                })
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    private func playVideo(asset: PHAsset) {
        let videoOptions = PHVideoRequestOptions()
        videoOptions.isNetworkAccessAllowed = true
        
        imageManager.requestAVAsset(forVideo: asset, options: videoOptions) { avAsset, _, _ in
            guard let avAsset = avAsset else { return }
            DispatchQueue.main.async {
            let playerItem = AVPlayerItem(asset: avAsset)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, MediaData>(collectionView: collectionView) { collectionView, indexPath, imageData -> UICollectionViewCell? in
            switch self.currentViewType {
            case .grid:
                switch self.currentMediaType {
                case .image, .video, .favourite, .shared:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
                    cell.imagesView.image = imageData.icon
                    cell.sizeLabel.text = imageData.size
                    cell.imageNameLabel.text = imageData.name
                    let isSelected = self.selectedIndexPaths.contains(indexPath)
                    cell.setSelected(isSelected)
                    cell.button.tag = indexPath.item
                    cell.button.params = (section: indexPath.section, item: indexPath.item)
                    cell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    return cell
                case .document:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentTableViewCell.reuseIdentifier, for: indexPath) as! DocumentTableViewCell
                    cell.imagesView.image = imageData.icon
                    cell.sizeLabel.text = imageData.size
                    cell.documentNameLabel.text = imageData.name
                    let isSelected = self.selectedIndexPaths.contains(indexPath)
                    cell.setSelected(isSelected)
                    cell.button.tag = indexPath.item
                    cell.button.params = (section: indexPath.section, item: indexPath.item)
                    cell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    return cell
                }
                
                
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell1.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell1
                cell.imagesView.image = imageData.icon
                cell.sizeLabel.text = imageData.size
                cell.imageNameLabel.text = imageData.name
                let isSelected = self.selectedIndexPaths.contains(indexPath)
                cell.setSelected(isSelected)
//                cell.optionsButton.tag = indexPath.item
//                self.selectedSection = indexPath.section
//                cell.optionsButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                cell.optionsButton.params = (section: indexPath.section, item: indexPath.item)
                cell.optionsButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DateHeaderView.reuseIdentifier, for: indexPath) as! DateHeaderView
                let dateKey = self.sortedSectionKeys[indexPath.section]
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let sectionDate = formatter.date(from: dateKey), Calendar.current.isDateInToday(sectionDate) {
                    headerView.label.text = "Today"
                } else {
                    headerView.label.text = dateKey
                }
                
                return headerView
            }
            return nil
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard !sortedSectionKeys.isEmpty else { return }
        var snapshot = NSDiffableDataSourceSnapshot<String, MediaData>()
        for section in sortedSectionKeys {
            snapshot.appendSections([section])
            if let items = filesDataSource[section] {
                snapshot.appendItems(items)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    
    private func sortSectionKeys() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        sortedSectionKeys = filesDataSource.keys.sorted {
            formatter.date(from: $0) ?? Date() > formatter.date(from: $1) ?? Date()
        }
    }
    
    private func filterView() {
        let filterContainerStackView = UIStackView()
        filterContainerStackView.axis = .horizontal
        filterContainerStackView.distribution = .fillEqually
        filterContainerStackView.spacing = DesignMetrics.Padding.size28
        
        let filterView = UIView()
        filterView.backgroundColor = .clear
        
        let filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        filterStackView.spacing = DesignMetrics.Padding.size8
        
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        filterButton.widthAnchor == DesignMetrics.Dimensions.width18
        filterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        filterView.addSubview(filterStackView)
        filterStackView.addArrangedSubview(filterButton)
        filterStackView.addArrangedSubview(filterNameLabel)
        filterStackView.edgeAnchors == filterView.edgeAnchors
        
        let gridAndListView = UIView()
        gridAndListView.backgroundColor = .clear
        
        let gridAndListStackView = UIStackView()
        gridAndListStackView.axis = .horizontal
        gridAndListStackView.spacing = DesignMetrics.Padding.size12
        
        listViewButton.widthAnchor == DesignMetrics.Dimensions.width22
        gridViewButton.widthAnchor == DesignMetrics.Dimensions.width22
        
        gridAndListView.addSubview(gridAndListStackView)
        gridAndListStackView.addArrangedSubview(UIView())
        gridAndListStackView.addArrangedSubview(listViewButton)
        gridAndListStackView.addArrangedSubview(gridViewButton)
        gridAndListStackView.edgeAnchors == gridAndListView.edgeAnchors
        
        listViewButton.addTarget(self, action: #selector(listViewButtonTapped(_:)), for: .touchUpInside)
        gridViewButton.addTarget(self, action: #selector(gridViewButtonTapped(_:)), for: .touchUpInside)
        
        filterView.addSubview(filterStackView)
        filterStackView.edgeAnchors == filterView.edgeAnchors
        
        filterContainerView.addSubview(filterContainerStackView)
        filterContainerStackView.addArrangedSubview(filterView)
        filterContainerStackView.addArrangedSubview(gridAndListView)
        
        filterContainerStackView.verticalAnchors == filterContainerView.verticalAnchors
        filterContainerStackView.horizontalAnchors == filterContainerView.horizontalAnchors + DesignMetrics.Padding.size12
        appendViewToMainVStack(view: filterContainerView, topPadding: 24)
    }
    
    @objc private func uploadButtonTapped(_ sender: UIButton) {
        self.gotoUploadInfoViewController()
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let actionSheetVC = CustomActionSheetViewController()
        actionSheetVC.modalPresentationStyle = .overCurrentContext
        actionSheetVC.modalTransitionStyle = .crossDissolve
        
        actionSheetVC.selectionHandler = { [weak self] selectedOption in
            self?.handleFilterSelection(selectedOption)
        }
        
        present(actionSheetVC, animated: true, completion: nil)
    }
    
    @objc private func verticalDotTapped(_ sender: UIButton) {
        guard let params = sender.params else {
                print("No parameters found")
                return
            }

            let section = params.section
            let item = params.item
        
        let indexPath = IndexPath(item: item, section: section) // Adjust section as needed
        let dateKey = sortedSectionKeys[indexPath.section]
        switch currentMediaType {
        case .image,.favourite,.shared:
            let imageName = filesDataSource[dateKey]?[indexPath.item].name ?? ""
                        let options = [
                            BottomSheetOption(icon: UIImage(named: "shareIcon")!, title: "Share"),
                            BottomSheetOption(icon: UIImage(named: "accessIcon")!, title: "Manage Access"),
                            BottomSheetOption(icon: UIImage(named: "favouriteIcon")!, title: "Add To Favourite"),
                            BottomSheetOption(icon: UIImage(named: "offlineIcon")!, title: "Make Available Offline"),
                            BottomSheetOption(icon: UIImage(named: "linkCopyIcon")!, title: "Copy Link"),
                            BottomSheetOption(icon: UIImage(named: "copyIcon")!, title: "Make a Copy"),
                            BottomSheetOption(icon: UIImage(named: "sendIcon")!, title: "Send a Copy"),
                            BottomSheetOption(icon: UIImage(named: "openWithIcon")!, title: "Open With"),
                            BottomSheetOption(icon: UIImage(named: "downloadIcon")!, title: "Download in Device"),
                            BottomSheetOption(icon: UIImage(named: "renameIcon")!, title: "Rename"),
                            BottomSheetOption(icon: UIImage(named: "moveIcon")!, title: "Move"),
                            BottomSheetOption(icon: UIImage(named: "deleteIcon")!, title: "Delete"),
                            // Add more options here
                        ]
            if let mediaData = filesDataSource[dateKey]?[indexPath.item] {
                       
                let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: options, previewImage: mediaData.icon)
                                       self.navigationController?.pushViewController(imagePreviewVC, animated: true)
                       
                   }
        case .video:
            if let mediaData = filesDataSource[dateKey]?[indexPath.item] {
                if let asset = mediaData.asset {
                    playVideo(asset: asset)
                }
            }
        case .document:
            if let mediaData = filesDataSource[dateKey]?[indexPath.item] {
                if let documentUrl = mediaData.url {
                    previewDocument(at: documentUrl)
                }
            }
        }
    }
    
    private func previewDocument(at url: URL) {
        documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    private func handleFilterSelection(_ selectedOption: String) {
        print("Selected filter option: \(selectedOption)")
        // Handle the selected option as needed
        filterNameLabel.text = selectedOption
    }
    
    private func setupCollectionView() {
        appendViewToMainVStack(view: collectionView, topPadding: 24)
    }
    
    func updateSelectionState() {
        let selectedItemsCount = getSelectedItems().count
        areAllCellsSelected() ? showCheckBoxChecked() : showCheckBoxUnChecked()
        if selectedItemsCount > 0 {
            showFocusbandOptionFromNavBar()
            showHideFooterView(isShowFooterView: true)
            let newTitle = "\(spacerString)\(selectedIndexPaths.count) Files Selected"
            changeTitle(titleOfNavigation: newTitle)
            
        } else {
            showHideFooterView(isShowFooterView: false)
            hideFocusbandOptionFromNavBar()
            selectedItemSize = 0.0
            switch currentMediaType {
                
            case .image:
                changeTitle(titleOfNavigation: "Photos")
            case .video:
                changeTitle(titleOfNavigation: "Videos")
            case .favourite:
                changeTitle(titleOfNavigation: "\(spacerString)Favourite Files")
            case .shared:
                changeTitle(titleOfNavigation: "\(spacerString)Shared Files")
            case .document:
                changeTitle(titleOfNavigation: "Documents")
            }
           
        }
        
    }
    
    func getSelectedItems() -> [MediaData] {
        var selectedItems: [MediaData] = []
        selectedItemSize = 0.0
        for indexPath in selectedIndexPaths {
            let dateKey = sortedSectionKeys[indexPath.section]
            if let item = filesDataSource[dateKey]?[indexPath.item] {
                let sizeLabelItems = item.size.split(separator: " ")
                let sizeInString = sizeLabelItems[0]
                let sizeInDouble = Double(sizeInString)
                selectedItemSize = selectedItemSize + (sizeInDouble ?? 0.0)
                selectedItems.append(item)
            }
        }
        return selectedItems
    }
    
    func areAllCellsSelected() -> Bool {
        var totalItems = 0
        
        // Count all items in all sections
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            totalItems += collectionView.numberOfItems(inSection: section)
        }
        
        // Compare the total number of items with the count of selected items
        return selectedIndexPaths.count == totalItems
    }
    
    override func checkboxButtonAction() {
        areAllCellsSelected() ? removeAllItems() : selectAllItems()
    }
    
    override func changeTitle(titleOfNavigation: String) {
        super.changeTitle(titleOfNavigation: titleOfNavigation)
    }
    
    func selectAllItems() {
        selectedIndexPaths.removeAll()
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                selectedIndexPaths.insert(indexPath)
            }
        }
        
        collectionView.reloadData()
        updateSelectionState()
    }
    
    func removeAllItems() {
        selectedIndexPaths.removeAll()
        collectionView.reloadData()
        updateSelectionState()
    }
    
    private func gotoUploadInfoViewController() {
        let uploadVC = UploadInfoViewController()
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.currentViewType {
        case .grid:
            switch self.currentMediaType {
            case .image, .video, .favourite, .shared:
                let cell = collectionView.cellForItem(at: indexPath) as! ImagesCollectionViewCell
                let isSelected = selectedIndexPaths.contains(indexPath)
                if(isSelected) {
                    selectedIndexPaths.remove(indexPath)
                    cell.setSelected(false)
                }
                else {
                    selectedIndexPaths.insert(indexPath)
                    cell.setSelected(true)
                }
            case .document:
                let cell = collectionView.cellForItem(at: indexPath) as! DocumentTableViewCell
                let isSelected = selectedIndexPaths.contains(indexPath)
                if(isSelected) {
                    selectedIndexPaths.remove(indexPath)
                    cell.setSelected(false)
                }
                else {
                    selectedIndexPaths.insert(indexPath)
                    cell.setSelected(true)
                }
            }
            
        case .list:
            let cell = collectionView.cellForItem(at: indexPath) as! ImagesCollectionViewCell1
            let isSelected = selectedIndexPaths.contains(indexPath)
            if(isSelected) {
                selectedIndexPaths.remove(indexPath)
                cell.setSelected(false)
            }
            else {
                selectedIndexPaths.insert(indexPath)
                cell.setSelected(true)
            }
        }
        
        updateSelectionState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch self.currentViewType {
        case .grid:
            switch self.currentMediaType {
            case .image, .video, .favourite, .shared:
                let cell = collectionView.cellForItem(at: indexPath) as! ImagesCollectionViewCell
                let isSelected = selectedIndexPaths.contains(indexPath)
                if(isSelected) {
                    selectedIndexPaths.remove(indexPath)
                    cell.setSelected(false)
                }
                else {
                    selectedIndexPaths.insert(indexPath)
                    cell.setSelected(true)
                }
            case .document:
                let cell = collectionView.cellForItem(at: indexPath) as! DocumentTableViewCell
                let isSelected = selectedIndexPaths.contains(indexPath)
                if(isSelected) {
                    selectedIndexPaths.remove(indexPath)
                    cell.setSelected(false)
                }
                else {
                    selectedIndexPaths.insert(indexPath)
                    cell.setSelected(true)
                }
            }
        case .list:
            let cell = collectionView.cellForItem(at: indexPath) as! ImagesCollectionViewCell1
            let isSelected = selectedIndexPaths.contains(indexPath)
            if(isSelected) {
                selectedIndexPaths.remove(indexPath)
                cell.setSelected(false)
            }
            else {
                selectedIndexPaths.insert(indexPath)
                cell.setSelected(true)
            }
        }
        
        updateSelectionState()
    }
}

extension PhotosViewController: UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {
    // UIDocumentPickerDelegate methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedDocumentURLs.append(contentsOf: urls)
        fetchFiles()
    }
    
    // UIDocumentInteractionControllerDelegate methods
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

enum ViewType {
    case grid
    case list
}
