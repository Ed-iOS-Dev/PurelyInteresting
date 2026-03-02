//
//  BaseCoordinator.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - BaseCoordinator

class BaseCoordinator {
    
    // MARK: - Public Properties
    
    var childCoordinators: [BaseCoordinator] = []
    
    // MARK: - Public Methods
    
    func start() {
        fatalError("child должен быть реализован")
    }
    
    func add(coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(coordinator: BaseCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func setAsRoot(_ controller: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
