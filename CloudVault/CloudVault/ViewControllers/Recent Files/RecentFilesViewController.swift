//
//  RecentFilesViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 29/07/2024.
//

import UIKit
import Anchorage
import Photos

class RecentFilesViewController: BaseViewController {
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
    private var currentViewType: ViewType = .grid
    private var imagesDataSource: [String: [ImagesData]] = [:]
    private var sortedSectionKeys: [String] = []
    private var selectedIndexPaths: Set<IndexPath> = []
    private var dataSource: UICollectionViewDiffableDataSource<String, ImagesData>!
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier)
        collectionView.register(DateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeaderView.reuseIdentifier)
        collectionView.collectionViewLayout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "Recent Files", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
        configureDataSource()
        setupData() // Moved setupData here to ensure dataSource is initialized before applying snapshot
        collectionView.delegate = self
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        filterView()
        setupCollectionView()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, ImagesData>(collectionView: collectionView) { collectionView, indexPath, imageData -> UICollectionViewCell? in
            switch self.currentViewType {
            case .grid:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
                cell.imagesView.image = imageData.icon
                cell.sizeLabel.text = imageData.size
                cell.imageNameLabel.text = imageData.imageName
                let isSelected = self.selectedIndexPaths.contains(indexPath)
                cell.setSelected(isSelected)
                return cell
                
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell1.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell1
                cell.imagesView.image = imageData.icon
                cell.sizeLabel.text = imageData.size
                cell.imageNameLabel.text = imageData.imageName
                let isSelected = self.selectedIndexPaths.contains(indexPath)
                cell.setSelected(isSelected)
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
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        guard !sortedSectionKeys.isEmpty else { return }
        var snapshot = NSDiffableDataSourceSnapshot<String, ImagesData>()
        for section in sortedSectionKeys {
            snapshot.appendSections([section])
            if let items = imagesDataSource[section] {
                snapshot.appendItems(items)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Load your images here
        // This is just example data
        if let image1 = UIImage(named: "recentImage1") {
            let date1 = "2024-08-01"
            let data1 = ImagesData(icon: image1, size: "1MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage2") {
            let date2 = "2024-08-01"
            let data2 = ImagesData(icon: image2, size: "2MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        if let image1 = UIImage(named: "recentImage9") {
            let date1 = "2024-08-01"
            let data1 = ImagesData(icon: image1, size: "3MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage8") {
            let date2 = "2024-08-01"
            let data2 = ImagesData(icon: image2, size: "2.5MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        if let image1 = UIImage(named: "recentImage7") {
            let date1 = "2024-07-30"
            let data1 = ImagesData(icon: image1, size: "6MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage6") {
            let date2 = "2024-07-30"
            let data2 = ImagesData(icon: image2, size: "3.5MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        // Add more images as needed
        
        if let image1 = UIImage(named: "recentImage1") {
            let date1 = "2024-07-24"
            let data1 = ImagesData(icon: image1, size: "1.5MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage3") {
            let date2 = "2024-07-24"
            let data2 = ImagesData(icon: image2, size: "2.4MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        if let image1 = UIImage(named: "recentImage4") {
            let date1 = "2024-07-24"
            let data1 = ImagesData(icon: image1, size: "4MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage5") {
            let date2 = "2024-07-24"
            let data2 = ImagesData(icon: image2, size: "5MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        
        // Add more images and dates as needed
        if let image1 = UIImage(named: "recentImage6") {
            let date1 = "2024-07-20"
            let data1 = ImagesData(icon: image1, size: "6MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage7") {
            let date2 = "2024-07-20"
            let data2 = ImagesData(icon: image2, size: "5MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        if let image1 = UIImage(named: "recentImage8") {
            let date1 = "2024-07-20"
            let data1 = ImagesData(icon: image1, size: "3.4MB", imageName: "Image 1", createdAt: date1)
            imagesDataSource[date1, default: []].append(data1)
        }
        if let image2 = UIImage(named: "recentImage9") {
            let date2 = "2024-07-20"
            let data2 = ImagesData(icon: image2, size: "2.7MB", imageName: "Image 2", createdAt: date2)
            imagesDataSource[date2, default: []].append(data2)
        }
        
        sortSectionKeys()
        applySnapshot()
    }
    
    private func sortSectionKeys() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        sortedSectionKeys = imagesDataSource.keys.sorted {
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
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let actionSheetVC = CustomActionSheetViewController()
        actionSheetVC.modalPresentationStyle = .overCurrentContext
        actionSheetVC.modalTransitionStyle = .crossDissolve
        
        actionSheetVC.selectionHandler = { [weak self] selectedOption in
            self?.handleFilterSelection(selectedOption)
        }
        
        present(actionSheetVC, animated: true, completion: nil)
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
            let newTitle = "\(selectedIndexPaths.count) Files Selected"
            changeTitle(titleOfNavigation: newTitle)
        } else {
            hideFocusbandOptionFromNavBar()
            changeTitle(titleOfNavigation: "Recent Files")
        }
        
    }
    
    func getSelectedItems() -> [ImagesData] {
        var selectedItems: [ImagesData] = []
        for indexPath in selectedIndexPaths {
            let dateKey = sortedSectionKeys[indexPath.section]
            if let item = imagesDataSource[dateKey]?[indexPath.item] {
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
}


extension RecentFilesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.currentViewType {
        case .grid:
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

struct ImagesData: Hashable {
    let icon: UIImage
    let size: String
    let imageName: String
    let createdAt: String
}

struct MediaData: Hashable {
    let icon: UIImage
    let size: String
    let name: String
    let createdAt: String
    let type: MediaType
    let asset: PHAsset?
    let url: URL?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(asset?.localIdentifier)
    }
    
    static func ==(lhs: MediaData, rhs: MediaData) -> Bool {
        return lhs.asset?.localIdentifier == rhs.asset?.localIdentifier
    }
}

enum MediaType {
    case image
    case video
    case favourite
    case shared
    case document
}
