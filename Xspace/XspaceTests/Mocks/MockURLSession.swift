//
//  MockURLSession.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/12/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

@testable import XSpace
import Foundation

final class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = nextError {
            throw error
        }

        guard let url = request.url else {
            throw APIError.invalidBaseURL
        }

        let response: URLResponse

            if let provided = nextResponse {
                response = provided
            } else if let fallback = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                response = fallback
            } else {
                throw APIError.badStatusCode(0)
            }

        return (nextData ?? Data(), response)
    }
}
