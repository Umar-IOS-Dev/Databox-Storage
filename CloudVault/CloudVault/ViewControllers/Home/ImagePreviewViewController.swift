//
//  ImagePreviewViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 24/07/2024.
//

import UIKit
import Anchorage

class ImagePreviewViewController: BaseViewController {
    
    private let imageName: String
    private let previewImage: UIImage
    private var bottomSheetOptions: [BottomSheetOption]
    private var bottomSheetHeightConstraint: NSLayoutConstraint!
    private let tableView = UITableView()
    private let bottomSheetView = UIView()
    private let notchView = UIView()
    
    init(tittleOfSheet: String, bottomSheetOptions: [BottomSheetOption], previewImage: UIImage) {
        self.imageName = tittleOfSheet
        self.bottomSheetOptions = bottomSheetOptions
        self.previewImage = previewImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
       configureUI(title: "", showBackButton: true, addHorizontalPadding: false)
    //    configureUI(title: imageName, showBackButton: false, hideBackground: true, showMainNavigation: false, addHorizontalPadding: false)
        hideCheckBoxInNavigation()
    }
    
    
    override func configureUI(title: String, showNavBar: Bool = true, showBackButton: Bool = true, hideBackground: Bool = false, showMainNavigation: Bool = false, addHorizontalPadding: Bool = true, showAsSubViewController: Bool = false) {
        super.configureUI(title: title, showNavBar: showNavBar, showBackButton: showBackButton, hideBackground: hideBackground, showMainNavigation: showMainNavigation, addHorizontalPadding: addHorizontalPadding, showAsSubViewController: showAsSubViewController)
        configureImageView()
        setupBottomSheet()
    }
    
    override func backButtonAction() {
        dismiss(animated: true)
    }
    
    private func configureImageView() {
        let currentImageView = UIImageView()
        currentImageView.contentMode = .scaleAspectFit
        currentImageView.image = previewImage//UIImage(named: imageName) //recentImage2Copy
        currentImageView.backgroundColor = .clear
        currentImageView.heightAnchor ==  UIScreen.main.bounds.height /*- 60*/
        currentImageView.backgroundColor = .black
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.heightAnchor == view.bounds.height
        scrollView.addSubview(currentImageView)
        
        currentImageView.centerXAnchor == scrollView.centerXAnchor
        currentImageView.centerYAnchor == scrollView.centerYAnchor - 100
        currentImageView.widthAnchor == scrollView.widthAnchor
        currentImageView.heightAnchor == scrollView.heightAnchor
        appendViewToMainVStack(view: scrollView)
    }
    
    private func setupBottomSheet() {
        bottomSheetView.backgroundColor = .white
        bottomSheetView.layer.cornerRadius = 16
        bottomSheetView.clipsToBounds = true
        view.addSubview(bottomSheetView)
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomSheetHeightConstraint = bottomSheetView.heightAnchor.constraint(equalToConstant: 550)
        bottomSheetHeightConstraint.isActive = true
        bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        setupNotchView()
        
        let imageNameLabel = UILabel()
        imageNameLabel.textAlignment = .center
        imageNameLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        imageNameLabel.font = FontManagerDatabox.shared.cloudVaultSemiBoldText(ofSize: 24)
        imageNameLabel.text = imageName
        
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9333333333, blue: 0.9647058824, alpha: 1)
        
        bottomSheetView.addSubview(imageNameLabel)
        bottomSheetView.addSubview(separatorView)
        imageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageNameLabel.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            imageNameLabel.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            imageNameLabel.topAnchor.constraint(equalTo: notchView.bottomAnchor, constant: 16)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor, constant: 16),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BottomSheetOptionCell.self, forCellReuseIdentifier: "BottomSheetOptionCell")
        tableView.separatorStyle = .none
        
        bottomSheetView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheetView.addGestureRecognizer(panGesture)
        bottomSheetView.isHidden = true // Hide the bottom sheet initially
    }
    
    private func setupNotchView() {
        notchView.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
        notchView.layer.cornerRadius = 2.5
        bottomSheetView.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notchView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            notchView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 8),
            notchView.widthAnchor.constraint(equalToConstant: 40),
            notchView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    override func imageButtonAction() {
        showBottomSheet()
    }
    
    
    @objc private func showBottomSheet() {
        bottomSheetView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetView.frame.origin.y = self.view.frame.height - self.bottomSheetHeightConstraint.constant
        }
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let newHeight = bottomSheetHeightConstraint.constant - translation.y
        
        switch recognizer.state {
        case .changed:
            if newHeight > 100 && newHeight < 550 {
                bottomSheetHeightConstraint.constant = newHeight
                recognizer.setTranslation(.zero, in: view)
            }
        case .ended:
            if newHeight < 200 {
                UIView.animate(withDuration: 0.3) {
                    self.bottomSheetHeightConstraint.constant = 550
                    self.bottomSheetView.isHidden = true
                }
            } else {
                // bottomSheetHeightConstraint.constant = min(max(newHeight, 600), 600)
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    
    
    
}

extension ImagePreviewViewController: UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetOptionCell", for: indexPath) as! BottomSheetOptionCell
        let option = bottomSheetOptions[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = bottomSheetOptions[indexPath.row]
        print("Selected option: \(selectedOption.title)")
        // Handle the selection
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetHeightConstraint.constant = 550
            self.bottomSheetView.isHidden = true
        }
    }
}
