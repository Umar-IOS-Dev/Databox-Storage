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

    init(images: CGFloat, videos: CGFloat, documents: CGFloat, audio: CGFloat, files: CGFloat, contacts: CGFloat, free: CGFloat) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints(images: images, videos: videos, documents: documents, audio: audio, files: files, contacts: contacts, free: free)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
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

    private func setupConstraints(images: CGFloat, videos: CGFloat, documents: CGFloat, audio: CGFloat, files: CGFloat, contacts: CGFloat, free: CGFloat) {
        let total = images + videos + documents + audio + files + contacts   + free

        imagesView.leadingAnchor == leadingAnchor
        imagesView.topAnchor == topAnchor
        imagesView.bottomAnchor == bottomAnchor
        imagesView.widthAnchor == widthAnchor * (images / total)

        videosView.leadingAnchor == imagesView.trailingAnchor
        videosView.topAnchor == topAnchor
        videosView.bottomAnchor == bottomAnchor
        videosView.widthAnchor == widthAnchor * (videos / total)
        
        documentsView.leadingAnchor == videosView.trailingAnchor
        documentsView.topAnchor == topAnchor
        documentsView.bottomAnchor == bottomAnchor
        documentsView.widthAnchor == widthAnchor * (documents / total)
        
        audioView.leadingAnchor == documentsView.trailingAnchor
        audioView.topAnchor == topAnchor
        audioView.bottomAnchor == bottomAnchor
        audioView.widthAnchor == widthAnchor * (audio / total)
        
        filesView.leadingAnchor == audioView.trailingAnchor
        filesView.topAnchor == topAnchor
        filesView.bottomAnchor == bottomAnchor
        filesView.widthAnchor == widthAnchor * (files / total)
        
        contactsView.leadingAnchor == filesView.trailingAnchor
        contactsView.topAnchor == topAnchor
        contactsView.bottomAnchor == bottomAnchor
        contactsView.widthAnchor == widthAnchor * (contacts / total)


        freeStorageView.leadingAnchor == contactsView.trailingAnchor
        freeStorageView.topAnchor == topAnchor
        freeStorageView.bottomAnchor == bottomAnchor
        freeStorageView.trailingAnchor == trailingAnchor
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

