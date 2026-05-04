//
//  APIClient.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

final class APIClient {
    
    private let session: URLSession
    private let tokenStorage: TokenStorage
    
    // MARK: - Init
    
    init(
        session: URLSession,
        tokenStorage: TokenStorage
    ) {
        
        self.session = session
        self.tokenStorage = tokenStorage
    }
}

// MARK: - Request

extension APIClient {
    
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        
        do {
            var request = try RequestBuilder.build(from: endpoint)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            if let token = tokenStorage.fetchToken() {
                request.setValue(
                    "Bearer \(token)",
                    forHTTPHeaderField: "Authorization"
                )
            }
            
            return session.dataTaskPublisher(for: request)
                .mapError { self.mapURLError($0) }
                .tryMap { data, response in
                    try self.validate(data: data, response: response)
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error in
                    if let networkError = error as? NetworkError {
                        return networkError
                    }
                    
                    if error is DecodingError {
                        return .decodingFailed
                    }
                    
                    return .unknown(error.localizedDescription)
                }
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: .invalidURL)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Error Mapping

private extension APIClient {
    
    func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternet
        case .timedOut:
            return .timeout
        default:
            return .unknown(error.localizedDescription)
        }
    }
    
    func validate(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
            
        case 400:
            throw NetworkError.badRequest(errorMessage(from: data))
            
        case 401:
            throw NetworkError.unauthorized
            
        case 403:
            throw NetworkError.forbidden
            
        case 404:
            throw NetworkError.notFound(errorMessage(from: data))
            
        case 409:
            throw NetworkError.conflict(errorMessage(from: data))
            
        case 500...599:
            throw NetworkError.serverError(errorMessage(from: data))
            
        default:
            throw NetworkError.unknown(errorMessage(from: data))
        }
    }
    
    func errorMessage(from data: Data) -> String? {
        try? JSONDecoder()
            .decode(APIErrorResponse.self, from: data)
            .message
    }
}
