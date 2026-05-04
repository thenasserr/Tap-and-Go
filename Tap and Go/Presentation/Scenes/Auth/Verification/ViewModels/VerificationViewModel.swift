//
//  VerificationViewModel.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 29/04/2026.
//

import Foundation
import Combine

// MARK: - Verification ViewModel

protocol VerificationViewModel {
    
    var emailText: String { get }
    var otp: Published<String>.Publisher { get }
    var isVerifyEnabled: Published<Bool>.Publisher { get }
    var error: Published<String?>.Publisher { get }
    
    func updateOTP(_ value: String)
    func verify()
}
