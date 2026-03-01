//
//  AuthCoordinator.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - AuthCoordinator

final class AuthCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    let builder: AppBuilder
    let authService: AuthServiceProtocol
    var rootController: UINavigationController?
    
    var onFinishFlow: (() -> Void)?
    var onMoveToMainScreen: (() -> Void)?
    
    // MARK: - Initializers
    
    init(builder: AppBuilder, authService: AuthServiceProtocol) {
        self.builder = builder
        self.authService = authService
    }
    
    // MARK: - Public Methods
    
    override func start() {
        let authVC = builder.makeAuthorizationModule(coordinator: self)
        rootController = UINavigationController(rootViewController: authVC)
    }
    
    func moveToMainScreen() {
        onMoveToMainScreen?()
    }
}
