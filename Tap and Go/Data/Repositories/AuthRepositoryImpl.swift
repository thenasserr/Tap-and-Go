//
//  AuthRepositoryImpl.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 19/04/2026.
//

import Foundation
import Combine

// MARK: - Auth Repository Implementation

final class AuthRepositoryImpl: AuthRepository {
    
    private let remote: AuthRemoteDataSource
    private let sessionManager: SessionManager
    
    // MARK: - Init
    
    init(
        remote: AuthRemoteDataSource,
        sessionManager: SessionManager
    ) {
        
        self.remote = remote
        self.sessionManager = sessionManager
    }
}

// MARK: - Login

extension AuthRepositoryImpl {
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        
        remote.login(email: email, password: password)
        .map { [weak self] response in
            
            let user =
            UserMapper.map(
                dto: response.user
            )
            
            self?.sessionManager.saveSession(
                user: user,
                token: response.token
            )
            return user
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}

// MARK: - Signup

extension AuthRepositoryImpl {
    
    func signup(name: String, email: String, password: String) -> AnyPublisher<User, Error> {
        
        remote.signup(name: name, email: email, password: password)
        .map { [weak self] response in
            
            let user =
            UserMapper.map(
                dto: response.user
            )
            
            self?.sessionManager.saveSession(
                user: user,
                token: response.token
            )
            
            return user
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}

// MARK: - Logout

extension AuthRepositoryImpl {
    
    func logout() {
        
        sessionManager.clearSession()
        print(sessionManager.getToken())
        print(sessionManager.getCurrentUser())
    }
}

// MARK: - Get Current User

extension AuthRepositoryImpl {
    
    func getCurrentUser() -> User? {
        
        sessionManager.getCurrentUser()
    }
}

// MARK: - Update Current User

extension AuthRepositoryImpl {
    
    func updateCurrentUser(_ user: User) -> AnyPublisher<User, Error> {
        
        remote.updateUser(user: user)
        .map { [weak self] dto in
            
            let updatedUser =
            UserMapper.map(
                dto: dto
            )
            
            if let token = self?.sessionManager.getToken() {
                
                self?.sessionManager.saveSession(
                    user: updatedUser,
                    token: token
                )
            }
            
            return updatedUser
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
}
