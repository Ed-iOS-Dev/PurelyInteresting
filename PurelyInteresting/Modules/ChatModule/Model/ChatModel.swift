//
//  ChatModel.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatItem

/// Элемент списка чатов на главном экране
struct ChatItem {
    
    let chatId: Int
    let username: String
    let lastMessage: String
    let time: String
    let avatarUrl: String?
    let isOnline: Bool
    let isVerified: Bool
    let unreadCount: Int
    let otherUserId: Int?
    
    /// Загруженное изображение (кешируется после скачивания)
    var avatarImage: UIImage?
}

// MARK: - ChatUser

struct ChatUser {
    
    let userId: Int
    let username: String
    let avatarUrl: String?
    let lastSeenStatus: String
    let subscriptionStatus: String
    let registrationDate: String
    
    var avatarImage: UIImage?
}

// MARK: - ChatMessage

/// Сообщение внутри чата
struct ChatMessage {
    
    let id: Int
    let senderId: Int?
    let content: String
    let isIncoming: Bool
    let timestamp: Date
    let messageType: String
}

// MARK: - ChatDTO Mapping

extension ChatDTO {
    
    /// Конвертирует DTO в модель для отображения
    func toChatItem(currentUserId: Int?) -> ChatItem {
        let displayName = otherUser?.chattingNickname
            ?? otherUser?.name
            ?? name
            ?? "Неизвестный"
        
        let messageText = lastMessage?.content ?? ""
        
        let timeString = lastMessage?.createdAt
            .flatMap { DateFormatHelper.shortTime(from: $0) } ?? ""
        
        let isOnline: Bool = {
            guard let lastSeen = otherUser?.lastSeenAt else { return false }
            return DateFormatHelper.isRecentlyOnline(dateString: lastSeen)
        }()
        
        let isPro = otherUser?.isPro ?? false
        
        let isRead = lastMessage?.isRead ?? true
        let isMine = lastMessage?.senderId == currentUserId
        let unread = (!isRead && !isMine) ? 1 : 0
        
        return ChatItem(
            chatId: id,
            username: displayName,
            lastMessage: messageText,
            time: timeString,
            avatarUrl: otherUser?.avatarUrl ?? avatarUrl,
            isOnline: isOnline,
            isVerified: isPro,
            unreadCount: unread,
            otherUserId: otherUser?.id
        )
    }
    
    /// Конвертирует DTO в ChatUser для экрана чата
    func toChatUser() -> ChatUser {
        let displayName = otherUser?.chattingNickname
            ?? otherUser?.name
            ?? name
            ?? "Неизвестный"
        
        let lastSeen = otherUser?.lastSeenAt
            .flatMap { DateFormatHelper.lastSeenText(from: $0) }
            ?? "Не в сети"
        
        let registeredAt = otherUser?.registeredAt
            .flatMap { DateFormatHelper.registrationDate(from: $0) }
            ?? ""
        
        return ChatUser(
            userId: otherUser?.id ?? 0,
            username: displayName,
            avatarUrl: otherUser?.avatarUrl ?? avatarUrl,
            lastSeenStatus: lastSeen,
            subscriptionStatus: "",
            registrationDate: registeredAt
        )
    }
}

// MARK: - MessageDTO Mapping

extension MessageDTO {
    
    func toChatMessage(currentUserId: Int?) -> ChatMessage {
        let isIncoming = senderId != currentUserId
        
        let date = createdAt
            .flatMap { DateFormatHelper.date(from: $0) }
            ?? Date()
        
        return ChatMessage(
            id: id,
            senderId: senderId,
            content: content ?? "",
            isIncoming: isIncoming,
            timestamp: date,
            messageType: messageType ?? "text"
        )
    }
}
