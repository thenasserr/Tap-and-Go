//
//  PasswordStrength.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import UIKit

enum PasswordStrength {

    case weak
    case medium
    case strong
    case veryStrong

}

extension PasswordStrength {

    var title: String {

        switch self {

        case .weak:
            return "Weak"

        case .medium:
            return "Medium"

        case .strong:
            return "Strong"

        case .veryStrong:
            return "Very Strong"

        }

    }

}

extension PasswordStrength {

    var color: UIColor {

        switch self {

        case .weak:
            return .systemRed

        case .medium:
            return .systemOrange

        case .strong:
            return .systemGreen

        case .veryStrong:
            return .systemTeal

        }

    }

}
