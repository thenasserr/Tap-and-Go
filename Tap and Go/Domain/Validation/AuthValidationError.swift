//
//  AuthValidationError.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

enum AuthValidationError: LocalizedError {
    
    case invalidEmail
    case weakPassword
    case invalidName
    case missingUppercase
    case missingNumber
    
    var errorDescription: String? {
        switch self {
                
            case .invalidEmail:
                return "invalid email format"
            case .weakPassword:
                return "password must be at least 6 characters"
            case .invalidName:
                return "Name must be at least 2 characters"
            case .missingUppercase:
                return "Password must contain Uppercase"
            case .missingNumber:
                return "Password must contain number"
        }
    }
}
