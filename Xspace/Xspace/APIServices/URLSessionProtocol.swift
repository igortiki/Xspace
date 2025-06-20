//
//  URLSessionProtocol.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation

/// Protocol to abstract URLSession for easier testing and dependency injection.
protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
