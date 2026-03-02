//
//  TokenManager.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - TokenManagerProtocol

protocol TokenManagerProtocol: AnyObject {
    
    var isAuthorized: Bool { get }
    var accessToken: String? { get }
    var sessionId: String? { get }
    var currentUserId: Int? { get }
    
    func saveTokens(response: TokenResponse)
    func saveSessionId(_ sessionId: String)
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void)
    func clearTokens()
}

// MARK: - TokenManager

final class TokenManager: TokenManagerProtocol {
    
    // MARK: - Properties
    
    var isAuthorized: Bool {
        keychain.get(forKey: KeychainService.Keys.accessToken) != nil
    }
    
    var accessToken: String? {
        keychain.get(forKey: KeychainService.Keys.accessToken)
    }
    
    var sessionId: String? {
        keychain.get(forKey: KeychainService.Keys.sessionId)
    }
    
    /// ID текущего пользователя, декодируется из JWT access token
    var currentUserId: Int? {
        guard let token = accessToken else { return nil }
        return Self.decodeUserId(from: token)
    }
    
    // MARK: - Private Properties
    
    private let keychain: KeychainServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    private var isRefreshing = false
    private var refreshCompletions: [(Result<String, Error>) -> Void] = []
    
    // MARK: - Initializers
    
    init(
        keychain: KeychainServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.keychain = keychain
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    func saveTokens(response: TokenResponse) {
        keychain.save(
            response.accessToken,
            forKey: KeychainService.Keys.accessToken
        )
        
        if let refreshToken = response.refreshToken {
            keychain.save(
                refreshToken,
                forKey: KeychainService.Keys.refreshToken
            )
        }
    }
    
    func saveSessionId(_ sessionId: String) {
        keychain.save(
            sessionId,
            forKey: KeychainService.Keys.sessionId
        )
    }
    
    func refreshToken(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        refreshCompletions.append(completion)
        
        guard !isRefreshing else { return }
        isRefreshing = true
        
        guard let refreshToken = keychain.get(
            forKey: KeychainService.Keys.refreshToken
        ) else {
            finishRefresh(with: .failure(NetworkError.tokenRefreshFailed))
            return
        }
        
        networkService.sendRequest(
            baseURL: .baseUrl,
            query: .refreshToken,
            httpMethodType: .post,
            token: nil,
            contentType: .formUrlEncoded,
            parameters: ["token": refreshToken],
            inQueryParameters: nil
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                guard let tokenResponse = try? JSONDecoder().decode(
                    TokenResponse.self, from: data
                ) else {
                    self.finishRefresh(
                        with: .failure(NetworkError.decodingError)
                    )
                    return
                }
                
                self.saveTokens(response: tokenResponse)
                self.finishRefresh(
                    with: .success(tokenResponse.accessToken)
                )
                
            case .failure(let error):
                self.finishRefresh(with: .failure(error))
            }
        }
    }
    
    func clearTokens() {
        keychain.deleteAll()
    }
    
    // MARK: - Private Methods
    
    private func finishRefresh(with result: Result<String, Error>) {
        isRefreshing = false
        
        let completions = refreshCompletions
        refreshCompletions.removeAll()
        
        completions.forEach { $0(result) }
    }
    
    /// Декодирует user_id из JWT (проверяет все части токена)
    private static func decodeUserId(from token: String) -> Int? {
        let parts = token.split(separator: ".")
        
        // Проверяем каждую часть токена — payload может быть
        // в parts[0] или parts[1] в зависимости от сервера
        for part in parts {
            var base64 = String(part)
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let remainder = base64.count % 4
            if remainder > 0 {
                base64 += String(repeating: "=", count: 4 - remainder)
            }
            
            guard let data = Data(base64Encoded: base64),
                  let json = try? JSONSerialization.jsonObject(
                    with: data
                  ) as? [String: Any]
            else { continue }
            
            // sub как Int (ваш случай: "sub": 318)
            if let sub = json["sub"] as? Int {
                return sub
            }
            // user_id как Int
            if let userId = json["user_id"] as? Int {
                return userId
            }
            // sub как String -> Int
            if let sub = json["sub"] as? String,
               let userId = Int(sub) {
                return userId
            }
        }
        
        return nil
    }
}
