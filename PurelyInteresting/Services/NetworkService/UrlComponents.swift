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
    
    /// Получение анонимной сессии
    case newSession = "/api/v1/auth/sessions/new"
    
    /// Обновление JWT токена (POST, form-urlencoded)
    case refreshToken = "/api/v1/auth/jwt/refresh/new"
    
    /// Получение профиля текущего пользователя
    case myProfile = "/api/v1/my"
    
    /// WebSocket сессия авторизации (добавить /{session_id})
    case webSocketSession = "/api/v1/ws/ws/session/"
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
