//
//  ChatPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - ChatPresenterProtocol

protocol ChatPresenterProtocol: AnyObject {
    
    func sendMessage(_ text: String)
    func viewProfileTapped()
}

// MARK: - ChatPresenter

final class ChatPresenter: ChatPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: ChatViewProtocol?
    private let coordinator: MainScreenCoordinator
    
    // MARK: - Initializers
    
    init(view: ChatViewProtocol, coordinator: MainScreenCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
    func sendMessage(_ text: String) {
        // TODO: - Отправка сообщения
    }
    
    func viewProfileTapped() {
        // TODO: - Переход на экран профиля
    }
}
