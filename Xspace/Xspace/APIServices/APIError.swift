//
//  APIError.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import Foundation

/// Represents possible errors that can occur during API requests.
enum APIError: Error {
    case invalidBaseURL
    case badStatusCode(Int)
    case decodingFailed(underlying: Error)
    case stringDecodingFailed
    case imageDecodingFailed
}
