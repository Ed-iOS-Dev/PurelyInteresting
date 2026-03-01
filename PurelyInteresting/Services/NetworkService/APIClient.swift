//
//  APIClient.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - APIClientProtocol

protocol APIClientProtocol: AnyObject {
    
    /// Выполняет авторизованный запрос с автоматическим refresh при 401
    func authorizedRequest(
        query: URLQueries,
        httpMethodType: HttpMethodType,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

// MARK: - APIClient

final class APIClient: APIClientProtocol {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    // MARK: - Initializers
    
    init(
        networkService: NetworkServiceProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.networkService = networkService
        self.tokenManager = tokenManager
    }
    
    // MARK: - Public Methods
    
    func authorizedRequest(
        query: URLQueries,
        httpMethodType: HttpMethodType,
        parameters: [String: Any]? = nil,
        inQueryParameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let token = tokenManager.accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        performRequest(
            query: query,
            httpMethodType: httpMethodType,
            token: token,
            parameters: parameters,
            inQueryParameters: inQueryParameters
        ) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                completion(result)
                
            case .failure(let error):
                guard case NetworkError.httpError(statusCode: 401) = error
                else {
                    completion(result)
                    return
                }
                
                self.retryAfterRefresh(
                    query: query,
                    httpMethodType: httpMethodType,
                    parameters: parameters,
                    inQueryParameters: inQueryParameters,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func performRequest(
        query: URLQueries,
        httpMethodType: HttpMethodType,
        token: String,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        networkService.sendRequest(
            baseURL: .baseUrl,
            query: query,
            httpMethodType: httpMethodType,
            token: token,
            contentType: .json,
            parameters: parameters,
            inQueryParameters: inQueryParameters,
            completion: completion
        )
    }
    
    private func retryAfterRefresh(
        query: URLQueries,
        httpMethodType: HttpMethodType,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        tokenManager.refreshToken { [weak self] refreshResult in
            guard let self else { return }
            
            switch refreshResult {
            case .success(let newToken):
                self.performRequest(
                    query: query,
                    httpMethodType: httpMethodType,
                    token: newToken,
                    parameters: parameters,
                    inQueryParameters: inQueryParameters,
                    completion: completion
                )
                
            case .failure:
                self.tokenManager.clearTokens()
                completion(.failure(NetworkError.unauthorized))
            }
        }
    }
}
