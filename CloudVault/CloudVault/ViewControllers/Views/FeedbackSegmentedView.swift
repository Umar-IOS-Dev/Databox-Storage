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
                       underlineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
                       underlineView.widthAnchor.constraint(equalToConstant: 80)
                   ])
        DispatchQueue.main.async {
            self.updateUnderlinePosition(index: 0, currentButton: self.buttons[0])
        }
                   
       
    }
        
        @objc private func segmentTapped(_ sender: UIButton) {
            let index = sender.tag
            DispatchQueue.main.async {
                self.updateUnderlinePosition(index: index, currentButton: sender)
            }
            didSelectSegment?(index)
        }
        
    private func updateUnderlinePosition(index: Int, currentButton: UIButton) {
                UIView.animate(withDuration: 0.3) {
                    let selectedButton = currentButton
                            
                            // Calculate the width of the button's text
                            let buttonText = selectedButton.titleLabel?.text ?? ""
                            let font = selectedButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 17)
                            let textWidth = (buttonText as NSString).size(withAttributes: [.font: font]).width
                    
                    switch index {
                    case 0:
                        self.underlineView.frame.origin.x = currentButton.frame.origin.x + 20 //self.buttons[index].frame.origin.x + (selectedButton.frame.width - textWidth) / 2//self.buttons[index].frame.origin.x //+ 16
                        self.buttons[0].setTitleColor(self.buttonEnableTextColor, for: .normal)
                        self.buttons[1].setTitleColor(self.buttonDisableTextColor, for: .normal)
                        self.buttons[2].setTitleColor(self.buttonDisableTextColor, for: .normal)

                    case 1:
                        self.underlineView.frame.origin.x = currentButton.frame.origin.x + 16 //self.buttons[index].frame.origin.x + (selectedButton.frame.width - textWidth) / 2//self.buttons[index].frame.origin.x //+ 12
                        self.buttons[0].setTitleColor(self.buttonDisableTextColor, for: .normal)
                        self.buttons[1].setTitleColor(self.buttonEnableTextColor, for: .normal)
                        self.buttons[2].setTitleColor(self.buttonDisableTextColor, for: .normal)
                        
                    case 2:
                        self.underlineView.frame.origin.x = currentButton.frame.origin.x + 32 //self.buttons[index].frame.origin.x + (selectedButton.frame.width - textWidth) / 2//self.buttons[index].frame.origin.x //+ 16
                        self.buttons[0].setTitleColor(self.buttonDisableTextColor, for: .normal)
                        self.buttons[1].setTitleColor(self.buttonDisableTextColor, for: .normal)
                        self.buttons[2].setTitleColor(self.buttonEnableTextColor, for: .normal)
                        
                    default:
                        break
                    }
                }
            }

        
        func selectSegment(index: Int) {
            DispatchQueue.main.async {
                self.updateUnderlinePosition(index: index, currentButton: self.buttons[index])
            }
        }

}
