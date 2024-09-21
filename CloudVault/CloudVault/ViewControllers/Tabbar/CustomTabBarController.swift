//
//  CustomTabBarController.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/07/2024.
//

import UIKit
import Anchorage

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var customTabBar: CustomTabBar!
    private var centerButton: UIButton!
    private var tabButtons: [UIButton] = []
    private var bottomSheetView: UIView?
    private var bottomSheetHeightConstraint: NSLayoutConstraint?
    private var dimmingView: UIView? // Added dimming view
    
    private lazy var bottomSheetOptions: [BottomSheetOption] = {
        guard let uploadIcon = UIImage(named: "uploadIcon"),
              let folderIcon = UIImage(named: "folderIcon"),let photosIcon = UIImage(named: "photosIcon"),let videosIcon = UIImage(named: "videosIcon"),let documentsIcon = UIImage(named: "documentsIcon"),let audioIcon = UIImage(named: "audioIcon"),let contactsIcon = UIImage(named: "contactsIcon") else {
            return []
        }
        return [
            BottomSheetOption(icon: uploadIcon, title: "Uploads"),
            BottomSheetOption(icon: folderIcon, title: "Create Folder"),
            BottomSheetOption(icon: uploadIcon, title: "Photos"),
            BottomSheetOption(icon: folderIcon, title: "Videos"),
            BottomSheetOption(icon: uploadIcon, title: "Documents"),
            BottomSheetOption(icon: folderIcon, title: "Audio"),
            BottomSheetOption(icon: uploadIcon, title: "Contacts")
        ]
    }()
    private let selectedTintColor: UIColor = UIColor(named: "appPrimaryTextColor") ?? .gray
    private let deselectedTintColor: UIColor = UIColor(named: "appDeselectedTabbarColor") ?? .gray
    private let notchView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self // Set the delegate

        // Create the view controllers for each tab
        let homeVC = HomeViewController()
        homeVC.tabBarItem.tag = 0

        let favoriteVC = PhotosViewController.sharedFavorite
//        self.navigationController?.pushViewController(favoriteVC, animated: true)
        favoriteVC.tabBarItem.tag = 1

        let centerPlaceholderVC = UIViewController()
        centerPlaceholderVC.tabBarItem.isEnabled = false // Prevent selection
        centerPlaceholderVC.tabBarItem.tag = 2

        let sharedVC = PhotosViewController.sharedShared
//        self.navigationController?.pushViewController(sharedVC, animated: true)
        sharedVC.tabBarItem.tag = 3

        let settingsVC = SettingsViewController()
//        self.navigationController?.pushViewController(settingsVC, animated: true)
        settingsVC.tabBarItem.tag = 4

        // Set view controllers for the tab bar controller
        viewControllers = [homeVC, favoriteVC, centerPlaceholderVC, sharedVC, settingsVC]

        // Use the custom tab bar
        customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")

        // Add custom tab bar buttons
        setupCustomTabBarButtons()
    }

    private func setupCustomTabBarButtons() {
        let buttons = ["home", "favorite", "personal", "settings"]
        let buttonTags = [0, 1, 3, 4]
        
        // Add a custom center button
        centerButton = UIButton()
        centerButton.setImage(UIImage(named: "centerTabbar"), for: .normal)
        centerButton.layer.cornerRadius = 35
        centerButton.layer.shadowColor = UIColor.link.cgColor
        centerButton.layer.shadowOpacity = 0.3
        centerButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        centerButton.layer.shadowRadius = 5
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addSubview(centerButton)

        centerButton.centerXAnchor == customTabBar.centerXAnchor
        centerButton.centerYAnchor == customTabBar.centerYAnchor - 8
        centerButton.widthAnchor == 80
        centerButton.heightAnchor == 80
        
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)

        for (index, imageName) in buttons.enumerated() {
            let button = UIButton()
            button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = deselectedTintColor
            button.tag = buttonTags[index]
            button.addTarget(self, action: #selector(tabBarButtonTapped(_:)), for: .touchUpInside)
            customTabBar.backgroundColor =  UIColor(named: "appBackgroundViewColor") //for curvy tabbar comment this
            customTabBar.addSubview(button)
            tabButtons.append(button)

            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerYAnchor == centerButton.centerYAnchor
            button.widthAnchor == 60
            button.heightAnchor == 60

            switch button.tag {
            case 0:
                button.leadingAnchor == customTabBar.leadingAnchor + 20
            case 1:
                button.leadingAnchor == customTabBar.leadingAnchor + 90
            case 3:
                button.trailingAnchor == customTabBar.trailingAnchor - 90
            case 4:
                button.trailingAnchor == customTabBar.trailingAnchor - 20
            default:
                break
            }
        }

        

        // Set the initial selected button
        tabBarButtonTapped(tabButtons[0])
    }

    @objc private func tabBarButtonTapped(_ sender: UIButton) {
        for button in tabButtons {
            button.tintColor = deselectedTintColor
        }
        sender.tintColor = selectedTintColor
        // Adjust the selectedIndex based on the presence of the dummyVC
        print("selected index = \(sender.tag)")
        selectedIndex = sender.tag < 2 ? sender.tag : sender.tag + 1
        
    }

    @objc private func centerButtonTapped() {
        if(selectedIndex != 0) {
            // Set the initial selected button
            tabBarButtonTapped(tabButtons[0])
        }
        showBottomSheet()
    }
    
    
    private func showBottomSheet() {
        guard let selectedVC = selectedViewController else { return }

        // Create dimming view if needed
        if dimmingView == nil {
            dimmingView = UIView(frame: selectedVC.view.bounds)
            dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView?.alpha = 0.0
            selectedVC.view.addSubview(dimmingView!)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
            dimmingView?.addGestureRecognizer(tapGesture)
        }

        // Create bottom sheet view if it doesn't exist
        if bottomSheetView == nil {
            bottomSheetView = UIView()
            bottomSheetView?.backgroundColor = UIColor(named: "appBackgroundViewColor")
            bottomSheetView?.layer.cornerRadius = 16
            bottomSheetView?.clipsToBounds = true
            selectedVC.view.addSubview(bottomSheetView!)
            bottomSheetView?.translatesAutoresizingMaskIntoConstraints = false
            
            bottomSheetHeightConstraint = bottomSheetView?.heightAnchor.constraint(equalToConstant: 430)
            bottomSheetHeightConstraint?.isActive = true

            // Set bottom constraint initially off-screen
            bottomSheetHeightConstraint = bottomSheetView!.bottomAnchor.constraint(equalTo: selectedVC.view.bottomAnchor, constant: 430)
            bottomSheetHeightConstraint?.isActive = true

            NSLayoutConstraint.activate([
                bottomSheetView!.leadingAnchor.constraint(equalTo: selectedVC.view.leadingAnchor),
                bottomSheetView!.trailingAnchor.constraint(equalTo: selectedVC.view.trailingAnchor),
                bottomSheetHeightConstraint!
            ])
            
            // Add content to the bottom sheet
            setupBottomSheetContent()
            setupNotchView()
        } else {
            // If the bottom sheet view already exists, make sure it's not hidden
            bottomSheetView?.isHidden = false
        }

        // Ensure layout is updated
        selectedVC.view.layoutIfNeeded()
        
        // Animate the appearance of the bottom sheet from the bottom
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView?.alpha = 1.0
            self.bottomSheetHeightConstraint?.constant = 0 // Bring it back on-screen
            selectedVC.view.layoutIfNeeded()
        })
    }



    @objc private func dismissBottomSheet() {
        guard let selectedVC = selectedViewController else { return }
        
        // Animate the hiding of the bottom sheet
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView?.alpha = 0.0
            self.bottomSheetHeightConstraint?.constant = 430 // Move it off-screen
            selectedVC.view.layoutIfNeeded()
        }) { _ in
            self.bottomSheetView?.isHidden = true
        }
    }




    private func setupBottomSheetContent() {
        guard let bottomSheetView = bottomSheetView else { return }
        
        let imageNameLabel = UILabel()
        imageNameLabel.textAlignment = .center
        imageNameLabel.textColor =  UIColor(named: "appPrimaryTextColor")
        imageNameLabel.font = FontManagerDatabox.shared.cloudVaultBoldText(ofSize: 16)
        imageNameLabel.text = "Add to Databox"
        
        let separatorView = UIView()
        separatorView.backgroundColor =  UIColor(named: "appDeselectedTabbarColor")
        
        bottomSheetView.addSubview(imageNameLabel)
        bottomSheetView.addSubview(separatorView)
        
        imageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageNameLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            imageNameLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            imageNameLabel.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 16),
            
            separatorView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor, constant: 16),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BottomSheetOptionCell.self, forCellReuseIdentifier: "BottomSheetOptionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "appBackgroundViewColor")
        bottomSheetView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
    }
    
    private func setupNotchView() {
        notchView.backgroundColor =  UIColor(named: "appPrimaryTextColor")
        notchView.layer.cornerRadius = 2.5
        bottomSheetView?.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notchView.centerXAnchor.constraint(equalTo: bottomSheetView!.centerXAnchor),
            notchView.topAnchor.constraint(equalTo: bottomSheetView!.topAnchor, constant: 8),
            notchView.widthAnchor.constraint(equalToConstant: 40),
            notchView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    // Override the didSelect method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = viewControllers?.firstIndex(of: viewController) {
            for button in tabButtons {
                button.tintColor = deselectedTintColor
            }
            // Adjust the button tint color update based on the presence of the dummyVC
            let buttonIndex = index < 2 ? index : index - 1
            if(index != 2) {
                tabButtons[buttonIndex].tintColor = selectedTintColor
            }
        }
    }
    
    private func gotoImageViewController(currentMediaType: MediaType) {
        let photosVC = PhotosViewController(currentMediaType: currentMediaType)
        self.navigationController?.pushViewController(photosVC, animated: true)
    }
    
    private func gotoContactsViewController() {
        let contactsVC = ContactsViewController()
        self.navigationController?.pushViewController(contactsVC, animated: true)
    }
    
    private func gotoDocumnetViewController() {
        let documentVC = DocumentsViewController()
        self.navigationController?.pushViewController(documentVC, animated: true)
    }
    
   
}

extension CustomTabBarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetOptions.count // Number of options
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetOptionCell", for: indexPath) as! BottomSheetOptionCell
        cell.titleLabel.text = bottomSheetOptions[indexPath.row].title
        cell.titleLabel.textColor =  UIColor(named: "appPrimaryTextColor")
        cell.iconImageView.image = bottomSheetOptions[indexPath.row].icon.withRenderingMode(.alwaysTemplate)
        cell.iconImageView.tintColor = UIColor(named: "appPrimaryTextColor")
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = bottomSheetOptions[indexPath.row]
        print("Selected option: \(selectedOption.title)")
        // Handle the selection
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetHeightConstraint?.constant = 430
            self.bottomSheetView?.isHidden = true
            self.dismissBottomSheet()
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                self.gotoImageViewController(currentMediaType: .image)
            case 3:
                self.gotoImageViewController(currentMediaType: .video)
            case 4:
                self.gotoImageViewController(currentMediaType: .document) //self.gotoDocumnetViewController()
            case 5:
                self.gotoImageViewController(currentMediaType: .document) // for time being
            case 6:
              //  self.gotoImageViewController(currentMediaType: .contact)
                self.gotoContactsViewController()
            default:
                break
            }
            
        }
    }
}






