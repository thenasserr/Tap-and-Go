//
//  UpdateUserCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 26/04/2026.
//

import Foundation
import Combine

final class UpdateUserUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(user: User) -> AnyPublisher<User, Error> {
        repository.updateCurrentUser(user)
    }
}
