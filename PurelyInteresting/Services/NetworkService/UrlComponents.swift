//
//  URLComponents.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - BaseUrlType

public enum BaseUrlType: String {
    
    case baseUrl = "https://interesnoitochka.ru"
    case websocket = "wss://interesnoitochka.ru"
}

// MARK: - URLQueries

public enum URLQueries: String {
    
    // MARK: - Auth
    
    /// GET — Получение анонимной сессии
    case newSession = "/api/v1/auth/sessions/new"
    
    /// POST — Обновление JWT токена (form-urlencoded)
    case refreshToken = "/api/v1/auth/jwt/refresh/new"
    
    /// WebSocket сессия авторизации (+ /{session_id})
    case webSocketSession = "/api/v1/ws/ws/session/"
    
    // MARK: - Users
    
    /// GET — Профиль текущего пользователя
    case myProfile = "/api/v1/users/my"
    
    // MARK: - Chats
    
    /// GET — Список чатов пользователя
    case chats = "/api/v1/chats"
    
    /// GET — Детали чата (+ /{chat_id})
    /// GET — Сообщения чата (+ /{chat_id}/messages)
    case chatDetail = "/api/v1/chats/"
    
    /// POST — Отправка сообщения
    case sendMessage = "/api/v1/chats/messages"
    
    /// GET — Токен подписки на все чаты
    case subscribeAll = "/api/v1/chats/subscribe/all"
}

// MARK: - HttpMethodType

public enum HttpMethodType: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - ContentType

public enum ContentType: String {
    
    case json = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

// MARK: - NetworkError

public enum NetworkError: Error, Equatable {
    
    case invalidURL
    case noHTTPURLResponse
    case noData
    case httpError(statusCode: Int)
    case decodingError
    case unauthorized
    case tokenRefreshFailed
    case webSocketError
}
