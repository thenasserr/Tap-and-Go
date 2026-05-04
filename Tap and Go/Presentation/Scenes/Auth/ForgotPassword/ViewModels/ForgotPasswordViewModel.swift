//
//  ForgotPasswordViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import Foundation
import Combine

// MARK: - Forgot Password ViewModel

protocol ForgotPasswordViewModel {
    
    var email: Published<String>.Publisher { get }
    var isSendEnabled: Published<Bool>.Publisher { get }
    var isLoading: Published<Bool>.Publisher { get }
    var error: Published<String?>.Publisher { get }
    var success: Published<String?>.Publisher { get }
    
    func updateEmail(_ value: String)
    func sendCode()
}
