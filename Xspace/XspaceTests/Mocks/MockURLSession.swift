//
//  MockURLSession.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/12/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

@testable import Xspace
import Foundation

final class MockURLSession: URLSessionProtocol {
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

        let response = nextResponse ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ) ?? URLResponse()

        return (nextData ?? Data(), response)
    }
}
