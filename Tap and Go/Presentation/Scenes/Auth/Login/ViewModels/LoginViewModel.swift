//
//  LoginViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation
import Combine

final class LoginViewModel {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var useBiometrics: Bool = false
    
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isLoginEnabled: Bool = false
    
    let loginSuccess = PassthroughSubject<Void, Never>()
    let signupTapped = PassthroughSubject<Void, Never>()
    let forgotPasswordTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        bindValidation()
    }
    
}

private extension LoginViewModel {
    
    func bindValidation() {
        
        Publishers
            .CombineLatest(
                $email
                    .debounce(
                        for: .milliseconds(300),
                        scheduler: DispatchQueue.main
                    ), $password)
            
            .map {
                !$0.0.isEmpty &&
                !$0.1.isEmpty
            }
            
            .assign(to: &$isLoginEnabled)
        
    }
    
}

extension LoginViewModel {
    func login() {
        
        isLoading = true
        errorMessage = nil
        
        loginUseCase.execute(email: email, password: password, useBiometrics: useBiometrics)
        
            .receive(on: DispatchQueue.main)
        
            .sink { [weak self] completion in
                
                guard let self else {return}
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    
                    self.errorMessage = ErrorMessageMapper.message(from: error)
                    
                }
            } receiveValue: { [weak self] _ in
                
                guard let self else { return }
                
                self.loginSuccess.send()
            }
            .store(in: &cancellables)

    }
}

extension LoginViewModel {
    
    func loginWithBiometrics() {
        useBiometrics = true
        login()
    }
}
