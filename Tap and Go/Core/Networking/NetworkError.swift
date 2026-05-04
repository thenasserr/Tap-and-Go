//
//  NetworkError.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation

// MARK: - Network Error

enum NetworkError: Error, Equatable {
    
    case invalidURL
    case invalidResponse
    case decodingFailed
    case noInternet
    case timeout
    case unauthorized
    case forbidden
    case notFound(String?)
    case conflict(String?)
    case badRequest(String?)
    case serverError(String?)
    case unknown(String?)
}

// MARK: - User Message

extension NetworkError {
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingFailed:
            return "Could not read server response."
        case .noInternet:
            return "No internet connection."
        case .timeout:
            return "The request timed out. Please try again."
        case .unauthorized:
            return "Your session expired. Please log in again."
        case .forbidden:
            return "You do not have permission to perform this action."
        case .notFound(let message):
            return message ?? "The requested item was not found."
        case .conflict(let message):
            return message ?? "This item already exists."
        case .badRequest(let message):
            return message ?? "Invalid request."
        case .serverError(let message):
            return message ?? "Server error. Please try again later."
        case .unknown(let message):
            return message ?? "Something went wrong."
        }
    }
}
