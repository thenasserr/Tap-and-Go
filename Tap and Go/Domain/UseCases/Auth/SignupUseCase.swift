//
//  SignupUseCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

protocol SignupUseCaseProtocol {
    func execute(name: String, email: String, password: String) -> AnyPublisher<User, Error>
}

final class SignupUseCase: SignupUseCaseProtocol {

    private let repository: AuthRepository
    private let nameValidator: NameValidator
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let logger: SignupLogger
    private let analytics: AnalyticsTracker

    init(
        repository: AuthRepository,
        nameValidator: NameValidator,
        emailValidator: EmailValidator,
        passwordValidator: PasswordValidator,
        logger: SignupLogger,
        analytics: AnalyticsTracker
    ) {

        self.repository = repository
        self.nameValidator = nameValidator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.logger = logger
        self.analytics = analytics

    }
}

extension SignupUseCase {

    func execute(name: String, email: String, password: String) -> AnyPublisher<User, Error> {

        do {

            try nameValidator.validate(name)

            try emailValidator.validate(email)

            try passwordValidator.validate(password)

        }

        catch {

            return Fail(error: error).eraseToAnyPublisher()

        }

        logger.logAttempt(email: email)

        analytics.track(event: "signup_attempt")

        return repository.signup(name: name, email: email, password: password)
            .handleEvents(
                receiveOutput: { _ in

                    self.analytics.track(event: "signup_success")

                },

                receiveCompletion: {
                    
                    completion in
                    
                    if case .failure = completion {
                        
                        self.analytics.track(event: "signup_failed")
                        
                    }
                    })
        
            .eraseToAnyPublisher()

    }

}
