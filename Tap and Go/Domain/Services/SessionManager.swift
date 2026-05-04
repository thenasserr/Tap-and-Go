//
//  SessionManager.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

// MARK: - Session Manager

protocol SessionManager {
    
    func saveSession(user: User, token: String)
    func getCurrentUser() -> User?
    func getToken() -> String?
    func clearSession()
}

// MARK: - Default Session Manager

final class DefaultSessionManager: SessionManager {
    
    private let tokenStorage: TokenStorage
    private let userStorage: UserStorage
    
    // MARK: - Init
    
    init(
        tokenStorage: TokenStorage,
        userStorage: UserStorage
    ) {
        
        self.tokenStorage = tokenStorage
        self.userStorage = userStorage
    }
    
    func saveSession(
        user: User,
        token: String
    ) {
        
        tokenStorage.saveToken(token)
        userStorage.saveUser(user)
    }
    
    func getCurrentUser() -> User? {
        
        userStorage.getUser()
    }
    
    func getToken() -> String? {
        
        tokenStorage.fetchToken()
    }
    
    func clearSession() {
        
        tokenStorage.clearToken()
        userStorage.clearUser()
    }
}
