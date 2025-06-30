//
//  FiltersViewModel.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import SwiftUI

final class FiltersViewModel: ObservableObject {
    
    @Published private(set) var filterModel: LaunchFiltersModel

    
    init(filterModel: LaunchFiltersModel = .empty) {
        self.filterModel = filterModel
    }

    var availableYears: [Int] {
        filterModel.availableYears
    }

    var launchYearsLabelText: String { "Launch Years" }

    var launchSuccessLabelText: String { "Launch Success" }

    var sortOrderLabelText: String { "Sort Order" }

    var applyButtonTitle: String { "Apply Filters" }
    
    var resetButtonTitle: String { "Reset Filters" }

    var successOptions: [String] { ["All", "Success only"] }

    var sortOrderOptions: [String] { ["ASC", "DESC"] }


    var selectedYears: Set<Int> {
        get { Set(filterModel.selectedYears) }
        set { filterModel.selectedYears = Array(newValue).sorted() }
    }

    var successFilter: Int {
        get { filterModel.successOnly ? 1 : 0 }
        set { filterModel.successOnly = (newValue == 1) }
    }

    
    var sortOrder: Int {
        get { filterModel.sortOrderAscending ? 0 : 1 }
        set { filterModel.sortOrderAscending = (newValue == 0) }
    }


    func resetFilters() {
        filterModel = .empty
    }
}

