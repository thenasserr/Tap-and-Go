//
//  NameValidator.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol NameValidator {
    func validate(_ name: String) throws
}

struct DefaultNameValidator: NameValidator {

    func validate(_ name: String) throws {

        let trimmed = name.trimmingCharacters(in: .whitespaces)

        guard trimmed.count >= 2
        else {

            throw AuthValidationError.invalidName

        }
    }
}
