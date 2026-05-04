//
//  BiometricsHandler.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation
import Combine
import LocalAuthentication

protocol BiometricsHandler {
    func authenticate() -> AnyPublisher<Bool, Error>
}

final class DefaultBiometricsHandler: BiometricsHandler {
    
    func authenticate() -> AnyPublisher<Bool, Error> {
        
        Future { promise in
            
            let context = LAContext()
            
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                    
            else {
                
                promise(.success(false))
                return
                
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:"Login using Face ID") { success, err in
                
                if success {
                    
                    promise(.success(true))
                    
                }
                
                else {
                    
                    promise(.failure(err ?? NSError()))
                    
                }
                
            }
            
        }
        .eraseToAnyPublisher()
        
    }
    
}

enum BiometricsError: Error {
    case authenticationFailed
    case other
}
