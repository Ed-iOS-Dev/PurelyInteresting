//
//  MainTabBarController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainTabBarController

final class MainTabBarController: UITabBarController {
    
    // MARK: - Visual Components
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 22, weight: .bold
        )
        button.setImage(
            UIImage(
                systemName: .createIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.backgroundColor = .bgAction
        button.layer.cornerRadius = .createButtonSize / 2
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCreateButtonPosition()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupTabBar()
        setupCreateButton()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .bgPrimary
        tabBar.barTintColor = .bgPrimary
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .textSecondary
        tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bgPrimary
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCreateButton() {
        view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func updateCreateButtonPosition() {
        createButton.frame = CGRect(
            x: (tabBar.bounds.width - .createButtonSize) / 2,
            y: tabBar.frame.origin.y - .createButtonOffset,
            width: .createButtonSize,
            height: .createButtonSize
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func createButtonTapped() {
        // TODO: - Обработка нажатия на "+"
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let createButtonSize: Self = 50
    static let createButtonOffset: Self = 12
}

private extension String {
    
    static let createIcon = "plus"
}
