//
//  CustomActionSheetViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 30/07/2024.
//

import UIKit
import Anchorage

class CustomActionSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let actionSheetView = CustomRoundedView()
    let backgroundView = UIView()
    let tableView = UITableView()
    let titleLabel = UILabel()
    let filterOptions = ["By Date", "By Size", "By Name"] // Example options
    
    var selectionHandler: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        setupBackgroundView()
        setupActionSheetView()
        setupTitleLabel()
        setupTableView()
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(backgroundView)
        backgroundView.edgeAnchors == view.edgeAnchors
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissActionSheet))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupActionSheetView() {
        actionSheetView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.9)
        actionSheetView.configureRoundedCorners(corners: [.topRight, .topLeft], radius: DesignMetrics.Padding.size16)
        view.addSubview(actionSheetView)
        
        actionSheetView.horizontalAnchors == view.horizontalAnchors
        actionSheetView.bottomAnchor == view.bottomAnchor
        actionSheetView.heightAnchor == 300
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Filterd By"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor =  #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        titleLabel.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        actionSheetView.addSubview(titleLabel)
        
        titleLabel.horizontalAnchors == actionSheetView.horizontalAnchors
        titleLabel.topAnchor == actionSheetView.topAnchor
        titleLabel.heightAnchor == 44
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterOptionCell")
        tableView.backgroundColor = .clear
        actionSheetView.addSubview(tableView)
        
        tableView.topAnchor == titleLabel.bottomAnchor
        tableView.horizontalAnchors == actionSheetView.horizontalAnchors
        tableView.bottomAnchor == actionSheetView.bottomAnchor
    }
    
    @objc private func dismissActionSheet() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionCell", for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.3568627451, alpha: 1)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        cell.textLabel?.text = filterOptions[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = filterOptions[indexPath.row]
        print("Selected: \(selectedOption)")
        selectionHandler?(selectedOption)
        dismissActionSheet()
    }
}

