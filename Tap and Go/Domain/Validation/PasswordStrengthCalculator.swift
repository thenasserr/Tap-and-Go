//
//  PasswordStrengthCalculator.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation

protocol PasswordStrengthCalculator {
    
    func evaluate(password: String) -> PasswordStrength
    
}

struct DefaultPasswordStrengthCalculator: PasswordStrengthCalculator {
    
    func evaluate(password: String) -> PasswordStrength {
        
        var score = 0
        
        // Length
        
        if password.count >= 8 {
            score += 1
        }
        
        if password.count >= 12 {
            score += 1
        }
        
        // Uppercase
        
        if password.range(of: "[A-Z]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Numbers
        
        if password.range(of: "[0-9]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Symbols
        
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil {
            score += 1
        }
        
        return mapScore(score)
        
    }
}

private extension DefaultPasswordStrengthCalculator {
    
    func mapScore(_ score: Int) -> PasswordStrength {
        switch score {
            case 0...1:
                return .weak
            case 2...3:
                return .medium
            case 4:
                return .strong
            default:
                return .veryStrong
        }
    }
}
