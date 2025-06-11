//
//  Rockets.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

struct RocketResponse: Decodable {
    let docs: [Rocket]
}

struct Rocket: Decodable {
    let id: String
    let name: String
    let type: String
}
