//
//  FeedbackSegmentedView.swift
//  CloudVault
//
//  Created by Appinators Technology on 19/08/2024.
//

import UIKit
import Anchorage

class FeedbackSegmentedView: UIView {

    var buttons: [UIButton] = []
        var underlineView: UIView!
        
        var didSelectSegment: ((Int) -> Void)?
    
    let buttonEnableTextColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
    let buttonDisableTextColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 0.4309895833)

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            self.backgroundColor = .clear
            let buttonTitles = ["Feedback", "Your Feedback", "Reply"]
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            for (index, title) in buttonTitles.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.setTitleColor(buttonEnableTextColor, for: .normal)
                button.setTitleColor(buttonDisableTextColor, for: .disabled)
                button.tag = index
                button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
                buttons.append(button)
                stackView.addArrangedSubview(button)
            }
            
            addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            underlineView = UIView()
            underlineView.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2, blue: 0.2784313725, alpha: 1)
            addSubview(underlineView)
            underlineView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                underlineView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
                underlineView.heightAnchor.constraint(equalToConstant: 2),
                underlineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
                underlineView.widthAnchor.constraint(equalToConstant: 110)
            ])
            updateUnderlinePosition(index: 0)
        }
        
        @objc private func segmentTapped(_ sender: UIButton) {
            let index = sender.tag
            updateUnderlinePosition(index: index)
            didSelectSegment?(index)
        }
        
        private func updateUnderlinePosition(index: Int) {
            UIView.animate(withDuration: 0.3) {
                switch index {
                case 0:
                    self.underlineView.frame.origin.x = self.buttons[index].frame.origin.x + 16
                    self.buttons[0].isEnabled = true
                    self.buttons[1].isEnabled = false
                    self.buttons[2].isEnabled = false
                case 1:
                    self.underlineView.frame.origin.x = self.buttons[index].frame.origin.x + 12
                    self.buttons[0].isEnabled = false
                    self.buttons[1].isEnabled = true
                    self.buttons[2].isEnabled = false
                case 2:
                    self.underlineView.frame.origin.x = self.buttons[index].frame.origin.x + 16
                    self.buttons[0].isEnabled = false
                    self.buttons[1].isEnabled = false
                    self.buttons[2].isEnabled = true
                default:
                    break
                }
            }
        }
        
        func selectSegment(index: Int) {
            updateUnderlinePosition(index: index)
        }

}
