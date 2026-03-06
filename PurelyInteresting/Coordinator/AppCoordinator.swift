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
    private let services = ServiceAssembly.shared
    
    private var authCoordinator: AuthCoordinator?
    private var mainTabBarCoordinator: MainTabBarCoordinator?
    
    // MARK: - Public Methods
    
    override func start() {
        if services.tokenManager.isAuthorized {
            goToMainTabBarScreen()
        } else {
            //goToMainTabBarScreen()
            goToAuthScreen()
        }
    }
    
    // MARK: - Private Methods
    
    private func goToAuthScreen() {
        authCoordinator = AuthCoordinator(
            builder: appBuilder,
            authService: services.authService
        )
        guard let authCoordinator else { return }
        
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
        if let authCoordinator {
            remove(coordinator: authCoordinator)
            self.authCoordinator = nil
        }
        
        mainTabBarCoordinator = MainTabBarCoordinator(builder: appBuilder)
        guard let mainTabBarCoordinator else { return }
        
        add(coordinator: mainTabBarCoordinator)
        mainTabBarCoordinator.start()
        
        mainTabBarCoordinator.onFinishFlow = { [weak self] in
            self?.remove(coordinator: mainTabBarCoordinator)
            self?.services.tokenManager.clearTokens()
            self?.goToAuthScreen()
        }
    }
}
