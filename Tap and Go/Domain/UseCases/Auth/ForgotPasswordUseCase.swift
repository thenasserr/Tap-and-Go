//
//  ForgotPasswordUseCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import Combine

protocol ForgotPasswordUseCaseProtocol {
    func execute(email: String) -> AnyPublisher<Void, Error>
}

// MARK: - Forgot Password Use Case

final class ForgotPasswordUseCase: ForgotPasswordUseCaseProtocol {
    
    private let firebaseAuthService: FirebaseAuthService
    
    // MARK: - Init
    
    init(firebaseAuthService: FirebaseAuthService) {
        self.firebaseAuthService = firebaseAuthService
    }
}

// MARK: - Execute

extension ForgotPasswordUseCase {
    
    func execute(email: String) -> AnyPublisher<Void, Error> {
        firebaseAuthService.sendPasswordReset(email: email)
    }
}
