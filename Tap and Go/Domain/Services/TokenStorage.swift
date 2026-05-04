//
//  TokenStorage.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 21/04/2026.
//

import Foundation

protocol TokenStorage {

    func saveToken(_ token: String)

    func fetchToken() -> String?

    func clearToken()

}

final class DefaultTokenStorage: TokenStorage {

    private let key = "auth_token"

    func saveToken(_ token: String) {

        UserDefaults.standard.set(
                token,
                forKey: key
            )

    }

    func fetchToken()
    -> String? {

        UserDefaults
            .standard
            .string(
                forKey: key
            )

    }

    func clearToken() {

        UserDefaults
            .standard
            .removeObject(
                forKey: key
            )

    }

}
