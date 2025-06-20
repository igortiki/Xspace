//
//  APIError.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation

/// Represents possible errors that can occur during API requests.
enum APIError: Error {
    case invalidBaseURL
    case badStatusCode(Int)
    case decodingFailed(underlying: Error)
    case stringDecodingFailed
    case imageDecodingFailed
    case underlying(Error)
    
    var userMessage: String {
        switch self {
        case .invalidBaseURL:
            return "Internal error: Invalid base URL."
        case .badStatusCode(let code):
            return "Server returned an error (code: \(code))."
        case .decodingFailed:
            return "Failed to decode the server response."
        case .stringDecodingFailed:
            return "Unable to decode a string from data."
        case .imageDecodingFailed:
            return "Failed to decode image data."
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}
