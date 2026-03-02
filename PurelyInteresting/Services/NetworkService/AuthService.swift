//
//  AuthService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - AuthServiceProtocol

protocol AuthServiceProtocol: AnyObject {
    
    /// Запрашивает новую анонимную сессию
    func createSession(
        completion: @escaping (Result<SessionResponse, Error>) -> Void
    )
    
    /// Подключается к WebSocket и ждёт токены от ТГ-бота
    func startListeningForAuth(
        sessionId: String,
        onConnected: @escaping () -> Void,
        onAuthorized: @escaping (Result<TokenResponse, Error>) -> Void
    )
    
    /// Прекращает прослушивание WebSocket
    func stopListeningForAuth()
    
    /// Формирует ссылку для открытия ТГ-бота с параметром сессии
    func telegramBotURL(sessionId: String) -> URL?
}

// MARK: - AuthService

final class AuthService: AuthServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let telegramBotBaseURL = "https://t.me/chatttinnngggbot?start="
    }
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private let webSocketService: WebSocketServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    // MARK: - Initializers
    
    init(
        networkService: NetworkServiceProtocol,
        webSocketService: WebSocketServiceProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.networkService = networkService
        self.webSocketService = webSocketService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Public Methods
    
    func createSession(
        completion: @escaping (Result<SessionResponse, Error>) -> Void
    ) {
        networkService.sendRequest(
            baseURL: .baseUrl,
            query: .newSession,
            httpMethodType: .get,
            token: nil,
            contentType: .json,
            parameters: nil,
            inQueryParameters: nil
        ) { [weak self] result in
            switch result {
            case .success(let data):
                guard let session = try? JSONDecoder().decode(
                    SessionResponse.self, from: data
                ) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                
                self?.tokenManager.saveSessionId(session.id)
                completion(.success(session))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func startListeningForAuth(
        sessionId: String,
        onConnected: @escaping () -> Void,
        onAuthorized: @escaping (Result<TokenResponse, Error>) -> Void
    ) {
        webSocketService.onConnected = {
            onConnected()
        }
        
        webSocketService.onTokensReceived = { [weak self] tokenResponse in
            self?.tokenManager.saveTokens(response: tokenResponse)
            self?.webSocketService.disconnect()
            onAuthorized(.success(tokenResponse))
        }
        
        webSocketService.onError = { [weak self] error in
            self?.webSocketService.disconnect()
            onAuthorized(.failure(error))
        }
        
        webSocketService.connect(sessionId: sessionId)
    }
    
    func stopListeningForAuth() {
        webSocketService.disconnect()
    }
    
    func telegramBotURL(sessionId: String) -> URL? {
        URL(string: Constants.telegramBotBaseURL + sessionId)
    }
}
