//
//  FirebaseAuthRepositoryImpl.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import Combine

// MARK: - Firebase Auth Repository

final class FirebaseAuthRepositoryImpl: AuthRepository {
    
    private let firebaseAuthService: FirebaseAuthService
    private let remote: AuthRemoteDataSource
    private let sessionManager: SessionManager
    
    // MARK: - Init
    
    init(
        firebaseAuthService: FirebaseAuthService,
        remote: AuthRemoteDataSource,
        sessionManager: SessionManager
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.remote = remote
        self.sessionManager = sessionManager
    }
}

// MARK: - Login

extension FirebaseAuthRepositoryImpl {
    
    func login(
        email: String,
        password: String
    ) -> AnyPublisher<User, Error> {
        
        firebaseAuthService
            .login(email: email, password: password)
            .flatMap { [weak self] firebaseUser -> AnyPublisher<AuthResponseDTO, Error> in
                
                guard let self else {
                    return Fail(error: NetworkError.unknown("Repository released") as Error)
                        .eraseToAnyPublisher()
                }
                
                let request = FirebaseAuthRequest(
                    firebaseUID: firebaseUser.uid,
                    name: nil,
                    email: firebaseUser.email ?? email
                )
                
                return self.remote.firebaseAuth(request: request)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .map { [weak self] response in
                let user = UserMapper.map(dto: response.user)
                
                self?.sessionManager.saveSession(
                    user: user,
                    token: response.token
                )
                
                return user
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Signup

extension FirebaseAuthRepositoryImpl {
    
    func signup(
        name: String,
        email: String,
        password: String
    ) -> AnyPublisher<User, Error> {
        
        firebaseAuthService
            .signup(email: email, password: password)
            .flatMap { [weak self] firebaseUser -> AnyPublisher<AuthResponseDTO, Error> in
                
                guard let self else {
                    return Fail(error: NetworkError.unknown("Repository released") as Error)
                        .eraseToAnyPublisher()
                }
                
                let request = FirebaseAuthRequest(
                    firebaseUID: firebaseUser.uid,
                    name: name,
                    email: firebaseUser.email ?? email
                )
                
                return self.remote.firebaseAuth(request: request)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .map { [weak self] response in
                let user = UserMapper.map(dto: response.user)
                
                self?.sessionManager.saveSession(
                    user: user,
                    token: response.token
                )
                
                return user
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Session

extension FirebaseAuthRepositoryImpl {
    
    func logout() {
        try? firebaseAuthService.logout()
        sessionManager.clearSession()
    }
    
    func getCurrentUser() -> User? {
        sessionManager.getCurrentUser()
    }
}

// MARK: - Update Current User

extension FirebaseAuthRepositoryImpl {
    
    func updateCurrentUser(
        _ user: User
    ) -> AnyPublisher<User, Error> {
        
        remote.updateUser(user: user)
            .map {
                UserMapper.map(dto: $0)
            }
            .handleEvents(receiveOutput: { [weak self] updatedUser in
                self?.sessionManager.saveSession(
                    user: updatedUser,
                    token: self?.sessionManager.getToken() ?? ""
                )
            })
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
