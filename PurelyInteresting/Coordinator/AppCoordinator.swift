//
//  AppCoordinator.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Private Properties
    
    private let appBuilder = AppBuilder()
    private var authCoordinator: AuthCoordinator?
    private var mainTabBarCoordinator: MainTabBarCoordinator?
    
    // TODO: - Определять состояние авторизации
    private var isAuthorized: Bool = false
    
    // MARK: - Public Methods
    
    override func start() {
        if isAuthorized {
            goToMainTabBarScreen()
        } else {
            goToAuthScreen()
        }
    }
    
    // MARK: - Private Methods
    
    private func goToAuthScreen() {
        authCoordinator = AuthCoordinator(builder: appBuilder)
        guard let authCoordinator = authCoordinator else { return }
        
        add(coordinator: authCoordinator)
        authCoordinator.start()
        
        guard let rootController = authCoordinator.rootController else { return }
        setAsRoot(rootController)
        
        authCoordinator.onMoveToMainScreen = { [weak self] in
            self?.goToMainTabBarScreen()
        }
        
        authCoordinator.onFinishFlow = { [weak self] in
            self?.remove(coordinator: authCoordinator)
        }
    }
    
    private func goToMainTabBarScreen() {
        if let authCoordinator = authCoordinator {
            remove(coordinator: authCoordinator)
            self.authCoordinator = nil
        }
        
        mainTabBarCoordinator = MainTabBarCoordinator(builder: appBuilder)
        guard let mainTabBarCoordinator = mainTabBarCoordinator else { return }
        
        add(coordinator: mainTabBarCoordinator)
        mainTabBarCoordinator.start()
        
        mainTabBarCoordinator.onFinishFlow = { [weak self] in
            self?.remove(coordinator: mainTabBarCoordinator)
            self?.goToAuthScreen()
        }
    }
}
