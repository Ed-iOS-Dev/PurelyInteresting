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
        
        /// Feed Tab
        let feedVC = builder.makeFeedModule()
        let feedNav = UINavigationController(rootViewController: feedVC)
        
        /// Saved Tab
        let savedVC = builder.makeSavedModule()
        let savedNav = UINavigationController(rootViewController: savedVC)
        
        /// Create Placeholder (центральная кнопка)
        let createPlaceholderVC = UIViewController()
        createPlaceholderVC.tabBarItem = UITabBarItem(
            title: nil, image: nil, selectedImage: nil
        )
        createPlaceholderVC.tabBarItem.isEnabled = false
        
        /// Messages Tab
        let mainScreenCoordinator = MainScreenCoordinator(builder: builder)
        let mainScreenVC = builder.makeMainScreenModule(
            coordinator: mainScreenCoordinator
        )
        mainScreenCoordinator.setViewController(controller: mainScreenVC)
        add(coordinator: mainScreenCoordinator)
        
        /// Profile Tab
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
