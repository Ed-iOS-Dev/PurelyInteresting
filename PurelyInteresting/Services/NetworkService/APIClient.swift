//
//  APIClient.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - APIClientProtocol

protocol APIClientProtocol: AnyObject {
    
    /// Авторизованный запрос по URLQueries
    func authorizedRequest(
        query: URLQueries,
        httpMethodType: HttpMethodType,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    /// Авторизованный запрос по произвольному path
    func authorizedRequest(
        path: String,
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
        authorizedRequest(
            path: query.rawValue,
            httpMethodType: httpMethodType,
            parameters: parameters,
            inQueryParameters: inQueryParameters,
            completion: completion
        )
    }
    
    func authorizedRequest(
        path: String,
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
            path: path,
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
                    path: path,
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
        path: String,
        httpMethodType: HttpMethodType,
        token: String,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        networkService.sendRequest(
            baseURL: .baseUrl,
            path: path,
            httpMethodType: httpMethodType,
            token: token,
            contentType: .json,
            parameters: parameters,
            inQueryParameters: inQueryParameters,
            completion: completion
        )
    }
    
    private func retryAfterRefresh(
        path: String,
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
                    path: path,
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
