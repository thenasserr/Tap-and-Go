//
//  DefaultVerificationViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import Foundation
import Combine

// MARK: - Default Verification ViewModel

final class DefaultVerificationViewModel: VerificationViewModel {
    
    private let email: String
    private weak var coordinator: AuthCoordinator?
    
    @Published private var otpValue: String = ""
    @Published private var isVerifyEnabledValue: Bool = false
    @Published private var errorValue: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let otpLength = 6
    
    // MARK: - Init
    
    init(
        email: String,
        coordinator: AuthCoordinator
    ) {
        self.email = email
        self.coordinator = coordinator
        bindValidation()
    }
    
    // MARK: - Deinit
    
    deinit {
        print("✅ DefaultVerificationViewModel deinit")
    }
}

// MARK: - Outputs

extension DefaultVerificationViewModel {
    
    var emailText: String {
        email
    }
    
    var otp: Published<String>.Publisher {
        $otpValue
    }
    
    var isVerifyEnabled: Published<Bool>.Publisher {
        $isVerifyEnabledValue
    }
    
    var error: Published<String?>.Publisher {
        $errorValue
    }
}

// MARK: - Input

extension DefaultVerificationViewModel {
    
    func updateOTP(_ value: String) {
        otpValue = String(value.filter { $0.isNumber }.prefix(otpLength))
    }
}

// MARK: - Validation

private extension DefaultVerificationViewModel {
    
    func bindValidation() {
        $otpValue
            .map { [weak self] otp in
                otp.count == self?.otpLength
            }
            .assign(to: &$isVerifyEnabledValue)
    }
}

// MARK: - Verify

extension DefaultVerificationViewModel {
    
    func verify() {
        guard otpValue.count == otpLength else {
            errorValue = "Please enter the verification code."
            return
        }
        
        // Placeholder:
        // Later Firebase code verification/reset password flow.
        
        errorValue = "Verification placeholder. Firebase reset flow will be added later."
    }
}
