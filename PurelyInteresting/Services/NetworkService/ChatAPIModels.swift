//
//  ChatAPIModels.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import Foundation

// MARK: - ChatsListResponse

/// Ответ GET /chats
struct ChatsListResponse: Codable {
    
    let count: Int
    let chats: [ChatDTO]
}

// MARK: - ChatDTO

struct ChatDTO: Codable {
    
    let id: Int
    let type: String
    let name: String?
    let avatarUrl: String?
    let otherUser: OtherUserDTO?
    let lastMessage: LastMessageDTO?
    
    enum CodingKeys: String, CodingKey {
        case id, type, name
        case avatarUrl = "avatar_url"
        case otherUser = "other_user"
        case lastMessage = "last_message"
    }
}

// MARK: - OtherUserDTO

struct OtherUserDTO: Codable {
    
    let id: Int
    let name: String?
    let avatarUrl: String?
    let chattingNickname: String?
    let registeredAt: String?
    let lastSeenAt: String?
    let isPro: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case avatarUrl = "avatar_url"
        case chattingNickname = "chatting_nickname"
        case registeredAt = "registered_at"
        case lastSeenAt = "last_seen_at"
        case isPro = "is_pro"
    }
}

// MARK: - LastMessageDTO

struct LastMessageDTO: Codable {
    
    let id: Int
    let senderId: Int?
    let content: String?
    let videoId: Int?
    let nomenclatureId: String?
    let forwardedFromId: Int?
    let fileIds: [Int]?
    let createdAt: String?
    let isRead: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case content
        case videoId = "video_id"
        case nomenclatureId = "nomenclature_id"
        case forwardedFromId = "forwarded_from_id"
        case fileIds = "file_ids"
        case createdAt = "created_at"
        case isRead = "is_read"
    }
}

// MARK: - MessagesListResponse

/// Ответ GET /chats/{chat_id}/messages
struct MessagesListResponse: Codable {
    
    let count: Int
    let messages: [MessageDTO]
}

// MARK: - MessageDTO

struct MessageDTO: Codable {
    
    let id: Int
    let chatId: Int?
    let senderId: Int?
    let senderName: String?
    let senderAvatar: String?
    let content: String?
    let messageType: String?
    let replyToId: Int?
    let forwardedFromId: Int?
    let videoId: Int?
    let nomenclatureId: String?
    let isDeleted: Bool?
    let editedAt: String?
    let createdAt: String?
    let reactions: [ReactionDTO]?
    let files: [FileDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case senderId = "sender_id"
        case senderName = "sender_name"
        case senderAvatar = "sender_avatar"
        case content
        case messageType = "message_type"
        case replyToId = "reply_to_id"
        case forwardedFromId = "forwarded_from_id"
        case videoId = "video_id"
        case nomenclatureId = "nomenclature_id"
        case isDeleted = "is_deleted"
        case editedAt = "edited_at"
        case createdAt = "created_at"
        case reactions, files
    }
}

// MARK: - ReactionDTO

struct ReactionDTO: Codable {
    
    let emoji: String?
    let count: Int?
}

// MARK: - FileDTO

struct FileDTO: Codable {
    
    let id: Int?
    let fileUrl: String?
    let fileName: String?
    let fileType: String?
    let fileSize: Int?
    let mimeType: String?
    let thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fileUrl = "file_url"
        case fileName = "file_name"
        case fileType = "file_type"
        case fileSize = "file_size"
        case mimeType = "mime_type"
        case thumbnailUrl = "thumbnail_url"
    }
}

// MARK: - SendMessageRequest

/// Тело POST /chats/messages
struct SendMessageRequest: Codable {
    
    let recipientId: Int?
    let username: String?
    let content: String
    let messageType: String
    let fileIds: [Int]?
    let replyToMessageId: Int?
    
    enum CodingKeys: String, CodingKey {
        case content
        case messageType = "message_type"
        case recipientId = "recipient_id"
        case username
        case fileIds = "file_ids"
        case replyToMessageId = "reply_to_message_id"
    }
}

// MARK: - SendMessageResponse

struct SendMessageResponse: Codable {
    
    let messageId: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case status
    }
}
