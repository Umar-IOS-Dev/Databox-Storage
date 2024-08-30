//
//  YourFeedbackViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit

class YourFeedbackViewController: BaseViewController {
    
    private var feedbackArrayDataSource: [FeedBackData] = []
    private var dataSource: UICollectionViewDiffableDataSource<String, FeedBackData>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(FeedBackCollectionViewCell.self, forCellWithReuseIdentifier: FeedBackCollectionViewCell.reuseIdentifier)
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
        dataSource = UICollectionViewDiffableDataSource<String, FeedBackData>(collectionView: collectionView) { collectionView, indexPath, feedbackData -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedBackCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedBackCollectionViewCell
            cell.configure(with: feedbackData.feedbackType , email: feedbackData.feedbackEmail, feedbackDate: feedbackData.feedbackDate)
            return cell
        }
    }
    
    private func setupData() {
        
        
        // Load your data here
        // This is just example data
        
        let data0 = FeedBackData(feedbackType: "Strorage Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/20/2024")
    feedbackArrayDataSource.append(data0)
        
            let data1 = FeedBackData(feedbackType: "Irritating Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/30/2024")
        feedbackArrayDataSource.append(data1)
        
        let data2 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "11/14/2024")
    feedbackArrayDataSource.append(data2)
        
        let data3 = FeedBackData(feedbackType: "Quick Backup", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/22/2024")
    feedbackArrayDataSource.append(data3)
        
        let data4 = FeedBackData(feedbackType: "Irritating ads", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/13/2024")
    feedbackArrayDataSource.append(data4)
        
        let data5 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/23/2024")
    feedbackArrayDataSource.append(data5)
        
        let data6 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "12/20/2024")
    feedbackArrayDataSource.append(data6)
        
        let data7 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "06/12/2024")
    feedbackArrayDataSource.append(data7)
        
        let data8 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "10/15/2024")
    feedbackArrayDataSource.append(data8)
        
        let data9 = FeedBackData(feedbackType: "Others Issue", feedbackEmail: "Databoxhelpcenter@gmail.com", feedbackDate: "07/16/2024")
    feedbackArrayDataSource.append(data9)
    
        applySnapshot()
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String, FeedBackData>()

        // Assuming you want all data in a single section, use a generic section identifier like "Main"
        snapshot.appendSections(["Main"])
        
        // Add your data to the snapshot
        snapshot.appendItems(feedbackArrayDataSource, toSection: "Main")
        
        // Apply the snapshot to the data source
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupCollectionView() {
        appendViewToMainVStack(view: collectionView, topPadding: 24)
    }
    
}

