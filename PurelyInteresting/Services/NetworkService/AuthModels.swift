//
//  AuthModels.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - SessionResponse

/// Ответ сервера на GET /api/v1/auth/sessions/new
struct SessionResponse: Codable {
    
    let id: String
    let lifetimeMinutes: Int
    let createdAt: String
    let expiresAt: String
    let refreshToken: String?
    let auth: Bool
    let tgId: Int?
    let userHashId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case lifetimeMinutes = "lifetime_minutes"
        case createdAt = "created_at"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case auth
        case tgId = "tg_id"
        case userHashId = "user_hash_id"
    }
}

// MARK: - TokenResponse

/// Ответ при получении / обновлении JWT токенов
struct TokenResponse: Codable {
    
    let accessToken: String
    let refreshToken: String?
    let tokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}
