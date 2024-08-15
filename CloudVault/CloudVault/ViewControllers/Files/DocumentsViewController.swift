//
//  DocumentsViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 05/08/2024.
//

import UIKit
import UniformTypeIdentifiers

class DocumentsViewController: UIViewController, UIDocumentPickerDelegate, UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate {
    
    var selectedDocumentURLs: [URL] = []
    let tableView = UITableView()
    var documentInteractionController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentDocumentPicker()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: "DocumentCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func presentDocumentPicker() {
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

    // UIDocumentPickerDelegate methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedDocumentURLs.append(contentsOf: urls)
        tableView.reloadData()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDocumentURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as? DocumentTableViewCell else {
            return UITableViewCell()
        }

        let url = selectedDocumentURLs[indexPath.row]
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        
        // Document Name
//        cell.nameLabel.text = url.lastPathComponent
//        
//        // Document Size
//        if let fileSize = fileAttributes?[.size] as? NSNumber {
//            cell.sizeLabel.text = "Size: \(fileSize.intValue) bytes"
//        } else {
//            cell.sizeLabel.text = "Size: Unknown"
//        }
//
//        // Document Creation Date
//        if let creationDate = fileAttributes?[.creationDate] as? Date {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .short
//            cell.dateLabel.text = "Created: \(formatter.string(from: creationDate))"
//        } else {
//            cell.dateLabel.text = "Created: Unknown"
//        }
        
        return UITableViewCell()
    }

    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = selectedDocumentURLs[indexPath.row]
        previewDocument(at: url)
    }

    func previewDocument(at url: URL) {
        documentInteractionController = UIDocumentInteractionController(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }

    // UIDocumentInteractionControllerDelegate methods
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}


