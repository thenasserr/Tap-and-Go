//
//  AuthLocalDataSource.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation
import CoreData

final class AuthLocalDataSource {
    
    private let tokenStorage: TokenStorage
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let token = "auth_token"
        static let user = "auth_user"
    }
    
    init(tokenStorage: TokenStorage) {
        
        self.tokenStorage = tokenStorage
    }
}

extension AuthLocalDataSource {
    
    func saveToken(_ token: String) {
        defaults.set(token, forKey: Keys.token)
    }
}

extension AuthLocalDataSource {
    
    func getToken() -> String? {
        defaults.string(forKey: Keys.token)
    }
}

extension AuthLocalDataSource {
    
    func saveUser(_ user: User) {
        
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(user) {
            defaults.set(data, forKey: Keys.user)
        }
    }
}

extension AuthLocalDataSource {
    
    func getUser() -> User? {
        
        guard let data = defaults.data(forKey: Keys.user) else { return nil }
        
        let user = try? JSONDecoder().decode(User.self, from: data)
        
        return user
    }
}

extension AuthLocalDataSource {
    
    func clearUser() {
        
        defaults.removeObject(forKey: Keys.user)
        
        defaults.removeObject(forKey: Keys.token)
    }
}
