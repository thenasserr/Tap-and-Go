//
//  SignupLogger.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol SignupLogger {

    func logAttempt(email: String)

}

final class DefaultSignupLogger: SignupLogger {

    func logAttempt(email: String) {

        print("Signup attempt:",email)

    }
}
