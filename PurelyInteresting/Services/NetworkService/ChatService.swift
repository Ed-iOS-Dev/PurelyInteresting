//
//  ChatService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import Foundation

// MARK: - ChatServiceProtocol

protocol ChatServiceProtocol: AnyObject {
    
    /// Получить список чатов
    func fetchChats(
        isInbox: Bool,
        offset: Int,
        limit: Int,
        completion: @escaping (Result<ChatsListResponse, Error>) -> Void
    )
    
    /// Получить детали чата
    func fetchChatDetail(
        chatId: Int,
        completion: @escaping (Result<ChatDTO, Error>) -> Void
    )
    
    /// Получить сообщения чата
    func fetchMessages(
        chatId: Int,
        offset: Int,
        limit: Int,
        completion: @escaping (Result<MessagesListResponse, Error>) -> Void
    )
    
    /// Отправить текстовое сообщение
    func sendMessage(
        recipientId: Int,
        content: String,
        completion: @escaping (Result<SendMessageResponse, Error>) -> Void
    )
}

// MARK: - ChatService

final class ChatService: ChatServiceProtocol {
    
    // MARK: - Private Properties
    
    private let apiClient: APIClientProtocol
    
    // MARK: - Initializers
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    func fetchChats(
        isInbox: Bool = true,
        offset: Int = 0,
        limit: Int = 20,
        completion: @escaping (Result<ChatsListResponse, Error>) -> Void
    ) {
        let queryParams: [String: Any] = [
            "is_in_inbox": isInbox,
            "offset": offset,
            "limit": limit
        ]
        
        apiClient.authorizedRequest(
            query: .chats,
            httpMethodType: .get,
            parameters: nil,
            inQueryParameters: queryParams
        ) { result in
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(
                    ChatsListResponse.self, from: data
                ) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchChatDetail(
        chatId: Int,
        completion: @escaping (Result<ChatDTO, Error>) -> Void
    ) {
        let path = "/api/v1/chats/\(chatId)"
        
        apiClient.authorizedRequest(
            path: path,
            httpMethodType: .get,
            parameters: nil,
            inQueryParameters: nil
        ) { result in
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(
                    ChatDTO.self, from: data
                ) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMessages(
        chatId: Int,
        offset: Int = 0,
        limit: Int = 50,
        completion: @escaping (Result<MessagesListResponse, Error>) -> Void
    ) {
        let queryParams: [String: Any] = [
            "offset": offset,
            "limit": limit
        ]
        
        let path = "/api/v1/chats/\(chatId)/messages"
        
        apiClient.authorizedRequest(
            path: path,
            httpMethodType: .get,
            parameters: nil,
            inQueryParameters: queryParams
        ) { result in
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(
                    MessagesListResponse.self, from: data
                ) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendMessage(
        recipientId: Int,
        content: String,
        completion: @escaping (Result<SendMessageResponse, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "recipient_id": recipientId,
            "content": content,
            "message_type": "text"
        ]
        
        apiClient.authorizedRequest(
            query: .sendMessage,
            httpMethodType: .post,
            parameters: parameters,
            inQueryParameters: nil
        ) { result in
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(
                    SendMessageResponse.self, from: data
                ) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
