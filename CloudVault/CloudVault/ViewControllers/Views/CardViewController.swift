//
//  CardViewController.swift
//  CloudVault
//
//  Created by Appinators Technology on 09/07/2024.
//

import UIKit
import Anchorage

protocol CardViewControllerDelegate: AnyObject {
    func showContent()
}

class CardViewController: UIViewController {
    
    private let cardView: CardView
    weak var delegate: CardViewControllerDelegate?
    
    init(title: String, description: String) {
        self.cardView = CardView(title: title, description: description)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        
        cardView.centerXAnchor == view.centerXAnchor
        cardView.centerYAnchor == view.centerYAnchor
        cardView.widthAnchor == view.widthAnchor * 0.84
        cardView.heightAnchor == 450//view.heightAnchor * 0.68
        
        cardView.cardDelegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissCard() {
        self.delegate?.showContent()
        dismiss(animated: true, completion: nil)
    }
    
    private func showLoginViewController() {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        
        // Set LoginViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

extension CardViewController: CardViewDelegate {
    func didTapContinueButton() {
        self.showLoginViewController()
    }
    
    
}
