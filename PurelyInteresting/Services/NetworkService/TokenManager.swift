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
}
