//
//  MainScreenPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - MainScreenPresenterProtocol

protocol MainScreenPresenterProtocol: AnyObject {
    
    func didSelectChat(at index: Int)
}

// MARK: - MainScreenPresenter

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: MainScreenViewProtocol?
    private let coordinator: MainScreenCoordinator
    
    private let chatItems = MockData.chatItems
    
    // MARK: - Initializers
    
    init(view: MainScreenViewProtocol, coordinator: MainScreenCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    
    func didSelectChat(at index: Int) {
        let item = chatItems[index]
        
        let chatUser = ChatUser(
            username: item.username,
            avatarImage: item.avatarImage,
            lastSeenStatus: item.lastMessage,
            subscriptionStatus: "Вы подписаны друг на друга",
            registrationDate: "Дата регистрации 5 мая 2024"
        )
        
        coordinator.moveToChatScreen(chatUser: chatUser)
    }
}
