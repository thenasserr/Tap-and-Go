//
//  PasswordValidator.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import UIKit

protocol PasswordValidator {
    
    func validate(_ password: String) throws
}

struct DefaultPasswordValidator: PasswordValidator {
    
    func validate(_ password: String) throws {
        
        guard password.count >= 6 else {
            throw AuthValidationError.weakPassword
        }
        
        guard password.range(of: "[A-Z]", options: .regularExpression) != nil else {
            
            throw AuthValidationError.missingUppercase
        }
        
        guard password.range(of: "[0-9]", options: .regularExpression) != nil else {
            
            throw AuthValidationError.missingNumber
        }
    }
}
