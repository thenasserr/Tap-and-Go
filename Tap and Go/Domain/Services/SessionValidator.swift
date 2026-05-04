//
//  SessionValidator.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation

protocol SessionValidator {

    func hasValidSession() -> Bool

}

final class DefaultSessionValidator: SessionValidator {

    private let tokenStorage: TokenStorage

    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }

    func hasValidSession() -> Bool {
        return tokenStorage.fetchToken() != nil
    }
}
