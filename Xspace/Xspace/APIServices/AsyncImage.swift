//
//  ImageLoader.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/8/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import UIKit
import Foundation

extension APIService {
    
    // MARK: - Image Cache
    private static let imageCache = NSCache<NSURL, UIImage>()

    // MARK: - Image Loading
    func asyncImage(from url: URL) async throws -> UIImage {
        // Check cache
        if let cached = Self.imageCache.object(forKey: url as NSURL) {
            return cached
        }

        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.badStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        guard let image = UIImage(data: data) else {
            throw APIError.imageDecodingFailed
        }

        Self.imageCache.setObject(image, forKey: url as NSURL)
        return image
    }
}
