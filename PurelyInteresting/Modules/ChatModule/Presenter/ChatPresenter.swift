//
//  ChatPresenter.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - ChatPresenterProtocol

protocol ChatPresenterProtocol: AnyObject {
    
    var messages: [ChatMessage] { get }
    
    func viewDidLoad()
    func sendMessage(_ text: String)
    func viewProfileTapped()
    func loadMoreMessages()
}

// MARK: - ChatPresenter

final class ChatPresenter: ChatPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: ChatViewProtocol?
    
    private(set) var messages: [ChatMessage] = []
    
    private let coordinator: MainScreenCoordinator
    private let chatService: ChatServiceProtocol
    private let chatId: Int
    private let otherUserId: Int?
    
    private var currentOffset = 0
    private var totalCount = 0
    private var isLoadingMore = false
    
    // MARK: - Constants
    
    private enum Constants {
        static let messagesLimit = 50
    }
    
    // MARK: - Initializers
    
    init(
        view: ChatViewProtocol,
        coordinator: MainScreenCoordinator,
        chatService: ChatServiceProtocol,
        chatId: Int,
        otherUserId: Int?
    ) {
        self.view = view
        self.coordinator = coordinator
        self.chatService = chatService
        self.chatId = chatId
        self.otherUserId = otherUserId
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        loadMessages()
    }
    
    func sendMessage(_ text: String) {
        guard let recipientId = otherUserId else { return }
        
        chatService.sendMessage(
            recipientId: recipientId,
            content: text
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let localMessage = ChatMessage(
                    id: Int.random(in: 100_000 ... 999_999),
                    senderId: nil,
                    content: text,
                    isIncoming: false,
                    timestamp: Date(),
                    messageType: "text"
                )
                self.messages.append(localMessage)
                self.view?.reloadMessages()
                self.view?.scrollToBottom()
                
            case .failure:
                self.view?.showError("Не удалось отправить сообщение")
            }
        }
    }
    
    func viewProfileTapped() {
        // TODO: - Переход на экран профиля
    }
    
    func loadMoreMessages() {
        guard !isLoadingMore,
              messages.count < totalCount
        else { return }
        
        isLoadingMore = true
        currentOffset += Constants.messagesLimit
        
        chatService.fetchMessages(
            chatId: chatId,
            offset: currentOffset,
            limit: Constants.messagesLimit
        ) { [weak self] result in
            guard let self else { return }
            
            self.isLoadingMore = false
            
            switch result {
            case .success(let response):
                let newMessages = response.messages.map {
                    $0.toChatMessage(currentUserId: nil)
                }
                self.messages.insert(contentsOf: newMessages, at: 0)
                self.view?.reloadMessages()
                
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMessages() {
        view?.showLoading()
        
        chatService.fetchMessages(
            chatId: chatId,
            offset: 0,
            limit: Constants.messagesLimit
        ) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                self.totalCount = response.count
                // API возвращает от новых к старым, разворачиваем
                self.messages = response.messages.reversed().map {
                    $0.toChatMessage(currentUserId: nil)
                }
                self.view?.reloadMessages()
                self.view?.scrollToBottom()
                
            case .failure(let error):
                if case NetworkError.unauthorized = error {
                    self.view?.showError("Сессия истекла")
                } else {
                    self.view?.showError("Не удалось загрузить сообщения")
                }
            }
        }
    }
}
