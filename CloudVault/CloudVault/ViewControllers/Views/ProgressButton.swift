//
//  ProgressButton.swift
//  CloudVault
//
//  Created by Appinators Technology on 11/09/2024.
//

import Foundation
import UIKit

class ProgressButton: UIButton {
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgressLayer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Set up the background layer (the white border)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 37, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.white.cgColor
        backgroundLayer.lineWidth = 4
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // Set up the progress layer (the animated progress border)
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = #colorLiteral(red: 0.2039215686, green: 0.4823529412, blue: 0.9294117647, alpha: 1)  // Choose a color for the progress
        progressLayer.lineWidth = 4
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0 // Initially, no progress
        
        // Add the layers
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    private func updateProgressLayer() {
        progressLayer.strokeEnd = progress
    }
    
    func setProgress(to progress: CGFloat, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            animation.duration = 2.0 // Set duration
            progressLayer.add(animation, forKey: "progressAnim")
        }
        self.progress = progress
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        progressLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}
