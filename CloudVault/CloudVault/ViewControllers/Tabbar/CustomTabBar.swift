//
//  CustomTabBar.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/07/2024.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        // self.addShape() // for add curve
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - height * 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: centerWidth, y: height), controlPoint: CGPoint(x: centerWidth - height, y: 0))
        path.addQuadCurve(to: CGPoint(x: centerWidth + height * 2, y: 0), controlPoint: CGPoint(x: centerWidth + height, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100 // Custom height for the tab bar
        return sizeThatFits
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let pointInSubView = self.convert(point, to: self)
        if self.bounds.contains(pointInSubView) {
            return super.hitTest(point, with: event)
        } else {
            for subview in self.subviews {
                let pointInSubView = subview.convert(point, from: self)
                if subview.bounds.contains(pointInSubView) {
                    return subview.hitTest(pointInSubView, with: event)
                }
            }
        }
        return nil
    }
}


