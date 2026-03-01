//
//  AuthorizationPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

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
    private let authService: AuthServiceProtocol
    
    // MARK: - Initializers
    
    init(
        view: AuthorizationViewProtocol,
        coordinator: AuthCoordinator
    ) {
        self.view = view
        self.coordinator = coordinator
        self.authService = coordinator.authService
    }
    
    // MARK: - Public Methods
    
    func loginButtonTapped() {
        startAuthFlow()
    }
    
    func registerButtonTapped() {
        startAuthFlow()
    }
    
    // MARK: - Private Methods
    
    /// Шаг 1: Создаём анонимную сессию
    /// Шаг 2: Открываем ТГ-бота
    /// Шаг 3: Слушаем WebSocket до получения токенов
    private func startAuthFlow() {
        view?.showLoading(true)
        
        authService.createSession { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let session):
                self.openTelegramBot(sessionId: session.id)
                self.listenForAuth(sessionId: session.id)
                
            case .failure:
                self.view?.showLoading(false)
                self.view?.showError(
                    message: .sessionErrorMessage
                )
            }
        }
    }
    
    private func openTelegramBot(sessionId: String) {
        guard let url = authService.telegramBotURL(
            sessionId: sessionId
        ) else { return }
        
        UIApplication.shared.open(url)
    }
    
    private func listenForAuth(sessionId: String) {
        view?.showLoading(true)
        
        authService.startListeningForAuth(
            sessionId: sessionId,
            onConnected: { [weak self] in
                self?.view?.updateStatus(
                    message: .waitingForConfirmation
                )
            },
            onAuthorized: { [weak self] result in
                guard let self else { return }
                
                self.view?.showLoading(false)
                
                switch result {
                case .success:
                    self.coordinator.moveToMainScreen()
                    
                case .failure:
                    self.view?.showError(
                        message: .authErrorMessage
                    )
                }
            }
        )
    }
}

// MARK: - Constants

private extension String {
    
    static let sessionErrorMessage = "Не удалось создать сессию.\nПроверьте подключение к интернету."
    static let authErrorMessage = "Ошибка авторизации.\nПопробуйте ещё раз."
    static let waitingForConfirmation = "Подтвердите вход в Telegram..."
}
