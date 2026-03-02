//
//  CentrifugoService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import Foundation

// MARK: - CentrifugoServiceProtocol

protocol CentrifugoServiceProtocol: AnyObject {
    
    /// Подключается к Centrifugo и подписывается на канал
    /// - Parameters:
    ///   - connectionToken: JWT access token для подключения к Centrifugo
    ///   - subscriptionToken: Токен из /chats/{id}/subscribe для подписки на канал
    ///   - channel: Название канала из /chats/{id}/subscribe
    ///   - onMessage: Callback при получении нового сообщения
    func subscribe(
        connectionToken: String,
        subscriptionToken: String,
        channel: String,
        onMessage: @escaping (CentrifugoMessageData) -> Void
    )
    
    /// Отключается от Centrifugo
    func disconnect()
}

// MARK: - CentrifugoService

final class CentrifugoService: NSObject, CentrifugoServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let websocketURL = "wss://interesnoitochka.ru/connection/websocket"
    }
    
    // MARK: - Private Properties
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    private var connectionToken: String?
    private var subscriptionToken: String?
    private var channel: String?
    private var commandId = 0
    
    private var onMessage: ((CentrifugoMessageData) -> Void)?
    
    // MARK: - Public Methods
    
    func subscribe(
        connectionToken: String,
        subscriptionToken: String,
        channel: String,
        onMessage: @escaping (CentrifugoMessageData) -> Void
    ) {
        self.connectionToken = connectionToken
        self.subscriptionToken = subscriptionToken
        self.channel = channel
        self.onMessage = onMessage
        
        connect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        urlSession?.invalidateAndCancel()
        urlSession = nil
        onMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func connect() {
        guard let url = URL(string: Constants.websocketURL) else { return }
        
        urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    /// Шаг 1: Отправляем connect с JWT access token
    private func sendConnectCommand() {
        guard let connectionToken else { return }
        
        commandId += 1
        let command = CentrifugoConnectCommand(
            id: commandId,
            connect: CentrifugoConnectData(token: connectionToken)
        )
        
        sendCommand(command)
    }
    
    /// Шаг 2: Подписываемся на канал с subscription token
    private func sendSubscribeCommand() {
        guard let channel, let subscriptionToken else { return }
        
        commandId += 1
        let command = CentrifugoSubscribeCommand(
            id: commandId,
            subscribe: CentrifugoSubscribeData(
                channel: channel,
                token: subscriptionToken
            )
        )
        
        sendCommand(command)
    }
    
    private func sendCommand<T: Encodable>(_ command: T) {
        guard let data = try? JSONEncoder().encode(command),
              let jsonString = String(data: data, encoding: .utf8)
        else { return }
        
        webSocketTask?.send(
            .string(jsonString)
        ) { error in
            if let error {
                print("[Centrifugo] Send error: \(error)")
            }
        }
    }
    
    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.listenForMessages()
                
            case .failure(let error):
                print("[Centrifugo] Receive error: \(error)")
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
        
        guard let data else { return }
        
        // Centrifugo может присылать несколько JSON в одной строке
        // разделённых \n
        let jsonStrings = String(data: data, encoding: .utf8)?
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty } ?? []
        
        for jsonString in jsonStrings {
            guard let jsonData = jsonString.data(using: .utf8) else {
                continue
            }
            parseResponse(jsonData)
        }
    }
    
    private func parseResponse(_ data: Data) {
        guard let response = try? JSONDecoder().decode(
            CentrifugoResponse.self, from: data
        ) else { return }
        
        // Ответ на connect — подписываемся на канал
        if response.connect != nil {
            print("[Centrifugo] Connected, subscribing to: \(channel ?? "")")
            sendSubscribeCommand()
            return
        }
        
        // Ответ на subscribe
        if response.subscribe != nil {
            print("[Centrifugo] Subscribed to channel: \(channel ?? "")")
            return
        }
        
        // Ошибка
        if let error = response.error {
            print("[Centrifugo] Error: \(error.code) - \(error.message)")
            return
        }
        
        // Push с новым сообщением
        if let push = response.push,
           let messageData = push.pub?.data {
            DispatchQueue.main.async { [weak self] in
                self?.onMessage?(messageData)
            }
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension CentrifugoService: URLSessionWebSocketDelegate {
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        print("[Centrifugo] WebSocket opened")
        sendConnectCommand()
        listenForMessages()
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        print("[Centrifugo] WebSocket closed")
    }
}
