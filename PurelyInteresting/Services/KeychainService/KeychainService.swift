//
//  KeychainService.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import Foundation
import Security

// MARK: - KeychainServiceProtocol

protocol KeychainServiceProtocol: AnyObject {
    
    func save(_ value: String, forKey key: String)
    func get(forKey key: String) -> String?
    func delete(forKey key: String)
    func deleteAll()
}

// MARK: - KeychainService

final class KeychainService: KeychainServiceProtocol {
    
    // MARK: - Constants
    
    enum Keys {
        
        static let accessToken = "com.purelyinteresting.accessToken"
        static let refreshToken = "com.purelyinteresting.refreshToken"
        static let sessionId = "com.purelyinteresting.sessionId"
    }
    
    // MARK: - Public Methods
    
    func save(_ value: String, forKey key: String) {
        delete(forKey: key)
        
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func deleteAll() {
        delete(forKey: Keys.accessToken)
        delete(forKey: Keys.refreshToken)
        delete(forKey: Keys.sessionId)
    }
}
