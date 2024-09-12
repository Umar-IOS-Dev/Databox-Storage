//
//  AppIconView.swift
//  CloudVault
//
//  Created by Appinators Technology on 10/07/2024.
//

import UIKit
import Anchorage

class AppIconView: UIView {
    
//    private let backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private let backgroundImageView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "appIconImage1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "appIconImage1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "appIconImage3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "appIconImage1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "appIconImage1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appIconBgImageView6: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "appIconImage1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(backgroundImage: UIImage, iconImage: UIImage) {
        super.init(frame: .zero)
        setupView(backgroundImage: backgroundImage, iconImage: iconImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(backgroundImage: UIImage, iconImage: UIImage) {
        addSubview(backgroundImageView)
        addSubview(iconImageView)
        addSubview(appIconBgImageView1)
        addSubview(appIconBgImageView2)
        addSubview(appIconBgImageView3)
        addSubview(appIconBgImageView6)
        addSubview(appIconBgImageView4)
        addSubview(appIconBgImageView5)
        
       // backgroundImageView.image = backgroundImage
        iconImageView.image = iconImage
        
        backgroundImageView.edgeAnchors == edgeAnchors
        iconImageView.centerAnchors == centerAnchors
        iconImageView.widthAnchor == DesignMetrics.Dimensions.width130
        iconImageView.heightAnchor == DesignMetrics.Dimensions.height130
        
        appIconBgImageView1.leadingAnchor == iconImageView.leadingAnchor + 20
        appIconBgImageView1.topAnchor == backgroundImageView.topAnchor
        appIconBgImageView1.widthAnchor == 37
        appIconBgImageView1.heightAnchor == 21
        
        appIconBgImageView2.leadingAnchor == leadingAnchor - 8
        appIconBgImageView2.centerYAnchor == iconImageView.centerYAnchor
        appIconBgImageView2.widthAnchor == 80
        appIconBgImageView2.heightAnchor == 46
        
        appIconBgImageView3.leadingAnchor == iconImageView.leadingAnchor - 30
        appIconBgImageView3.bottomAnchor == iconImageView.bottomAnchor - 10
        appIconBgImageView3.widthAnchor == 37
        appIconBgImageView3.heightAnchor == 21
        
        appIconBgImageView6.leadingAnchor == leadingAnchor - 8
        appIconBgImageView6.topAnchor == appIconBgImageView1.topAnchor
        appIconBgImageView6.widthAnchor == 37
        appIconBgImageView6.heightAnchor == 21
        
        
        appIconBgImageView4.trailingAnchor == trailingAnchor - 20
        appIconBgImageView4.centerYAnchor == iconImageView.centerYAnchor
        appIconBgImageView4.widthAnchor == 100
        appIconBgImageView4.heightAnchor == 50
        
        appIconBgImageView5.trailingAnchor == trailingAnchor - 24
        appIconBgImageView5.topAnchor == appIconBgImageView1.topAnchor
        appIconBgImageView5.widthAnchor == 37
        appIconBgImageView5.heightAnchor == 21
        
        
    }
    
    // Function to animate icons
       func animateIcons() {
           let moveDistance: CGFloat = 30.0 // Distance to move
           
           // Animate from left to right and back with autoreverse
           UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {
               self.appIconBgImageView1.transform = CGAffineTransform(translationX: moveDistance, y: 0)
               self.appIconBgImageView2.transform = CGAffineTransform(translationX: moveDistance, y: 0)
               self.appIconBgImageView3.transform = CGAffineTransform(translationX: moveDistance, y: 0)
               self.appIconBgImageView4.transform = CGAffineTransform(translationX: moveDistance, y: 0)
               self.appIconBgImageView5.transform = CGAffineTransform(translationX: moveDistance, y: 0)
               self.appIconBgImageView6.transform = CGAffineTransform(translationX: moveDistance, y: 0)
           }, completion: nil)
       }
    
    // Function to rotate the iconImageView
        func rotateIconImageView() {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = CGFloat.pi * 2 // Full rotation (360 degrees)
            rotationAnimation.duration = 20.0 // Duration for one full rotation (slow rotation)
            rotationAnimation.repeatCount = .infinity // Repeat indefinitely
            iconImageView.layer.add(rotationAnimation, forKey: "rotate")
        }
    
    
}





