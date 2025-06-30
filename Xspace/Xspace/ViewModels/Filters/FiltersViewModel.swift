//
//  FiltersViewModel.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 XSpace. All rights reserved.
//


final class FiltersViewModel: FiltersViewModelProtocol {
   
    private(set) var filterModel: LaunchFiltersModel

    
    init(filterModel: LaunchFiltersModel = .empty) {
        self.filterModel = filterModel
    }

    var availableYears: [Int] {
        filterModel.availableYears
    }

    var launchYearsLabelText: String { "Launch Years" }

    var launchSuccessLabelText: String { "Launch Success" }
    
    var resetButtonTitle: String { "Reset Filters" }

    var sortOrderLabelText: String { "Sort Order" }

    var applyButtonTitle: String { "Apply Filters" }

    var successOptions: [String] { ["All", "Success only"] }

    var sortOrderOptions: [String] { ["ASC", "DESC"] }


    var selectedYears: Set<Int> {
        get { Set(filterModel.selectedYears) }
        set { filterModel.selectedYears = Array(newValue).sorted() }
    }

    var successOnly: Bool {
        get { filterModel.successOnly }
        set { filterModel.successOnly = newValue }
    }

    var sortOrderAscending: Bool {
        get { filterModel.sortOrderAscending }
        set { filterModel.sortOrderAscending = newValue }
    }

    func resetFilters() {
        filterModel = .empty
    }
}

