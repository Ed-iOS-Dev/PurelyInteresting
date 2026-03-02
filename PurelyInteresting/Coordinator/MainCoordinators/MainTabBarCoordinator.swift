//
//  MainTabBarCoordinator.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainTabBarCoordinator

final class MainTabBarCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    let builder: AppBuilder
    var tabBarController: MainTabBarController?
    
    var onFinishFlow: (() -> Void)?
    
    // MARK: - Initializers
    
    init(builder: AppBuilder) {
        self.builder = builder
    }
    
    // MARK: - Public Methods
    
    override func start() {
        tabBarController = MainTabBarController()
        
        /// Feed Tab (index 0)
        let feedVC = builder.makeFeedModule()
        let feedNav = UINavigationController(rootViewController: feedVC)
        
        /// Saved Tab (index 1)
        let savedVC = builder.makeSavedModule()
        let savedNav = UINavigationController(rootViewController: savedVC)
        
        /// Create Placeholder (index 2) — не используется, кнопка в кастомном tab bar
        let createPlaceholderVC = UIViewController()
        
        /// Messages Tab (index 3)
        let mainScreenCoordinator = MainScreenCoordinator(builder: builder)
        let mainScreenVC = builder.makeMainScreenModule(
            coordinator: mainScreenCoordinator
        )
        mainScreenCoordinator.setViewController(controller: mainScreenVC)
        add(coordinator: mainScreenCoordinator)
        
        /// Profile Tab (index 4)
        let profileVC = builder.makeProfileModule()
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        tabBarController?.setViewControllers([
            feedNav,
            savedNav,
            createPlaceholderVC,
            mainScreenCoordinator.rootController ?? UINavigationController(),
            profileNav
        ], animated: false)
        
        tabBarController?.selectedIndex = 3
        
        setAsRoot(tabBarController ?? UITabBarController())
    }
}
