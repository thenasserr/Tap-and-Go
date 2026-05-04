//
//  DefaultForgotPasswordViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import Foundation
import Combine

// MARK: - Default Forgot Password ViewModel

final class DefaultForgotPasswordViewModel: ForgotPasswordViewModel {
    
    private weak var coordinator: AuthCoordinator?
    private let forgotPasswordUseCase: ForgotPasswordUseCaseProtocol
    
    @Published private var emailValue: String = ""
    @Published private var isSendEnabledValue: Bool = false
    @Published private var isLoadingValue: Bool = false
    @Published private var errorValue: String?
    @Published private var successValue: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        forgotPasswordUseCase: ForgotPasswordUseCaseProtocol,
        coordinator: AuthCoordinator?
    ) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
        self.coordinator = coordinator
        bindValidation()
    }
    
    deinit {
        print("✅ DefaultForgotPasswordViewModel deinit")
    }
}

// MARK: - Outputs

extension DefaultForgotPasswordViewModel {
    
    var email: Published<String>.Publisher { $emailValue }
    var isSendEnabled: Published<Bool>.Publisher { $isSendEnabledValue }
    var isLoading: Published<Bool>.Publisher { $isLoadingValue }
    var error: Published<String?>.Publisher { $errorValue }
    var success: Published<String?>.Publisher { $successValue }
}

// MARK: - Input

extension DefaultForgotPasswordViewModel {
    
    func updateEmail(_ value: String) {
        emailValue = value
    }
}

// MARK: - Validation

private extension DefaultForgotPasswordViewModel {
    
    func bindValidation() {
        $emailValue
            .map { email in
                let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                return cleanEmail.contains("@") && cleanEmail.contains(".")
            }
            .assign(to: &$isSendEnabledValue)
    }
}

// MARK: - Send Reset Email

extension DefaultForgotPasswordViewModel {
    
    func sendCode() {
        let cleanEmail = emailValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isSendEnabledValue else {
            errorValue = "Please enter a valid email address."
            return
        }
        
        isLoadingValue = true
        errorValue = nil
        successValue = nil
        
        forgotPasswordUseCase
            .execute(email: cleanEmail)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingValue = false
                    
                    if case .failure(let error) = completion {
                        self?.errorValue = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] in
                    self?.successValue = "Password reset email sent. Please check your inbox."
                }
            )
            .store(in: &cancellables)
    }
}



