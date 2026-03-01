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
        setupViewControllers()
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
    
    private func setupViewControllers() {
        let feedVC = createNavController(
            rootViewController: PlaceholderViewController(title: .feedTitle),
            icon: .feedIcon,
            selectedIcon: .feedIconSelected
        )
        
        let savedVC = createNavController(
            rootViewController: PlaceholderViewController(title: .savedTitle),
            icon: .savedIcon,
            selectedIcon: .savedIconSelected
        )
        
        let createPlaceholderVC = UIViewController()
        createPlaceholderVC.tabBarItem = UITabBarItem(
            title: nil, image: nil, selectedImage: nil
        )
        createPlaceholderVC.tabBarItem.isEnabled = false
        
        let messagesVC = createNavController(
            rootViewController: MainScreenViewController(),
            icon: .messagesIcon,
            selectedIcon: .messagesIconSelected
        )
        
        let profileVC = createNavController(
            rootViewController: PlaceholderViewController(title: .profileTitle),
            icon: .profileIcon,
            selectedIcon: .profileIconSelected
        )
        
        viewControllers = [
            feedVC,
            savedVC,
            createPlaceholderVC,
            messagesVC,
            profileVC
        ]
        
        selectedIndex = 3
    }
    
    private func createNavController(
        rootViewController: UIViewController,
        icon: String,
        selectedIcon: String
    ) -> UINavigationController {
        
        let navController = UINavigationController(
            rootViewController: rootViewController
        )
        
        navController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: icon),
            selectedImage: UIImage(systemName: selectedIcon)
        )
        
        return navController
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

// MARK: - PlaceholderViewController

final class PlaceholderViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleText: String
    
    // MARK: - Initializers
    
    init(title: String) {
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .bgPrimary
        
        let label = UILabel()
        label.text = titleText
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let createButtonSize: Self = 50
    static let createButtonOffset: Self = 12
}

private extension String {
    
    static let feedTitle = "Лента"
    static let savedTitle = "Избранное"
    static let profileTitle = "Профиль"
    
    static let feedIcon = "house"
    static let feedIconSelected = "house.fill"
    static let savedIcon = "heart"
    static let savedIconSelected = "heart.fill"
    static let createIcon = "plus"
    static let messagesIcon = "bubble.left.and.bubble.right"
    static let messagesIconSelected = "bubble.left.and.bubble.right.fill"
    static let profileIcon = "person.circle"
    static let profileIconSelected = "person.circle.fill"
}
