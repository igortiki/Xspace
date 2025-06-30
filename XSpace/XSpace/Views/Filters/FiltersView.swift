//
//  FiltersView.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 27.06.2025.
//

import SwiftUI


struct FiltersView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var filtersViewModel: FiltersViewModel
    let launchesViewModel: LaunchesViewModel
    
    
    private let columns = [
        GridItem(.flexible(minimum: 40), spacing: 4),
        GridItem(.flexible(minimum: 40), spacing: 4),
        GridItem(.flexible(minimum: 40), spacing: 4),
        GridItem(.flexible(minimum: 40), spacing: 4)
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Launch Years Section
            VStack(alignment: .leading, spacing: 8) {
                Text(filtersViewModel.launchYearsLabelText).font(.headline)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filtersViewModel.availableYears, id: \.self) { year in
                            Text(String(year))
                                .padding(.vertical, 6).padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(filtersViewModel.selectedYears.contains(year)
                                              ? Color.blue.opacity(0.8)
                                              : Color.clear)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            
                                .foregroundColor(
                                    filtersViewModel.selectedYears.contains(year)
                                    ? .white
                                    : .blue
                                )
                            
                                .onTapGesture { toggleYear(year) }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 190)
            }
            // Launch Success Section
            VStack(alignment: .leading, spacing: 8) {
                Text(filtersViewModel.launchSuccessLabelText).font(.headline)
                Picker(selection: $filtersViewModel.successFilter, label: EmptyView()) {
                    Text(filtersViewModel.successOptions[0]).tag(0)
                    Text(filtersViewModel.successOptions[1]).tag(1)
                }
                .pickerStyle(.segmented)
            }
            // Sort Order Section
            VStack(alignment: .leading, spacing: 8) {
                Text(filtersViewModel.sortOrderLabelText).font(.headline)
                Picker(selection: $filtersViewModel.sortOrder, label: EmptyView()) {
                    Text(filtersViewModel.sortOrderOptions[0]).tag(0)
                    Text(filtersViewModel.sortOrderOptions[1]).tag(1)
                }
                .pickerStyle(.segmented)
            }
            // Action Buttons
            HStack {
                Button(filtersViewModel.applyButtonTitle) {
                    Task {
                        await applyFilters()
                    }
                }
                .padding().frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white).cornerRadius(8)
                Button(filtersViewModel.resetButtonTitle) { resetFilters() }
                    .padding()
                    .foregroundColor(.red)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        Spacer()
    }
    
    // Helper methods for toggling years, applying, resetting...
    private func toggleYear(_ year: Int) {
        if filtersViewModel.selectedYears.contains(year) {
            filtersViewModel.selectedYears.remove(year)
        } else {
            filtersViewModel.selectedYears.insert(year)
        }
    }
    private func applyFilters() async {
        dismiss()
        await launchesViewModel.applyFilters(filtersViewModel.filterModel)
        print("Apply tapped")
    }
    private func resetFilters() {
        print("reset tapped")
        filtersViewModel.resetFilters()
    }
}
