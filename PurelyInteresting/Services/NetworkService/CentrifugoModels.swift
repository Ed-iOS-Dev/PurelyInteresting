//
//  CentrifugoModels.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import Foundation

// MARK: - SubscriptionTokenResponse

/// Ответ GET /chats/{chat_id}/subscribe и /chats/subscribe/all
struct SubscriptionTokenResponse: Codable {
    
    let token: String
    let channel: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case token, channel
        case expiresAt = "expires_at"
    }
}

// MARK: - Centrifugo Commands

/// Команда подключения к Centrifugo
struct CentrifugoConnectCommand: Codable {
    
    let id: Int
    let connect: CentrifugoConnectData
}

struct CentrifugoConnectData: Codable {
    
    let token: String
}

/// Команда подписки на канал
struct CentrifugoSubscribeCommand: Codable {
    
    let id: Int
    let subscribe: CentrifugoSubscribeData
}

struct CentrifugoSubscribeData: Codable {
    
    let channel: String
    let token: String
}

// MARK: - Centrifugo Responses

/// Ответ от Centrifugo (универсальный)
struct CentrifugoResponse: Codable {
    
    let id: Int?
    let connect: CentrifugoConnectResult?
    let subscribe: CentrifugoSubscribeResult?
    let push: CentrifugoPush?
    let error: CentrifugoError?
}

struct CentrifugoConnectResult: Codable {
    
    let client: String?
    let version: String?
}

struct CentrifugoSubscribeResult: Codable {
    
    let recoverable: Bool?
    let epoch: String?
}

struct CentrifugoError: Codable {
    
    let code: Int
    let message: String
}

// MARK: - Centrifugo Push (Incoming Messages)

struct CentrifugoPush: Codable {
    
    let channel: String?
    let pub: CentrifugoPublication?
}

struct CentrifugoPublication: Codable {
    
    let data: CentrifugoMessageData?
}

/// Данные нового сообщения из push
struct CentrifugoMessageData: Codable {
    
    let id: Int?
    let chatId: Int?
    let senderId: Int?
    let senderName: String?
    let senderAvatar: String?
    let content: String?
    let messageType: String?
    let createdAt: String?
    let files: [FileDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case senderId = "sender_id"
        case senderName = "sender_name"
        case senderAvatar = "sender_avatar"
        case content
        case messageType = "message_type"
        case createdAt = "created_at"
        case files
    }
    
    /// Конвертирует в ChatMessage
    func toChatMessage(currentUserId: Int?) -> ChatMessage {
        let isIncoming = senderId != currentUserId
        
        let date = createdAt
            .flatMap { DateFormatHelper.date(from: $0) }
            ?? Date()
        
        return ChatMessage(
            id: id ?? 0,
            senderId: senderId,
            content: content ?? "",
            isIncoming: isIncoming,
            timestamp: date,
            messageType: messageType ?? "text"
        )
    }
}
