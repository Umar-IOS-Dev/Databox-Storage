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
import SDWebImage

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
        filterNameLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
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
    private let filterButton : UIButton = {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        return filterButton
    }()
    private let uploadSizeLabel: UILabel = {
        let uploadSizeLabel = UILabel()
        uploadSizeLabel.textAlignment = .left
        uploadSizeLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        uploadSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 28)
        uploadSizeLabel.text = "0.0 MB"
        return uploadSizeLabel
    }()
    private let uploadSubHeadingLabel: UILabel = {
        let uploadSubHeadingLabel = UILabel()
        uploadSubHeadingLabel.textAlignment = .left
        uploadSubHeadingLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        uploadSubHeadingLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
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
    private let imageManager = PHCachingImageManager()
    private let spacerString:String = "    "
    private var batchSize = 100
    private var currentBatchIndex = 0
    private var isUpdatingLayout = false
    private var fetchResult: PHFetchResult<PHAsset>?
    private var imageRequestIDs: [String: PHImageRequestID] = [:]
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
        collectionView.register(ImagesCollectionViewCell1.self, forCellWithReuseIdentifier: ImagesCollectionViewCell1.reuseIdentifier)
        collectionView.register(DateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private var layoutUpdateWorkItem: DispatchWorkItem?
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
    
    deinit {
        print("PhotosViewController is being deallocated")
        // Remove target to break any strong references
        uploadButton.removeTarget(self, action: #selector(self.uploadButtonTapped(_:)), for: .touchUpInside)
        filterButton.removeTarget(self, action: #selector(self.filterButtonTapped(_:)), for: .touchUpInside)
        listViewButton.removeTarget(self, action: #selector(listViewButtonTapped(_:)), for: .touchUpInside)
        gridViewButton.removeTarget(self, action: #selector(gridViewButtonTapped(_:)), for: .touchUpInside)
        
        
        // Clear image cache
        SDImageCache.shared.clearMemory()
        
        // Nullify fetch result
        fetchResult = nil
        
        // Cancel any ongoing image fetch requests
        imageManager.stopCachingImagesForAllAssets()
        
        // Clear any large data structures
        filesDataSource.removeAll()
        
        // Release collection view data source and delegate
        // collectionView.dataSource = nil
        //  collectionView.delegate = nil
        
        // Unload the collection view if possible
        // collectionView.removeFromSuperview()
        //  dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureDataSource()
        // setupData() // Moved setupData here to ensure dataSource is initialized before applying snapshot
        collectionView.delegate = self
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
            collectionView.register(DocumentTableViewCell.self, forCellWithReuseIdentifier: DocumentTableViewCell.reuseIdentifier)
        }
        
        hideFocusbandOptionFromNavBar()
        showHideFooterView(isShowFooterView: false)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        SDImageCache.shared.clearDisk(onCompletion: nil)
        SDImageCache.shared.clearMemory()
    }
    
    private func presentDocumentPicker() {
        //var documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            DispatchQueue.main.async {
                let documentPicker: UIDocumentPickerViewController
                documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = true
                self.present(documentPicker, animated: true, completion: nil)
            }
            
        } else {
            // Fallback on earlier versions
            // documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .import)
        }
        
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
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
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil } // Safely unwrap self
            
            switch self.currentViewType {
            case .grid:
                // Grid layout
                let itemHeight: CGFloat = 82
                let spacing: CGFloat = 5
                let itemsPerRow: CGFloat = 3
                
                let availableWidth = environment.container.effectiveContentSize.width
                // Calculate the width for each item to fit exactly 3 items per row
                let itemWidth = (availableWidth - 30) / itemsPerRow
                
                // Define item size with the calculated width
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(itemWidth),
                    heightDimension: .absolute(itemHeight)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                // Define group size with full width and item height
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(itemHeight)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(spacing)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                
                
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
            }
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        return layout
    }
    
    @objc private func listViewButtonTapped(_ sender: UIButton) {
        currentViewType = .list
        listViewButton.setImage(UIImage(named: "listViewSelectedIcon"), for: .normal)
        gridViewButton.setImage(UIImage(named: "gridViewDeselectedIcon"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.switchToGridLayout()
        }
    }
    
    @objc private func gridViewButtonTapped(_ sender: UIButton) {
        currentViewType = .grid
        gridViewButton.setImage(UIImage(named: "gridViewSelectedIcon"), for: .normal)
        listViewButton.setImage(UIImage(named: "listViewDeselectedIcon"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.switchToGridLayout()
        }
    }
    
    func updateLayout(to layout: UICollectionViewLayout, animated: Bool = true) {
        // Cancel any existing layout update work item
        layoutUpdateWorkItem?.cancel()
        
        // Create a new work item to perform the layout update
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            if self.isUpdatingLayout {
                // If a layout update is in progress, delay the new layout change
                self.updateLayout(to: layout, animated: animated)
                return
            }
            
            self.isUpdatingLayout = true
            self.collectionView.setCollectionViewLayout(layout, animated: animated) { [weak self] _ in
                guard let self = self else { return }
                
                self.isUpdatingLayout = false
                self.applySnapshot()
                self.configureDataSource()
                
                // Optional: Log or debug here
                print("Layout updated and data source configured.")
                
                // Explicitly release the work item
                self.layoutUpdateWorkItem = nil
            }
        }
        
        // Schedule the work item
        layoutUpdateWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }
    
    
    func switchToGridLayout() {
        let gridLayout = createLayout() // Your method to create grid layout
        updateLayout(to: gridLayout)
    }
    
    func requestPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.showProgress()
                    self.showPhotoGallery()
                }
                print("Authorized Gallery")
            case .denied, .restricted, .notDetermined:
                // Handle permission denial
                print("Denied")
                DispatchQueue.main.async {
                    self.handlePermissionDenied()
                }
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
        
        switch currentMediaType {
        case .image, .favourite, .shared:
            fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        case .video:
            fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        case .document:
            for url in selectedDocumentURLs {
                self.getDocumentDetails(url: url)
            }
            self.applySnapshot()
            
            return
        }
        
        loadNextBatch()
    }
    

    
    func getPhotoDetails(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImageDataAndOrientation(for: asset, options: options) { [weak self] (data, dataUTI, orientation, info) in
            guard let self = self, let data = data else { return }
            
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
            let imageInfo = MediaData(icon: UIImage(), size: "\(formattedSizeInMB)", name: imageName, createdAt: dateCreatedString, type: .video, asset: asset, url: nil)
            
            self.filesDataSource[dateCreatedString, default: []].append(imageInfo)
        }
    }
    
    private func loadNextBatch() {
        guard let fetchResult = fetchResult else { return }
        
        let start = currentBatchIndex * batchSize
        let end = min(start + batchSize, fetchResult.count)
        
        if start < end {
            for index in start..<end {
                let asset = fetchResult.object(at: index)
                self.getPhotoDetails(asset: asset)
            }
            currentBatchIndex += 1
            self.applySnapshot()
            sortSectionKeys()

            // Check if there are more assets to load
            if end < fetchResult.count {
                // Trigger the next batch
                loadNextBatch()
            }
        }
        
        self.hideProgress()
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
        videoOptions.version = .original // Ensure we get the original version of the video
        
        imageManager.requestAVAsset(forVideo: asset, options: videoOptions) { avAsset, _, info in
            // Handle errors and check if asset was successfully retrieved
            if let error = info?[PHImageErrorKey] as? Error {
                DispatchQueue.main.async {
                    // Optionally show an alert or error message to the user
                    print("Error retrieving video asset: \(error.localizedDescription)")
                }
                return
            }
            
            guard let avAsset = avAsset else {
                DispatchQueue.main.async {
                    print("No AVAsset retrieved")
                }
                return
            }
            
            DispatchQueue.main.async {
                // Create player item and player
                let playerItem = AVPlayerItem(asset: avAsset)
                let player = AVPlayer(playerItem: playerItem)
                player.allowsExternalPlayback = true
                // Create player view controller
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                // Present player view controller
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, MediaData>(collectionView: collectionView) { [weak self] collectionView, indexPath, imageData -> UICollectionViewCell? in
            guard let self = self else { return nil }
            
            switch self.currentViewType {
            case .grid:
                switch self.currentMediaType {
                case .image, .video, .favourite, .shared:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
                    if let asset = imageData.asset {
                        loadImage(for: asset, into: cell, ImageName: imageData.name, ImageSize: imageData.size, cellindexPath: indexPath)
                    }
                    //  cell.configure(with: imageData)
//                    let isSelected = self.selectedIndexPaths.contains(indexPath)
//                    cell.setSelected(isSelected)
//                    cell.button.tag = indexPath.item
//                    cell.button.params = (section: indexPath.section, item: indexPath.item)
//                    cell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    return cell
                    
                case .document:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentTableViewCell.reuseIdentifier, for: indexPath) as! DocumentTableViewCell
                    cell.configure(with: imageData)
                    let isSelected = self.selectedIndexPaths.contains(indexPath)
                    cell.setSelected(isSelected)
                    cell.button.tag = indexPath.item
                    cell.button.params = (section: indexPath.section, item: indexPath.item)
                    cell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    return cell
                }
                
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell1.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell1
                if let asset = imageData.asset {
                    loadImage(for: asset, into: cell, ImageName: imageData.name, ImageSize: imageData.size, cellindexPath: indexPath)
                }
                // cell.configure(with: imageData)
                let isSelected = self.selectedIndexPaths.contains(indexPath)
                cell.setSelected(isSelected)
                cell.optionsButton.params = (section: indexPath.section, item: indexPath.item)
                cell.optionsButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard !self.sortedSectionKeys.isEmpty else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<String, MediaData>()
            for section in self.sortedSectionKeys {
                snapshot.appendSections([section])
                if let items = self.filesDataSource[section] {
                    snapshot.appendItems(items)
                }
            }
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences) {
                // self.configureDataSource()
            }
        }
    }
    
    
    private func sortSectionKeys() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        sortedSectionKeys = filesDataSource.keys.sorted { [weak self] in
            guard let _ = self else { return false }
            return formatter.date(from: $0) ?? Date() > formatter.date(from: $1) ?? Date()
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
        //        duplicateImages(inDirectory: "/Users/appinatorstechnology/Library/Developer/CoreSimulator/Devices/66D8CFB8-36E1-4376-BCD7-C502EAFE114A/data/Media/DCIM/100APPLE", count: 507)
    }
    
    func duplicateImages(inDirectory directory: String, count: Int) {
        let fileManager = FileManager.default
        
        // Ensure the target directory exists
        guard fileManager.fileExists(atPath: directory) else {
            print("Directory does not exist: \(directory)")
            return
        }
        
        do {
            // Get all image files in the target directory
            let imageFiles = try fileManager.contentsOfDirectory(atPath: directory).filter { fileName in
                let fileExtension = (fileName as NSString).pathExtension.lowercased()
                return fileExtension == "jpg" || fileExtension == "png"
            }
            
            guard !imageFiles.isEmpty else {
                print("No images found in the directory.")
                return
            }
            
            // Duplicate images
            for i in 7..<count {
                let imageName = imageFiles[i % imageFiles.count]
                let sourcePath = (directory as NSString).appendingPathComponent(imageName)
                let fileExtension = (imageName as NSString).pathExtension
                let newImageName = "\(UUID().uuidString).\(fileExtension)"
                let destinationPath = (directory as NSString).appendingPathComponent(newImageName)
                
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            }
            
            print("\(count) images duplicated successfully.")
            
        } catch {
            print("Error duplicating images: \(error)")
        }
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
            let optionsForImage = [
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
                
//                let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: optionsForImage, previewImage: mediaData.icon)
//                self.navigationController?.pushViewController(imagePreviewVC, animated: true)
                
                let imageManager = PHImageManager.default()
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    options.deliveryMode = .highQualityFormat

                    // Set the target size based on your needs
                    let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                imageManager.requestImage(for: mediaData.asset!, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
                        guard let self = self, let image = image else {
                            print("Failed to get the image from the asset")
                            return
                        }

                        // Initialize your ImagePreviewViewController with the fetched image
                        let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: optionsForImage, previewImage: image)
                        self.navigationController?.pushViewController(imagePreviewVC, animated: true)
                    }
                
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
            let newTitle = "\(spacerString)\(selectedItemsCount) Files Selected"
            changeTitle(titleOfNavigation: newTitle)
        } else {
            showHideFooterView(isShowFooterView: false)
            hideFocusbandOptionFromNavBar()
            selectedItemSize = 0.0
            
            let defaultTitles: [MediaType: String] = [
                .image: "Photos",
                .video: "Videos",
                .favourite: "\(spacerString)Favourite Files",
                .shared: "\(spacerString)Shared Files",
                .document: "Documents"
            ]
            
            changeTitle(titleOfNavigation: defaultTitles[currentMediaType] ?? "Files")
        }
    }
    
    func getSelectedItems() -> [MediaData] {
        selectedItemSize = 0.0
        var selectedItems: [MediaData] = []
        
        for indexPath in selectedIndexPaths {
            let dateKey = sortedSectionKeys[indexPath.section]
            if let item = filesDataSource[dateKey]?[indexPath.item] {
                if let sizeInDouble = Double(item.size.split(separator: " ").first ?? "0.0") {
                    selectedItemSize += sizeInDouble
                    selectedItems.append(item)
                }
            }
        }
        return selectedItems
    }
    
    func areAllCellsSelected() -> Bool {
        let totalItems = (0..<collectionView.numberOfSections).reduce(0) {
            $0 + collectionView.numberOfItems(inSection: $1)
        }
        return selectedIndexPaths.count == totalItems
    }
    
    func selectAllItems() {
        selectedIndexPaths = Set((0..<collectionView.numberOfSections).flatMap { section in
            (0..<collectionView.numberOfItems(inSection: section)).map {
                IndexPath(item: $0, section: section)
            }
        })
        
        updateSelectionState()
        applySnapshot()
        configureDataSource()
    }
    
    func removeAllItems() {
        selectedIndexPaths.removeAll()
        
        updateSelectionState()
        applySnapshot()
        configureDataSource()
    }
    
    override func checkboxButtonAction() {
        areAllCellsSelected() ? removeAllItems() : selectAllItems()
    }
    
    override func changeTitle(titleOfNavigation: String) {
        super.changeTitle(titleOfNavigation: titleOfNavigation)
    }
    
    private func gotoUploadInfoViewController() {
        let uploadVC = UploadInfoViewController()
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
}

extension PhotosViewController: UICollectionViewDelegate , UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.currentViewType {
        case .grid:
            switch self.currentMediaType {
            case .image, .video, .favourite, .shared:
                let cell = collectionView.cellForItem(at: indexPath)
                let isSelected = selectedIndexPaths.contains(indexPath)
                
                if isSelected {
                    selectedIndexPaths.remove(indexPath)
                    (cell as? ImagesCollectionViewCell)?.setSelected(false)
                } else {
                    selectedIndexPaths.insert(indexPath)
                    (cell as? ImagesCollectionViewCell)?.setSelected(true)
                }
            case .document:
                let cell = collectionView.cellForItem(at: indexPath)
                let isSelected = selectedIndexPaths.contains(indexPath)
                
                if isSelected {
                    selectedIndexPaths.remove(indexPath)
                    (cell as? DocumentTableViewCell)?.setSelected(false)
                } else {
                    selectedIndexPaths.insert(indexPath)
                    (cell as? DocumentTableViewCell)?.setSelected(true)
                }
            }
        case .list:
            let cell = collectionView.cellForItem(at: indexPath)
            let isSelected = selectedIndexPaths.contains(indexPath)
            
            if isSelected {
                selectedIndexPaths.remove(indexPath)
                (cell as? ImagesCollectionViewCell1)?.setSelected(false)
            } else {
                selectedIndexPaths.insert(indexPath)
                (cell as? ImagesCollectionViewCell1)?.setSelected(true)
            }
        }
        
        updateSelectionState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch self.currentViewType {
        case .grid:
            switch self.currentMediaType {
            case .image, .video, .favourite, .shared:
                let cell = collectionView.cellForItem(at: indexPath)
                let isSelected = selectedIndexPaths.contains(indexPath)
                
                if isSelected {
                    selectedIndexPaths.remove(indexPath)
                    (cell as? ImagesCollectionViewCell)?.setSelected(false)
                } else {
                    selectedIndexPaths.insert(indexPath)
                    (cell as? ImagesCollectionViewCell)?.setSelected(true)
                }
            case .document:
                let cell = collectionView.cellForItem(at: indexPath)
                let isSelected = selectedIndexPaths.contains(indexPath)
                
                if isSelected {
                    selectedIndexPaths.remove(indexPath)
                    (cell as? DocumentTableViewCell)?.setSelected(false)
                } else {
                    selectedIndexPaths.insert(indexPath)
                    (cell as? DocumentTableViewCell)?.setSelected(true)
                }
            }
        case .list:
            let cell = collectionView.cellForItem(at: indexPath)
            let isSelected = selectedIndexPaths.contains(indexPath)
            
            if isSelected {
                selectedIndexPaths.remove(indexPath)
                (cell as? ImagesCollectionViewCell1)?.setSelected(false)
            } else {
                selectedIndexPaths.insert(indexPath)
                (cell as? ImagesCollectionViewCell1)?.setSelected(true)
            }
        }
        
        updateSelectionState()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay Called for indexPath = \(indexPath.item)")
        let section = sortedSectionKeys[indexPath.section]
        if let items = filesDataSource[section], indexPath.item < items.count {
            let mediaData = items[indexPath.item]
            loadImage(for: mediaData.asset!, into: cell, ImageName: mediaData.name, ImageSize: mediaData.size, cellindexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("didEndDisplaying Called for indexPath = \(indexPath.item)")
        // Handle cells that are no longer visible
          let section = sortedSectionKeys[indexPath.section]
          if let items = filesDataSource[section], indexPath.item < items.count {
              let mediaData = items[indexPath.item]
              cancelImageLoad(for: mediaData.asset!)
          }
          
          // Remove button targets
          if let imagesCell = cell as? ImagesCollectionViewCell {
              imagesCell.button.removeTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
          } else if let imagesCell1 = cell as? ImagesCollectionViewCell1 {
              imagesCell1.optionsButton.removeTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
          }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    private func loadImage(for asset: PHAsset, into cell: UICollectionViewCell, ImageName: String, ImageSize: String, cellindexPath: IndexPath) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        // Adjust the target size based on the current layout
        let targetSize: CGSize
        if currentViewType == .grid {
            targetSize = CGSize(width: 80, height: 80) // Adjusted for grid view
        } else {
            targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.height) // Adjusted for list view
        }
        
        // Cancel any existing request for this asset
        cancelImageLoad(for: asset)
        
        let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { [weak cell] (image, info) in
            guard let cell = cell else { return }
            
            DispatchQueue.main.async {
                if let gridCell = cell as? ImagesCollectionViewCell {
                    // Update image for grid cell
                    if gridCell.isDescendant(of: gridCell.superview ?? UIView()) {
                        gridCell.imagesView.image = image
                        gridCell.imageNameLabel.text = ImageName
                        gridCell.sizeLabel.text = ImageSize
                        let isSelected = self.selectedIndexPaths.contains(cellindexPath)
                        gridCell.setSelected(isSelected)
                        gridCell.button.tag = cellindexPath.item
                        gridCell.button.params = (section: cellindexPath.section, item: cellindexPath.item)
                        gridCell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    }
                } else if let listCell = cell as? ImagesCollectionViewCell1 {
                    // Update image for list cell
                    if listCell.isDescendant(of: listCell.superview ?? UIView()) {
                        listCell.imagesView.image = image
                        listCell.imageNameLabel.text = ImageName
                        listCell.sizeLabel.text = ImageSize
                        let isSelected = self.selectedIndexPaths.contains(cellindexPath)
                        listCell.setSelected(isSelected)
                        listCell.optionsButton.tag = cellindexPath.item
                        listCell.optionsButton.params = (section: cellindexPath.section, item: cellindexPath.item)
                        listCell.optionsButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                    }
                }
            }
        }
        
        // Track the request ID for cancellation if needed
        let assetIdentifier = asset.localIdentifier
        imageRequestIDs[assetIdentifier] = requestID
    }
    
    private func cancelImageLoad(for asset: PHAsset) {
        let assetIdentifier = asset.localIdentifier
        if let requestID = imageRequestIDs[assetIdentifier] {
            PHImageManager.default().cancelImageRequest(requestID)
            imageRequestIDs.removeValue(forKey: assetIdentifier)
        }
        
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
