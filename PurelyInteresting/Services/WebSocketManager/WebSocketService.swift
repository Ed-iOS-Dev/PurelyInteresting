//
//  WebSocketService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - WebSocketServiceProtocol

protocol WebSocketServiceProtocol: AnyObject {
    
    func connect(sessionId: String)
    func disconnect()
    
    var onTokensReceived: ((TokenResponse) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var onConnected: (() -> Void)? { get set }
}

// MARK: - WebSocketService

final class WebSocketService: NSObject, WebSocketServiceProtocol {
    
    // MARK: - Properties
    
    var onTokensReceived: ((TokenResponse) -> Void)?
    var onError: ((Error) -> Void)?
    var onConnected: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    // MARK: - Public Methods
    
    func connect(sessionId: String) {
        let urlString = BaseUrlType.websocket.rawValue
            + URLQueries.webSocketSession.rawValue
            + sessionId
        
        guard let url = URL(string: urlString) else {
            onError?(NetworkError.invalidURL)
            return
        }
        
        urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
        
        listenForMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        urlSession?.invalidateAndCancel()
        urlSession = nil
    }
    
    // MARK: - Private Methods
    
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.listenForMessages()
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        let data: Data?
        
        switch message {
        case .string(let text):
            data = text.data(using: .utf8)
        case .data(let messageData):
            data = messageData
        @unknown default:
            data = nil
        }
        
        guard let data,
              let tokenResponse = try? JSONDecoder().decode(
                TokenResponse.self, from: data
              )
        else {
            onError?(NetworkError.decodingError)
            return
        }
        
        onTokensReceived?(tokenResponse)
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketService: URLSessionWebSocketDelegate {
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        onConnected?()
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        // Соединение закрыто
    }
}
