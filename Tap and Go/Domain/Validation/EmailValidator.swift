//
//  EmailValidator.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol EmailValidator {
    
    func validate(_ email: String) throws
}

struct DefaultEmailValidator: EmailValidator {
    
    func validate(_ email: String) throws {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        guard predicate.evaluate(with: email) else {
            throw AuthValidationError.invalidEmail
        }
    }
}


