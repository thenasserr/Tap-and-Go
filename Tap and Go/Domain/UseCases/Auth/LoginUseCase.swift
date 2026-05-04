//
//  LoginUseCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

import Foundation
import Combine

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String, useBiometrics: Bool) -> AnyPublisher<User, Error>
}

final class LoginUseCase: LoginUseCaseProtocol {
    
    private let repository: AuthRepository
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let loginLogger: LoginLogger
    private let analyticsTracker: AnalyticsTracker
    private let biometricsHandler: BiometricsHandler
    
    init(repository: AuthRepository, emailValidator: EmailValidator, passwordValidator: PasswordValidator, loginLogger: LoginLogger, analyticsTracker: AnalyticsTracker, biometricsHandler: BiometricsHandler) {
        self.repository = repository
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.loginLogger = loginLogger
        self.analyticsTracker = analyticsTracker
        self.biometricsHandler = biometricsHandler
    }
    
    func execute(email: String, password: String, useBiometrics: Bool) -> AnyPublisher<User, Error> {
        do {
            try emailValidator.validate(email)
            
            try passwordValidator.validate(password)
        }
        catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        loginLogger.loginAttempt(email: email)
        
        analyticsTracker.track(event: "Login attempt")
        
        if useBiometrics {
            analyticsTracker.track(event: "biometric_login_attempt")
            return biometricsHandler
                .authenticate()
            
                .flatMap { success -> AnyPublisher<User, Error> in
                    guard success else {
                        self.analyticsTracker.track(event: "biometric_failed")
                        
                        return Fail(error: NSError(domain: "Biometrics", code: 0))
                        
                        .eraseToAnyPublisher()
                        
                    }
                    self.analyticsTracker.track(event: "Biometrics_Success")
                    return self.repository.login(email: email, password: password)
                    
                }
                .eraseToAnyPublisher()
        }
        
        return self.repository.login(email: email, password: password)
        
    }
}

