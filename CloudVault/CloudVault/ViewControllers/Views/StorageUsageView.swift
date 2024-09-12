//
//  StorageUsageView.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/07/2024.
//

import UIKit
import Anchorage

class StorageUsageView: UIView {

    private let imagesView = CustomRoundedView()
    private let videosView = UIView()
    private let documentsView = UIView()
    private let audioView = UIView()
    private let filesView = UIView()
    private let contactsView = UIView()
    private let freeStorageView = CustomRoundedView()
    
    // Store the width constraints
    private var imagesWidthConstraint: NSLayoutConstraint?
    private var videosWidthConstraint: NSLayoutConstraint?
    private var documentsWidthConstraint: NSLayoutConstraint?
    private var audioWidthConstraint: NSLayoutConstraint?
    private var filesWidthConstraint: NSLayoutConstraint?
    private var contactsWidthConstraint: NSLayoutConstraint?
    private var freeStorageWidthConstraint: NSLayoutConstraint?

    init(images: CGFloat, videos: CGFloat, documents: CGFloat, audio: CGFloat, files: CGFloat, contacts: CGFloat, free: CGFloat) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        // Call the animate function after the view is fully set up
        DispatchQueue.main.async {
            self.animateViewChanges(images: images, videos: videos, documents: documents, audio: audio, files: files, contacts: contacts, free: free, duration: 2.0)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        imagesView.backgroundColor = #colorLiteral(red: 1, green: 0.3607843137, blue: 0.2196078431, alpha: 1)
        videosView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.6549019608, blue: 1, alpha: 1)
        documentsView.backgroundColor =  #colorLiteral(red: 0, green: 0.8588235294, blue: 0.6509803922, alpha: 1)
        audioView.backgroundColor = #colorLiteral(red: 0.8039215686, green: 0, blue: 0.8745098039, alpha: 1)
        filesView.backgroundColor = #colorLiteral(red: 1, green: 0.768627451, blue: 0.1294117647, alpha: 1)
        contactsView.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.8549019608, blue: 0.01960784314, alpha: 1)
        freeStorageView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 0.08155293367)
        
        imagesView.configureRoundedCorners(corners: [.bottomLeft, .topLeft], radius: 4)
        freeStorageView.configureRoundedCorners(corners: [.bottomRight, .topRight], radius: 4)

        addSubview(imagesView)
        addSubview(videosView)
        addSubview(documentsView)
        addSubview(audioView)
        addSubview(filesView)
        addSubview(contactsView)
        addSubview(freeStorageView)
    }

    private func setupConstraints() {
        // Initially set all views to zero width
        let zeroWidth = CGFloat(0)

        imagesWidthConstraint = imagesView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        videosWidthConstraint = videosView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        documentsWidthConstraint = documentsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        audioWidthConstraint = audioView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        filesWidthConstraint = filesView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        contactsWidthConstraint = contactsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)
        freeStorageWidthConstraint = freeStorageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: zeroWidth)

        // Activate constraints
        imagesWidthConstraint?.isActive = true
        videosWidthConstraint?.isActive = true
        documentsWidthConstraint?.isActive = true
        audioWidthConstraint?.isActive = true
        filesWidthConstraint?.isActive = true
        contactsWidthConstraint?.isActive = true
        freeStorageWidthConstraint?.isActive = true

        // Setup other constraints
        imagesView.leadingAnchor == leadingAnchor
        imagesView.topAnchor == topAnchor
        imagesView.bottomAnchor == bottomAnchor
        
        videosView.leadingAnchor == imagesView.trailingAnchor
        videosView.topAnchor == topAnchor
        videosView.bottomAnchor == bottomAnchor
        
        documentsView.leadingAnchor == videosView.trailingAnchor
        documentsView.topAnchor == topAnchor
        documentsView.bottomAnchor == bottomAnchor
        
        audioView.leadingAnchor == documentsView.trailingAnchor
        audioView.topAnchor == topAnchor
        audioView.bottomAnchor == bottomAnchor
        
        filesView.leadingAnchor == audioView.trailingAnchor
        filesView.topAnchor == topAnchor
        filesView.bottomAnchor == bottomAnchor
        
        contactsView.leadingAnchor == filesView.trailingAnchor
        contactsView.topAnchor == topAnchor
        contactsView.bottomAnchor == bottomAnchor
        
        freeStorageView.leadingAnchor == contactsView.trailingAnchor
        freeStorageView.topAnchor == topAnchor
        freeStorageView.bottomAnchor == bottomAnchor
        freeStorageView.trailingAnchor == trailingAnchor
    }

    func animateViewChanges(images: CGFloat, videos: CGFloat, documents: CGFloat, audio: CGFloat, files: CGFloat, contacts: CGFloat, free: CGFloat, duration: TimeInterval = 1.0) {
        // Ensure layout updates are applied
        layoutIfNeeded()

        // Calculate the target widths after layout
        DispatchQueue.main.async {
            let total = images + videos + documents + audio + files + contacts + free
            let totalWidth = self.bounds.width
            let imagesWidth = totalWidth * (images / total)
            let videosWidth = totalWidth * (videos / total)
            let documentsWidth = totalWidth * (documents / total)
            let audioWidth = totalWidth * (audio / total)
            let filesWidth = totalWidth * (files / total)
            let contactsWidth = totalWidth * (contacts / total)
            let freeStorageWidth = totalWidth * (free / total)

            // Update constraints
            self.imagesWidthConstraint?.constant = imagesWidth
            self.videosWidthConstraint?.constant = videosWidth
            self.documentsWidthConstraint?.constant = documentsWidth
            self.audioWidthConstraint?.constant = audioWidth
            self.filesWidthConstraint?.constant = filesWidth
            self.contactsWidthConstraint?.constant = contactsWidth
            self.freeStorageWidthConstraint?.constant = freeStorageWidth

            // Animate the change
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded() // Animate layout changes
            }) { _ in
                // Optionally configure the rounded corners after the animation completes
                self.imagesView.configureRoundedCorners(corners: [.bottomLeft, .topLeft], radius: 4)
                self.freeStorageView.configureRoundedCorners(corners: [.bottomRight, .topRight], radius: 4)
            }
        }
    }
}

// Usage:-

//let storageUsageView = StorageUsageView(images: 10, videos: 20, others: 5, free: 65)
//    view.addSubview(storageUsageView)
//
//    storageUsageView.leadingAnchor == view.leadingAnchor + 20
//    storageUsageView.trailingAnchor == view.trailingAnchor - 20
//    storageUsageView.centerYAnchor == view.centerYAnchor
//    storageUsageView.heightAnchor == 20
//storageUsageView.layer.cornerRadius = DesignMetrics.Padding.size8

