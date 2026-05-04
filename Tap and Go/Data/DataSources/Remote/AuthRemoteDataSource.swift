//
//  AuthRemoteDataSource.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 18/04/2026.
//

import Foundation
import Combine

final class AuthRemoteDataSource {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

extension AuthRemoteDataSource {
    func login(email: String, password: String) -> AnyPublisher<AuthResponseDTO, NetworkError> {
        let endPoint = AuthEndpoint.login(email: email, password: password)
        return apiClient.request(endpoint: endPoint, responseType: AuthResponseDTO.self)
    }
}


extension AuthRemoteDataSource {
    
    func signup(name: String, email: String, password: String) -> AnyPublisher<AuthResponseDTO, NetworkError> {
        let endPoint = AuthEndpoint.signup(name: name, email: email, password: password)
        return apiClient.request(endpoint: endPoint, responseType: AuthResponseDTO.self)
    }
}

// MARK: - Update User

extension AuthRemoteDataSource {
    func updateUser(user: User) -> AnyPublisher<UserDTO, NetworkError> {
        let endpoint = AuthEndpoint.updateUser(user: user)
        return apiClient.request(endpoint: endpoint, responseType: UserDTO.self)
    }
}

// MARK: - Firebase Auth

extension AuthRemoteDataSource {
    func firebaseAuth(request: FirebaseAuthRequest) -> AnyPublisher<AuthResponseDTO, NetworkError> {
        let endpoint = AuthEndpoint.firebaseAuth(request)
        return apiClient.request(endpoint: endpoint, responseType: AuthResponseDTO.self)
    }
}
