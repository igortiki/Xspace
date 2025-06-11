//
//  LaunchFiltersModel.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

struct LaunchFiltersModel: Equatable {
    var selectedYears: [Int]
    var successOnly: Bool
    var sortOrderAscending: Bool
    var availableYears: [Int]

    static var empty: LaunchFiltersModel {
        LaunchFiltersModel(
            selectedYears: [],
            successOnly: false,
            sortOrderAscending: true,
            availableYears: Array(2006...2025)
        )
    }
}

