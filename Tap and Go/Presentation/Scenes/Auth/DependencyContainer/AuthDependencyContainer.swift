//
//  AuthDependencyContainer.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import UIKit

final class AuthDependencyContainer {
    
    private let apiClient: APIClient
    private let coreDataStack: CoreDataStack
    private let tokenStorage: TokenStorage
    private let sessionManager: SessionManager
    private let analytics: AnalyticsTracker
    private let selectedAddressRepository: SelectedAddressRepository
    
    // MARK: - Init
    
    init(
        apiClient: APIClient,
        coreDataStack: CoreDataStack,
        tokenStorage: TokenStorage,
        sessionManager: SessionManager,
        analytics: AnalyticsTracker,
        selectedAddressRepository: SelectedAddressRepository
    ) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
        self.tokenStorage = tokenStorage
        self.sessionManager = sessionManager
        self.analytics = analytics
        self.selectedAddressRepository = selectedAddressRepository
    }
}


// MARK: - Validators

private extension AuthDependencyContainer {
    func makeEmailValidator() -> EmailValidator {
        DefaultEmailValidator()
    }
    
    func makePasswordValidator() -> PasswordValidator {
        DefaultPasswordValidator()
    }
    
    func makeNameValidator() -> NameValidator {
        DefaultNameValidator()
    }
    
    func makePasswordStrengthCalculator() -> PasswordStrengthCalculator {
        DefaultPasswordStrengthCalculator()
    }
}

// MARK: - Services

private extension AuthDependencyContainer {
    func makeLoginLogger() -> LoginLogger {
        DefaultLoginLogger()
    }
    
    func makeSignupLogger() -> SignupLogger {
        DefaultSignupLogger()
    }
    
    func makeLogoutLogger() -> LogoutLogger {
        DefaultLogoutLogger()
    }
    
    func makeBiometricsHandler() -> BiometricsHandler {
        DefaultBiometricsHandler()
    }
}

// MARK: - DataSource

private extension AuthDependencyContainer {
    func makeAuthRemoteDataSource() -> AuthRemoteDataSource {
        AuthRemoteDataSource(apiClient: apiClient)
    }
}

private extension AuthDependencyContainer {
    func makeAuthLocalDataSource() -> AuthLocalDataSource {
        AuthLocalDataSource(tokenStorage: tokenStorage)
    }
}

// MARK: - Repository

private extension AuthDependencyContainer {
    func makeAuthRepository() -> AuthRepository {
        FirebaseAuthRepositoryImpl(
            firebaseAuthService: makeFirebaseAuthService(),
            remote: makeAuthRemoteDataSource(),
            sessionManager: sessionManager)
    }
}

// MARK: - Cache

private extension AuthDependencyContainer {
    func makeCacheCleaner() -> CacheCleaner {
        DefaultCacheCleaner(
            coreDataStack: coreDataStack,
            selectedAddressRepository: selectedAddressRepository
        )
    }
}

// MARK: - UseCase

extension AuthDependencyContainer {
    func makeLoginUseCase() -> LoginUseCase {
        LoginUseCase(
            repository:
                makeAuthRepository(),
            emailValidator:
                makeEmailValidator(),
            passwordValidator:
                makePasswordValidator(),
            loginLogger:
                makeLoginLogger(),
            analyticsTracker:
                analytics,
            biometricsHandler:
                makeBiometricsHandler())
    }
}

extension AuthDependencyContainer {
    
    func makeSignupUseCase() -> SignupUseCase {
        SignupUseCase(
            repository:
                makeAuthRepository(),
            nameValidator:
                makeNameValidator(),
            emailValidator:
                makeEmailValidator(),
            passwordValidator:
                makePasswordValidator(),
            logger:
                makeSignupLogger(),
            analytics:
                analytics
        )
    }
}

extension AuthDependencyContainer {
    
    func makeLogoutUseCase() -> LogoutUseCase {
        LogoutUseCase(
            sessionManager: sessionManager,
            logger: makeLogoutLogger(),
            analytics: analytics,
            cacheCleaner: makeCacheCleaner()
        )
    }
}

extension AuthDependencyContainer {
    func makeGetCurrentUserUseCase() -> GetCurrentUserUseCase {
        GetCurrentUserUseCase(repository: makeAuthRepository(), sessionValidator: DefaultSessionValidator(tokenStorage: tokenStorage), analytics: analytics)
    }
}

extension AuthDependencyContainer {
    func makeForgotPasswordUseCase() -> ForgotPasswordUseCase {
        ForgotPasswordUseCase(
            firebaseAuthService: makeFirebaseAuthService())
    }
}

// MARK: - ViewModels

extension AuthDependencyContainer {
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: makeLoginUseCase())
    }
}

extension AuthDependencyContainer {
    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(signupUseCase: makeSignupUseCase(), passwordStrengthCalculator: makePasswordStrengthCalculator())
    }
}

extension AuthDependencyContainer {
    func makeForgotPasswordViewModel(coordinator: AuthCoordinator) -> ForgotPasswordViewModel {
        DefaultForgotPasswordViewModel(
            forgotPasswordUseCase: makeForgotPasswordUseCase(),
            coordinator: coordinator)
    }
}

extension AuthDependencyContainer {
    func makeVerificationViewModel(email: String, coordinator: AuthCoordinator) -> VerificationViewModel {
        DefaultVerificationViewModel(email: email, coordinator: coordinator)
    }
}

// MARK: - Auth Coordinator

extension AuthDependencyContainer {
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        DefaultAuthCoordinator(navigationController: navigationController, dependencyContainer: self)
    }
}

