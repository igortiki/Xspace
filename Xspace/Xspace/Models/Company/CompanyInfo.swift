//
//  CompanyInfo.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

struct CompanyInfo: Decodable {
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launchSites: Int
    let valuation: Int64
}
