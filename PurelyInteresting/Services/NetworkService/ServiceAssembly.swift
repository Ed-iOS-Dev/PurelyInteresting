//
//  ServiceAssembly.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - ServiceAssembly

/// Точка сборки всех сервисов сетевого слоя
final class ServiceAssembly {
    
    // MARK: - Singleton
    
    static let shared = ServiceAssembly()
    
    // MARK: - Public Properties
    
    lazy var keychainService: KeychainServiceProtocol = KeychainService()
    
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    
    lazy var tokenManager: TokenManagerProtocol = TokenManager(
        keychain: keychainService,
        networkService: networkService
    )
    
    lazy var webSocketService: WebSocketServiceProtocol = WebSocketService()
    
    lazy var authService: AuthServiceProtocol = AuthService(
        networkService: networkService,
        webSocketService: webSocketService,
        tokenManager: tokenManager
    )
    
    lazy var apiClient: APIClientProtocol = APIClient(
        networkService: networkService,
        tokenManager: tokenManager
    )
    
    lazy var chatService: ChatServiceProtocol = ChatService(
        apiClient: apiClient
    )
    
    /// Создаёт новый экземпляр для каждого чата
    func makeCentrifugoService() -> CentrifugoServiceProtocol {
        CentrifugoService()
    }
    
    // MARK: - Initializers
    
    private init() {}
}
