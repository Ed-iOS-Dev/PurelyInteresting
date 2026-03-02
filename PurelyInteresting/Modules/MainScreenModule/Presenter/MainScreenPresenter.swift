//
//  MainScreenPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - MainScreenPresenterProtocol

protocol MainScreenPresenterProtocol: AnyObject {
    
    var chatItems: [ChatItem] { get }
    
    func viewDidLoad()
    func didSelectChat(at index: Int)
    func refreshChats()
    func searchChats(query: String)
    func composeMessage(recipient: String, text: String)
}

// MARK: - MainScreenPresenter

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: MainScreenViewProtocol?
    
    private(set) var chatItems: [ChatItem] = []
    
    private let coordinator: MainScreenCoordinator
    private let chatService: ChatServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    private var chatDTOs: [ChatDTO] = []
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Initializers
    
    init(
        view: MainScreenViewProtocol,
        coordinator: MainScreenCoordinator,
        chatService: ChatServiceProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.view = view
        self.coordinator = coordinator
        self.chatService = chatService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        loadChats()
    }
    
    func didSelectChat(at index: Int) {
        guard index < chatDTOs.count else { return }
        
        let dto = chatDTOs[index]
        let chatUser = dto.toChatUser()
        
        coordinator.moveToChatScreen(
            chatUser: chatUser,
            chatId: dto.id,
            otherUserId: dto.otherUser?.id
        )
    }
    
    func refreshChats() {
        loadChats()
    }
    
    func searchChats(query: String) {
        searchWorkItem?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            loadChats()
            return
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: trimmed)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3,
            execute: workItem
        )
    }
    
    func composeMessage(recipient: String, text: String) {
        view?.showLoading()
        
        // Определяем: число = recipient_id, строка = username
        let recipientId = Int(recipient)
        
        var parameters: [String: Any] = [
            "content": text,
            "message_type": "text"
        ]
        
        if let recipientId {
            parameters["recipient_id"] = recipientId
        } else {
            parameters["username"] = recipient
        }
        
        sendNewMessage(parameters: parameters)
    }
    
    // MARK: - Private Methods
    
    private func loadChats() {
        view?.showLoading()
        
        chatService.fetchChats(
            isInbox: true,
            offset: 0,
            limit: 20,
            search: nil
        ) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                self.chatDTOs = response.chats
                self.chatItems = response.chats.map {
                    $0.toChatItem(currentUserId: self.tokenManager.currentUserId)
                }
                self.view?.reloadChats()
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func performSearch(query: String) {
        view?.showLoading()
        
        chatService.fetchChats(
            isInbox: true,
            offset: 0,
            limit: 20,
            search: query
        ) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                self.chatDTOs = response.chats
                self.chatItems = response.chats.map {
                    $0.toChatItem(currentUserId: self.tokenManager.currentUserId)
                }
                self.view?.reloadChats()
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func sendNewMessage(parameters: [String: Any]) {
        chatService.sendMessageRaw(
            parameters: parameters
        ) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success:
                self.view?.showSuccess("Сообщение отправлено!")
                // Перезагружаем чаты — новый чат появится в списке
                self.loadChats()
                
            case .failure:
                self.view?.showError(
                    "Не удалось отправить сообщение"
                )
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if case NetworkError.unauthorized = error {
            view?.showError("Сессия истекла. Войдите заново.")
        } else {
            view?.showError("Не удалось загрузить чаты")
        }
    }
}
