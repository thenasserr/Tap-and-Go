//
//  AuthRepository.swift.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

protocol UserRepository {
    func fetchCurrentUser() -> AnyPublisher<User, Error>
    
    func updateUser(user: User) -> AnyPublisher<User, Error>
}
