//
//  AuthorizationPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import Foundation

// MARK: - AuthorizationPresenterProtocol

protocol AuthorizationPresenterProtocol: AnyObject {
    
    func loginButtonTapped()
    func registerButtonTapped()
}

// MARK: - AuthorizationPresenter

final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: AuthorizationViewProtocol?
    private let coordinator: AuthCoordinator
    
    // MARK: - Initializers
    
    init(view: AuthorizationViewProtocol, coordinator: AuthCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
    func loginButtonTapped() {
        coordinator.moveToMainScreen()
    }
    
    func registerButtonTapped() {
        // TODO: - Реализация регистрации
    }
}
