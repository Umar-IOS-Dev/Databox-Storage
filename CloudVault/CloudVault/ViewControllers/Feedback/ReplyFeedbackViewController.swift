//
//  ReplyFeedbackViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit

class ReplyFeedbackViewController: BaseViewController {
    
    private var feedbackReplyArrayDataSource: [FeedBackReplyData] = []
    private var dataSource: UICollectionViewDiffableDataSource<String, FeedBackReplyData>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FeedBackReplyCollectionViewCell.self, forCellWithReuseIdentifier: FeedBackReplyCollectionViewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(named: "appBackgroundColor")
        configureUI(title: "", showBackButton: false, hideBackground: true, showMainNavigation: false, showAsSubViewController: true)
        hideFocusbandOptionFromNavBar()
        configureDataSource()
        setupData()
    }
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        setupCollectionView()
    }
    
    
    private func createLayout(zoomScale: CGFloat = 1.0) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout { (_, environment) -> NSCollectionLayoutSection? in
            return NSCollectionLayoutSection(group: NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item]))
        }
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, FeedBackReplyData>(collectionView: collectionView) { collectionView, indexPath, feedbackReplyData -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedBackReplyCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedBackReplyCollectionViewCell
            cell.configure(with: feedbackReplyData.feedbackType, feedbackDate: feedbackReplyData.feedbackDate, showButton: feedbackReplyData.isShowFeedBackButton)
            cell.checkReplyButton.tag = indexPath.item
            cell.checkReplyButton.params = (section: indexPath.section, item: indexPath.item)
            cell.checkReplyButton.addTarget(self, action: #selector(self.verticalDotTapped(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc private func verticalDotTapped(_ sender: UIButton) {
        guard let params = sender.params else {
            // print("No parameters found")
            return
        }
        
        let section = params.section
        let item = params.item
        
        let indexPath = IndexPath(item: item, section: section) // Adjust section as needed
        let dateKey = feedbackReplyArrayDataSource[indexPath.item]
        
        DispatchQueue.main.async {
            let feedBackReplyDetailVC = FeedBackReplyDetailViewController()
            self.navigationController?.pushViewController(feedBackReplyDetailVC, animated: true)
        }
        
    }
    private func setupData() {
        
        
        // Load your data here
        // This is just example data
        
        let data0 = FeedBackReplyData(feedbackType: "Storage Issue", feedbackDate: "10/19/2024", isShowFeedBackButton: true)
        feedbackReplyArrayDataSource.append(data0)
        
        let data1 = FeedBackReplyData(feedbackType: "Irritating Issue", feedbackDate: "11/19/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data1)
        
        let data2 = FeedBackReplyData(feedbackType: "Quick Backup", feedbackDate: "12/19/2024", isShowFeedBackButton: true)
        feedbackReplyArrayDataSource.append(data2)
        
        let data3 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "12/23/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data3)
        
        let data4 = FeedBackReplyData(feedbackType: "Irritating ads", feedbackDate: "12/24/2023", isShowFeedBackButton: true)
        feedbackReplyArrayDataSource.append(data4)
        
        let data5 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "09/23/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data5)
        let data6 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "08/22/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data6)
        let data7 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "10/23/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data7)
        let data8 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "07/23/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data8)
        let data9 = FeedBackReplyData(feedbackType: "Others Issue", feedbackDate: "08/23/2024", isShowFeedBackButton: false)
        feedbackReplyArrayDataSource.append(data9)
        
        applySnapshot()
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String, FeedBackReplyData>()
        
        // Assuming you want all data in a single section, use a generic section identifier like "Main"
        snapshot.appendSections(["Main"])
        
        // Add your data to the snapshot
        snapshot.appendItems(feedbackReplyArrayDataSource, toSection: "Main")
        
        // Apply the snapshot to the data source
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupCollectionView() {
        appendViewToMainVStack(view: collectionView, topPadding: 24)
    }
}
