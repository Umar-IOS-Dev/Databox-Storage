//
//  ContactsViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 12/08/2024.
//

import UIKit
import Contacts
import Anchorage


// Define a dummy section enum
enum Section: Hashable {
    case main
}

class ContactsViewController: BaseViewController {
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        let titleColorForNormalState: UIColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        button.isEnabled = true//false
        button.setTitle("Upload Contacts", for: .normal)
        button.setTitleColor(titleColorForNormalState, for: .normal)
        button.layer.cornerRadius = DesignMetrics.Padding.size8
        button.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)
        return button
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
    
    private var filesDataSource: [CNContact] = []
    private let spacerString:String = "    "
    private var selectedIndexPaths: Set<IndexPath> = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, CNContact>!
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 80, height: 80) // Set item size to 80x80

        // Set the minimum spacing between cells in the same row
        layout.minimumInteritemSpacing = 10 // Adjust this value as needed
        
        // Set the minimum spacing between rows
        layout.minimumLineSpacing = 20 // Adjust this value as needed
        
        // Set the padding around the content within a section
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

        // Register a cell class
        collectionView.register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: ContactsCollectionViewCell.reuseIdentifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.layer.cornerRadius = 8
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI(title: "Contacts", showBackButton: true, hideBackground: true, showMainNavigation: false)
        hideFocusbandOptionFromNavBar()
        showHideFooterView(isShowFooterView: false)
        self.fetchContacts()
        setupDataSource()
        // setupData() // Moved setupData here to ensure dataSource is initialized before applying snapshot
        
        collectionView.delegate = self
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding)
        setupCollectionView()
        configureFooterView()
    }
    
    
    func setupCollectionView() {
        appendViewToMainVStack(view: collectionView, topPadding: 24)
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
        
        
        uploadButton.setTitle("Upload Contacts", for: .normal)
        
        uploadButton.addTarget(self, action: #selector(self.uploadButtonTapped(_:)), for: .touchUpInside)
        
        footerStackView.addArrangedSubview(uploadSizeViewForLabel)
        footerStackView.addArrangedSubview(uploadButtonView)
        
        footerView.addSubview(footerStackView)
        footerStackView.edgeAnchors == footerView.edgeAnchors
        
        addFooterView(footerView: footerView, height: 88)
    }
    
    func getRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    // Setup your data source
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CNContact>(collectionView: collectionView) { collectionView, indexPath, contactData in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactsCollectionViewCell.reuseIdentifier, for: indexPath) as! ContactsCollectionViewCell
            // Configure your cell with mediaData
            
            cell.configure(with: contactData, contactViewColor: self.getRandomColor())
            let isSelected = self.selectedIndexPaths.contains(indexPath)
            cell.setSelected(isSelected)
            cell.button.tag = indexPath.item
            cell.button.params = (section: indexPath.section, item: indexPath.item)
            cell.button.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc private func verticalDotTapped(_ sender: UIButton) {
        guard let params = sender.params else {
            print("No parameters found")
            return
        }
        
        let section = params.section
        let item = params.item
        
        let indexPath = IndexPath(item: item, section: section) // Adjust section as needed
        
    }
    
    // Apply the snapshot to update the collection view
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CNContact>()
        snapshot.appendSections([.main]) // You need to append at least one section
        snapshot.appendItems(filesDataSource)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func uploadButtonTapped(_ sender: UIButton) {
        self.gotoUploadInfoViewController()
    }
    
    private func gotoUploadInfoViewController() {
        let uploadVC = UploadInfoViewController()
        self.navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    func fetchContacts() {
        DispatchQueue.global(qos: .userInitiated).async {
            let store = CNContactStore()
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            do {
                var contactsArray = [CNContact]()
                try store.enumerateContacts(with: request) { (contact, stop) in
                    contactsArray.append(contact)
                }
                
                // Sort the contacts array alphabetically by contact's given name
                contactsArray.sort { $0.givenName < $1.givenName }
                self.filesDataSource = contactsArray
                
                // Once we have all contacts, update the main thread
                DispatchQueue.main.async {
                    // Reload your UI or table view here
                    self.collectionView.reloadData()
                    self.applySnapshot()
                }
            } catch {
                DispatchQueue.main.async {
                    // Handle error on the main thread
                    print("Failed to fetch contact, error: \(error)")
                }
            }
        }
        
        
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
            changeTitle(titleOfNavigation: "Contacts")
            
            
        }
        
    }
    
    func getSelectedItems() -> [CNContact] {
        var selectedItems: [CNContact] = []
        selectedItemSize = 0.0
        for indexPath in selectedIndexPaths {
            let item = filesDataSource[indexPath.item]
            selectedItems.append(item)
            
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

extension ContactsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
        let isSelected = selectedIndexPaths.contains(indexPath)
        if(isSelected) {
            selectedIndexPaths.remove(indexPath)
            cell.setSelected(false)
        }
        else {
            selectedIndexPaths.insert(indexPath)
            cell.setSelected(true)
        }
        updateSelectionState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
        let isSelected = selectedIndexPaths.contains(indexPath)
        if(isSelected) {
            selectedIndexPaths.remove(indexPath)
            cell.setSelected(false)
        }
        else {
            selectedIndexPaths.insert(indexPath)
            cell.setSelected(true)
        }
        updateSelectionState()
    }
}
