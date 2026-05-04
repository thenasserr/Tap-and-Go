//
//  AuthRepository.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

protocol AuthRepository {
    func login(email: String, password: String) -> AnyPublisher<User, Error>
    
    func signup(name: String, email: String, password: String) -> AnyPublisher<User, Error>
    
    func logout()
    
    func getCurrentUser() -> User?
    
    func updateCurrentUser(_ user: User) -> AnyPublisher<User, Error>
}
