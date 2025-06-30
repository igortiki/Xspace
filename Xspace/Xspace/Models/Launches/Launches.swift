//
//  Launches.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//


import Foundation

struct LaunchesResponse: Decodable {
    let docs: [Launch]
    let totalDocs: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

struct Launch: Decodable {
    let id: String
    let name: String
    let dateUnix: Int
    let success: Bool?
    let rocket: String // Rocket ID
    let links: Links?

    struct Links: Decodable {
        let patch: Patch?

        struct Patch: Decodable {
            let small: String?
        }
    }
}
