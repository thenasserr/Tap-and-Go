//
//  SignupViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation
import Combine

// MARK: - Signup ViewModel

final class SignupViewModel {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isSignupEnabled: Bool = false
    @Published private(set) var passwordStrength: PasswordStrength = .weak
    
    let signupSuccess = PassthroughSubject<Void, Never>()
    let loginTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let signupUseCase: SignupUseCaseProtocol
    private let passwordStrengthCalculator: PasswordStrengthCalculator
    
    // MARK: - Init
    
    init(
        signupUseCase: SignupUseCaseProtocol,
        passwordStrengthCalculator: PasswordStrengthCalculator
    ) {
        
        self.signupUseCase = signupUseCase
        self.passwordStrengthCalculator = passwordStrengthCalculator
        
        bindValidation()
        bindPasswordStrength()
    }
}

// MARK: - Validation

private extension SignupViewModel {
    
    func bindValidation() {
        
        Publishers.CombineLatest4(
            $name,
            $email,
            $password,
            $confirmPassword
        )
        .debounce(
            for: .milliseconds(300),
            scheduler: DispatchQueue.main
        )
        .map { name, email, password, confirmPassword in
            
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            email.contains("@") &&
            email.contains(".") &&
            password.count >= 8 &&
            password == confirmPassword
        }
        .assign(to: &$isSignupEnabled)
    }
    
    func bindPasswordStrength() {
        
        $password
            .debounce(
                for: .milliseconds(300),
                scheduler: DispatchQueue.main
            )
            .map { [weak self] password in
                
                guard let self else { return .weak }
                
                return self.passwordStrengthCalculator.evaluate(
                    password: password
                )
            }
            .assign(to: &$passwordStrength)
    }
}

// MARK: - Signup

extension SignupViewModel {
    
    func signup() {
        
        guard password == confirmPassword else {
            
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        signupUseCase
            .execute(
                name: name,
                email: email,
                password: password
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        
                        self.errorMessage = ErrorMessageMapper.message(from: error)
                    }
                },
                receiveValue: { [weak self] _ in
                    
                    self?.clearFields()
                    self?.signupSuccess.send()
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

private extension SignupViewModel {
    
    func clearFields() {
        
        name = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
