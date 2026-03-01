//
//  NetworkService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol: AnyObject {
    
    func sendRequest(
        baseURL: BaseUrlType,
        query: URLQueries,
        httpMethodType: HttpMethodType,
        token: String?,
        contentType: ContentType,
        parameters: [String: Any]?,
        inQueryParameters: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Public Methods
    
    func sendRequest(
        baseURL: BaseUrlType = .baseUrl,
        query: URLQueries,
        httpMethodType: HttpMethodType,
        token: String? = nil,
        contentType: ContentType = .json,
        parameters: [String: Any]? = nil,
        inQueryParameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let url = buildURL(
            baseURL: baseURL,
            query: query,
            inQueryParameters: inQueryParameters
        )
        
        guard let url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodType.rawValue
        request.addValue(
            contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        if let token {
            request.addValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        if let parameters {
            request.httpBody = encodeBody(
                parameters: parameters,
                contentType: contentType
            )
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noHTTPURLResponse))
                }
                return
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    completion(
                        .failure(
                            NetworkError.httpError(
                                statusCode: httpResponse.statusCode
                            )
                        )
                    )
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
    
    // MARK: - Private Methods
    
    private func buildURL(
        baseURL: BaseUrlType,
        query: URLQueries,
        inQueryParameters: [String: Any]?
    ) -> URL? {
        var urlString = baseURL.rawValue + query.rawValue
        
        if let inQueryParameters, !inQueryParameters.isEmpty {
            let queryString = inQueryParameters.enumerated()
                .map { index, parameter in
                    let prefix = index == 0 ? "?" : "&"
                    return "\(prefix)\(parameter.key)=\(parameter.value)"
                }
                .joined()
            
            urlString += queryString
        }
        
        return URL(string: urlString)
    }
    
    private func encodeBody(
        parameters: [String: Any],
        contentType: ContentType
    ) -> Data? {
        switch contentType {
        case .json:
            return try? JSONSerialization.data(
                withJSONObject: parameters
            )
            
        case .formUrlEncoded:
            let bodyString = parameters
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            
            return bodyString.data(using: .utf8)
        }
    }
}
