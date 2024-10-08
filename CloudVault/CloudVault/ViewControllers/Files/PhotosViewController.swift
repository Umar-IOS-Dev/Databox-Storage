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
import FirebaseAuth

class PhotosViewController: BaseViewController {
    
    private let filterContainerView = UIView()
    private let filterNameLabel: UILabel = {
        let filterNameLabel = UILabel()
        filterNameLabel.textAlignment = .left
        filterNameLabel.textColor = UIColor(named: "appPrimaryTextColor")
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
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        return filterButton
    }()
    private let uploadSizeLabel: UILabel = {
        let uploadSizeLabel = UILabel()
        uploadSizeLabel.textAlignment = .left
        uploadSizeLabel.textColor = UIColor(named: "appPrimaryTextColor")
        uploadSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 28)
        uploadSizeLabel.text = "0.0 MB"
        return uploadSizeLabel
    }()
    private let uploadSubHeadingLabel: UILabel = {
        let uploadSubHeadingLabel = UILabel()
        uploadSubHeadingLabel.textAlignment = .left
        uploadSubHeadingLabel.textColor = UIColor(named: "appPrimaryTextColor")
        uploadSubHeadingLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        uploadSubHeadingLabel.text = "selected to upload on databox"
        return uploadSubHeadingLabel
    }()
    static let sharedFavorite: PhotosViewController = {
           let instance = PhotosViewController(currentMediaType: .favourite)
           // Configure instance if needed
           return instance
       }()
    static let sharedShared: PhotosViewController = {
           let instance = PhotosViewController(currentMediaType: .shared)
           // Configure instance if needed
           return instance
       }()
    
    private var pinchGesture: UIPinchGestureRecognizer?
    private var longPressGesture: UILongPressGestureRecognizer?
    private var imagePreviewTransitioningDelegate: ImagePreviewTransitioningDelegate?
    private var isSelectionModeActive = false
    private var currentZoomScale: CGFloat = 1.0
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
        }
    }
    
    
    
     init(currentMediaType: MediaType) {
        print("comes in init deallocated")
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
//         collectionView.dataSource = nil
          collectionView.delegate = nil
        
        // Unload the collection view if possible
        collectionView.removeFromSuperview()
        dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        print("comes in viewDidLoad deallocated")
        // Add the pinch gesture recognizer to the collection view
        self.showProgress()
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
        if longPressGesture == nil || pinchGesture == nil {
            addGestures() // Make sure gestures are added here
        }
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("comes in viewDidAppear deallocated")
        
        switch currentMediaType {
        case .image, .video, .favourite, .shared:
            if(filesDataSource.count == 0) {
               // showProgress()
                 collectionView.delegate = self
               
            }
        case .document:
            if(filesDataSource.count == 0) {
                presentDocumentPicker()
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("comes in viewDidDisappear deallocated")
        imagePreviewTransitioningDelegate = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("comes in viewWillAppear")
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        SDImageCache.shared.clearDisk(onCompletion: nil)
        SDImageCache.shared.clearMemory()
    }
    
    private func addGestures() {
        pinchGesture = nil
        longPressGesture = nil
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture?.delegate = self
        pinchGesture?.delaysTouchesBegan = true
       collectionView.addGestureRecognizer(pinchGesture!)
        // Add long press gesture recognizer to the collection view
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture?.delegate = self
        longPressGesture?.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressGesture!)
        print("Gesture Recognizers: \(collectionView.gestureRecognizers ?? [])")
    }
    
  
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let location = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: location) {
            isSelectionModeActive = true // Enable selection mode
            let isSelected = selectedIndexPaths.contains(indexPath)
            
            if isSelected {
                collectionView(collectionView, didDeselectItemAt: indexPath)
            } else {
                collectionView(collectionView, didSelectItemAt: indexPath)
            }
        }
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
        footerStackView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        
        let uploadSizeViewForLabel = UIView()
        uploadSizeViewForLabel.backgroundColor = .clear//.brown
        
        let uploadSizeStackView = UIStackView()
        uploadSizeStackView.axis = .vertical
        uploadSizeStackView.spacing = DesignMetrics.Padding.size4
        
        uploadSizeLabel.textAlignment = .left
        uploadSizeLabel.textColor = UIColor(named: "appPrimaryTextColor")
        uploadSizeLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 28)
        uploadSizeLabel.text = "0.0 MB"
        uploadSizeStackView.addArrangedSubview(uploadSizeLabel)
        uploadSizeStackView.addArrangedSubview(uploadSubHeadingLabel)
        uploadSubHeadingLabel.textAlignment = .left
        uploadSubHeadingLabel.textColor = UIColor(named: "appPrimaryTextColor")
        uploadSubHeadingLabel.font = FontManagerDatabox.shared.cloudVaultRegularText(ofSize: 12)
        uploadSubHeadingLabel.text = "selected to upload on databox"
        
        uploadSizeViewForLabel.addSubview(uploadSizeStackView)
        uploadSizeStackView.edgeAnchors == uploadSizeViewForLabel.edgeAnchors + DesignMetrics.Padding.size16
        
        let uploadButtonView = UIView()
        uploadButtonView.backgroundColor = .clear//.green
        
        uploadButtonView.addSubview(uploadButton)
        uploadButton.edgeAnchors == uploadButtonView.edgeAnchors + DesignMetrics.Padding.size16
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        uploadButton.isEnabled = true//false
        uploadButton.setTitle("Upload Photos", for: .normal)
        uploadButton.setTitleColor(titleColorForNormalState, for: .normal)
        uploadButton.layer.cornerRadius = DesignMetrics.Padding.size8
        uploadButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        
        
        
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
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
                case .began:
                    collectionView.isScrollEnabled = false
                case .changed:
            // Handle zooming logic
            // Calculate the new zoom scale
            let scale = gesture.scale
            currentZoomScale = max(0.5, min(currentZoomScale * scale, 2.3)) // Constrain zoom scale between 0.5 and 3.0

            // Set the new layout with the updated zoom scale
            collectionView.setCollectionViewLayout(createLayout(zoomScale: currentZoomScale), animated: true)

            // Reset the gesture scale to 1.0 for incremental scaling
            gesture.scale = 1.0
                case .ended, .cancelled, .failed:
                    collectionView.isScrollEnabled = true
                default:
                    break
                }
        
        
        }
    
    private func createLayout(zoomScale: CGFloat = 1.0) -> UICollectionViewCompositionalLayout {
          let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
              switch self.currentViewType {
              case .grid:
                  // Grid layout with zoom adjustment
                  let baseItemWidth: CGFloat = 82
                  let baseItemHeight: CGFloat = 82
                  let maxItemsPerRow: CGFloat = 3
                  let totalSpacing: CGFloat = 5 * (maxItemsPerRow - 1)
                  let availableWidth = environment.container.effectiveContentSize.width
                  let numberOfItemsPerRow = min(maxItemsPerRow, floor((availableWidth + 5) / (baseItemWidth * zoomScale + 5)))
                  let adjustedItemWidth = (availableWidth - (numberOfItemsPerRow - 1) * 5) / numberOfItemsPerRow
                  let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(adjustedItemWidth - 10), heightDimension: .absolute(baseItemHeight * zoomScale))
                  let item = NSCollectionLayoutItem(layoutSize: itemSize)
                  item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                  let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(baseItemHeight * zoomScale))
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
                  // List layout remains unaffected by zoom
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
    
//    func updateLayout(to layout: UICollectionViewLayout, animated: Bool = true) {
//        // Guard against redundant updates
//        guard !collectionView.collectionViewLayout.isEqual(layout) else { return }
//
//        // Cancel any existing layout update work item
//        layoutUpdateWorkItem?.cancel()
//        
//        // Save the current scroll position
//        let previousContentOffset = collectionView.contentOffset
//        
//        // Create a new work item to perform the layout update
//        let workItem = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            
//            // Ensure layout update is not in progress
//            if self.isUpdatingLayout {
//                self.updateLayout(to: layout, animated: animated)
//                return
//            }
//            
//            self.isUpdatingLayout = true
//            
//            // Update layout with or without animation
//            self.collectionView.setCollectionViewLayout(layout, animated: animated) { [weak self] _ in
//                guard let self = self else { return }
//                
//                // Configure the data source
//                self.configureDataSource()
//                
//                // Apply snapshot
//                self.collectionView.performBatchUpdates({
//                    self.applySnapshot()
//                }, completion: { [weak self] _ in
//                    guard let self = self else { return }
//                    
//                    // Restore the scroll position
//                    self.collectionView.setContentOffset(previousContentOffset, animated: false)
//
//                    self.isUpdatingLayout = false
//                    self.layoutUpdateWorkItem = nil
//                })
//            }
//        }
//        
//        // Schedule the work item
//        layoutUpdateWorkItem = workItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
//    }
    
    func updateLayout(to layout: UICollectionViewLayout, animated: Bool = true) {
        // Guard against redundant updates
        guard !collectionView.collectionViewLayout.isEqual(layout) else { return }

        // Cancel any existing layout update work item
        layoutUpdateWorkItem?.cancel()

        // Save the current indexPath and scroll position
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let previousContentOffset = collectionView.contentOffset

        // Create a new work item to perform the layout update
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            // Ensure layout update is not in progress
            if self.isUpdatingLayout {
                self.updateLayout(to: layout, animated: animated)
                return
            }

            self.isUpdatingLayout = true

            // Update layout with or without animation
            self.collectionView.setCollectionViewLayout(layout, animated: animated) { [weak self] _ in
                guard let self = self else { return }

                // Introduce a slight delay for smoother transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { // Adjust the delay as needed
                    // Configure the data source
                    self.configureDataSource()

                    // Apply snapshot
                    self.collectionView.performBatchUpdates({
                        self.applySnapshot()
                    }, completion: { [weak self] _ in
                        guard let self = self else { return }

                        // Restore the scroll position to the saved indexPath
                        if let cell = self.collectionView.cellForItem(at: currentIndexPath) {
                            let cellRect = self.collectionView.convert(cell.frame, to: self.collectionView.superview)
                            self.collectionView.scrollRectToVisible(cellRect, animated: false)
                        } else {
                            // Fallback in case the cell is not visible
                            self.collectionView.setContentOffset(previousContentOffset, animated: false)
                        }

                        self.isUpdatingLayout = false
                        self.layoutUpdateWorkItem = nil
                    })
                }
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
                    self.showPhotoGallery()
                }
            case .denied, .restricted, .notDetermined:
                // Handle permission denial
                DispatchQueue.main.async {
                    self.handlePermissionDenied()
                }
            default:
                break
            }
        }
    }
    
    private func showPhotoGallery() {
       DispatchQueue.global(qos: .userInitiated).async {
            self.fetchFiles()
        }
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
            DispatchQueue.global(qos: .userInitiated).async {
                for url in self.selectedDocumentURLs {
                    self.getDocumentDetails(url: url)
                }
                DispatchQueue.main.async {
                    self.sortSectionKeys()
                    self.applySnapshot()
                    self.hideProgress()
                }
            }
            return
        }

        // Load the first batch on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadNextBatch()
        }
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
            dateFormatter.locale = Locale.current // Use the device's current locale
            dateFormatter.dateStyle = .medium     // You can choose between .short, .medium, .long, and .full
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
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                
                
                
                // Check if there are more assets to load
                if end < fetchResult.count {
                    // Trigger the next batch
                    self.loadNextBatch()
                } else {
                    self.sortSectionKeys()
                    self.applySnapshot()
                    self.hideProgress()
                }
            }
            
            currentBatchIndex += 1
        }
        else{
            DispatchQueue.main.async {
                self.hideProgress()
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
        dateFormatter.locale = Locale.current // Use the device's current locale
        dateFormatter.dateStyle = .medium     // You can choose between .short, .medium, .long, and .full
        dateFormatter.timeStyle = .none
        let dateCreatedString = dateFormatter.string(from: dateCreated)
        
        let documentName = url.lastPathComponent
        let documentIcon = UIImage(named: "documentsImage") ?? UIImage() // Placeholder icon for documents
        
        let documentInfo = MediaData(icon: documentIcon, size: "\(formattedSizeInMB)", name: documentName, createdAt: dateCreatedString, type: .document, asset: nil, url: url)
        
        self.filesDataSource[dateCreatedString, default: []].append(documentInfo)
        
        DispatchQueue.main.async {
           // self.collectionView.reloadData()
            self.configureDataSource()
        }
    }
    
    
    func handlePermissionDenied() {
        // Code to handle permission denial
        // Show an alert to the user explaining why the permission is needed
        DispatchQueue.main.async {
            self.hideProgress()
            self.showSettingsAlert()
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Photos Permission Denied",
            message: "Please allow access to your photos in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        })
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
                   // print("Error retrieving video asset: \(error.localizedDescription)")
                }
                return
            }
            
            guard let avAsset = avAsset else {
                DispatchQueue.main.async {
                   // print("No AVAsset retrieved")
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
//                let isSelected = self.selectedIndexPaths.contains(indexPath)
//                cell.setSelected(isSelected)
//                cell.optionsButton.params = (section: indexPath.section, item: indexPath.item)
//                cell.optionsButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self = self else { return nil }
            
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DateHeaderView.reuseIdentifier, for: indexPath) as! DateHeaderView
                let dateKey = self.sortedSectionKeys[indexPath.section]
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current // Use the device's current locale
                dateFormatter.dateStyle = .medium     // You can choose between .short, .medium, .long, and .full
                dateFormatter.timeStyle = .none       // Set this if you don't want to display the time

               
                
                if let sectionDate = dateFormatter.date(from: dateKey), Calendar.current.isDateInToday(sectionDate) {
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
                // Any additional completion logic
            }
        }
    }
    
    
    private func sortSectionKeys() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // Use the device's current locale
        dateFormatter.dateStyle = .medium     // You can choose between .short, .medium, .long, and .full
        dateFormatter.timeStyle = .none

        sortedSectionKeys = filesDataSource.keys.sorted { dateString1, dateString2 in
            guard let date1 = dateFormatter.date(from: dateString1),
                  let date2 = dateFormatter.date(from: dateString2) else {
                // If either date fails to parse, consider them equal to avoid misordering
                return false
            }
            return date1 > date2
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
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        
        filterView.addSubview(filterStackView)
        filterStackView.addArrangedSubview(filterButton)
        filterStackView.addArrangedSubview(filterNameLabel)
        filterStackView.edgeAnchors == filterView.edgeAnchors
        
        
        
        filterNameLabel.textAlignment = .left
        filterNameLabel.textColor = UIColor(named: "appPrimaryTextColor")
        filterNameLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 14)
        filterNameLabel.text = "By Date"
        
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
        
        listViewButton.setTitle("", for: .normal)
        listViewButton.setImage(UIImage(named: "listViewDeselectedIcon"), for: .normal)
        gridViewButton.setTitle("", for: .normal)
        gridViewButton.setImage(UIImage(named: "gridViewSelectedIcon"), for: .normal)
        
        listViewButton.addTarget(self, action: #selector(listViewButtonTapped(_:)), for: .touchUpInside)
        gridViewButton.addTarget(self, action: #selector(gridViewButtonTapped(_:)), for: .touchUpInside)
        
        filterView.addSubview(filterStackView)
        filterStackView.edgeAnchors == filterView.edgeAnchors
        
        filterContainerView.addSubview(filterContainerStackView)
        filterContainerStackView.addArrangedSubview(filterView)
        filterContainerStackView.addArrangedSubview(gridAndListView)
        
        filterContainerView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        filterContainerView.layer.cornerRadius = DesignMetrics.Padding.size8
        filterContainerView.heightAnchor == DesignMetrics.Dimensions.height51
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
            
            return
        }
        
        do {
            // Get all image files in the target directory
            let imageFiles = try fileManager.contentsOfDirectory(atPath: directory).filter { fileName in
                let fileExtension = (fileName as NSString).pathExtension.lowercased()
                return fileExtension == "jpg" || fileExtension == "png"
            }
            
            guard !imageFiles.isEmpty else {
               // print("No images found in the directory.")
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
            
           // print("\(count) images duplicated successfully.")
            
        } catch {
          //  print("Error duplicating images: \(error)")
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
           // print("No parameters found")
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
            if let mediaData = filesDataSource[dateKey]?[indexPath.item], let imageName = filesDataSource[dateKey]?[indexPath.item].name {
                
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
                          //  print("Failed to get the image from the asset")
                            return
                        }

                        // Initialize your ImagePreviewViewController with the fetched image
                        let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: optionsForImage, previewImage: image)
                    self.present(imagePreviewVC, animated: true)
                       // self.navigationController?.pushViewController(imagePreviewVC, animated: true)
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
    
    @objc private func getDetailOfSelectedItem(indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item

        let dateKey = sortedSectionKeys[section]
        switch currentMediaType {
        case .image, .favourite, .shared:
            let imageName = filesDataSource[dateKey]?[item].name ?? ""
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
            if let mediaData = filesDataSource[dateKey]?[item], let imageName = filesDataSource[dateKey]?[item].name {
                let imageManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .highQualityFormat
                options.resizeMode = .exact  // Ensures the image is not scaled down
                options.isNetworkAccessAllowed = true  // Allows downloading from iCloud if needed
                // Set targetSize to .zero to get the original size
                let targetSize = CGSize.zero 

                imageManager.requestImage(for: mediaData.asset!, targetSize: targetSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
                    guard let self = self, let image = image else {
                     //   print("Failed to get the image from the asset")
                        return
                    }
                    
                        let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: optionsForImage, previewImage: image)
                    imagePreviewVC.modalPresentationStyle = .fullScreen
                    self.imagePreviewTransitioningDelegate = ImagePreviewTransitioningDelegate()
                    imagePreviewVC.transitioningDelegate = self.imagePreviewTransitioningDelegate
                        present(imagePreviewVC, animated: true, completion: nil)
               

//                    let imagePreviewVC = ImagePreviewViewController(tittleOfSheet: imageName, bottomSheetOptions: optionsForImage, previewImage: image)
//                    self.present(imagePreviewVC, animated: true)
                }
            }
        case .video:
            if let mediaData = filesDataSource[dateKey]?[item] {
                if let asset = mediaData.asset {
                    playVideo(asset: asset)
                }
            }
        case .document:
            if let mediaData = filesDataSource[dateKey]?[item] {
                if let documentUrl = mediaData.url {
                    // Copy the file to Documents directory if needed
                    if let permanentUrl = copyFileToDocuments(from: documentUrl) {
                        previewDocument(at: permanentUrl)
                    } else {
                        print("Failed to copy file to a permanent location")
                    }
                }
            }
        }
    }
    
    private func copyFileToDocuments(from tempUrl: URL) -> URL? {
        let fileManager = FileManager.default

        // Get the file name and destination path in the Documents directory
        let fileName = tempUrl.lastPathComponent
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let permanentUrl = documentsDirectory.appendingPathComponent(fileName)

        // If the file already exists in the Documents directory, return its URL
        if fileManager.fileExists(atPath: permanentUrl.path) {
            return permanentUrl
        }

        // Copy the file from tmp to Documents
        do {
            try fileManager.copyItem(at: tempUrl, to: permanentUrl)
            print("File copied to: \(permanentUrl.path)")
            return permanentUrl
        } catch {
            print("Error copying file: \(error)")
            return nil
        }
    }

    
    private func previewDocument(at url: URL) {
        documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    private func handleFilterSelection(_ selectedOption: String) {
       // print("Selected filter option: \(selectedOption)")
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
            isSelectionModeActive = false
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
        isSelectionModeActive = false
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
        if let user = Auth.auth().currentUser {
            DispatchQueue.main.async {
                let uploadVC = UploadInfoViewController()
                self.navigationController?.pushViewController(uploadVC, animated: true)
            }
            
        }
        else {
            DispatchQueue.main.async {
                self.showLoginViewController()
            }
        }
        
        
    }
    
    private func showLoginViewController() {
        print("Creating LoginViewController")
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        // Check that the navigationController is initialized properly
        print("NavigationController created: \(navigationController)")
        
        if let window = UIApplication.shared.windows.first {
            // Check that the window is accessible
            print("Window found: \(window)")
            window.rootViewController = navigationController
        } else {
            print("No window found")
        }
    }
    
}

extension PhotosViewController: UICollectionViewDelegate , UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelectionModeActive {
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
        else {
            getDetailOfSelectedItem(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelectionModeActive {
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
        else {
            getDetailOfSelectedItem(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch currentMediaType {
        case .image,.favourite,.shared,.video:
            let section = sortedSectionKeys[indexPath.section]
            if let items = filesDataSource[section], indexPath.item < items.count {
                let mediaData = items[indexPath.item]
                loadImage(for: mediaData.asset!, into: cell, ImageName: mediaData.name, ImageSize: mediaData.size, cellindexPath: indexPath)
            }
            
        case .document:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch currentMediaType {
        case .image,.favourite,.shared,.video:
            // Handle cells that are no longer visible
            let section = sortedSectionKeys[indexPath.section]
            if let items = filesDataSource[section], indexPath.item < items.count {
                let mediaData = items[indexPath.item]
                cancelImageLoad(for: mediaData.asset!)
            }
            
        case .document:
            break
            
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
