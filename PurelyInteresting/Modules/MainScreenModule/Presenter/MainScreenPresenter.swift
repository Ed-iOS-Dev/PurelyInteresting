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
}

// MARK: - MainScreenPresenter

final class MainScreenPresenter: MainScreenPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: MainScreenViewProtocol?
    
    private(set) var chatItems: [ChatItem] = []
    
    private let coordinator: MainScreenCoordinator
    private let chatService: ChatServiceProtocol
    
    private var currentUserId: Int?
    private var chatDTOs: [ChatDTO] = []
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Initializers
    
    init(
        view: MainScreenViewProtocol,
        coordinator: MainScreenCoordinator,
        chatService: ChatServiceProtocol
    ) {
        self.view = view
        self.coordinator = coordinator
        self.chatService = chatService
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
        // Отменяем предыдущий запрос (debounce)
        searchWorkItem?.cancel()
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Пустой запрос — загружаем все чаты
        guard !trimmed.isEmpty else {
            loadChats()
            return
        }
        
        // Debounce 300ms
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: trimmed)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3,
            execute: workItem
        )
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
                    $0.toChatItem(currentUserId: self.currentUserId)
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
                    $0.toChatItem(currentUserId: self.currentUserId)
                }
                self.view?.reloadChats()
                
            case .failure(let error):
                self.handleError(error)
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
