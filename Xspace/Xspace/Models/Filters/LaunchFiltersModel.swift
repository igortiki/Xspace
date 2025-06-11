//
//  LaunchFiltersModel.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

struct LaunchFiltersModel: Equatable {
    var selectedYears: [Int] = []
    var successOnly: Bool = false
    var sortOrderAscending: Bool = true
}

extension LaunchFiltersModel {
    static var empty: LaunchFiltersModel {
        LaunchFiltersModel(selectedYears: [], successOnly: false, sortOrderAscending: true)
    }
}
