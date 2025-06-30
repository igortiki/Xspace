//
//  TopBarView.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 23.06.2025.
//

import SwiftUI

struct TopBarView: View {
    let container: DependencyContainer
    @State private var isShowingFilterSheet = false
    
    var body: some View {
        ZStack {
            // Centered title
            Text(container.companyViewModel.companyName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Right-aligned filter button
            HStack {
                Spacer()
                Button(action: {
                    isShowingFilterSheet = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                }
                .padding(.trailing, 8)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .sheet(isPresented: $isShowingFilterSheet) {
            let filtersViewModel = container.makeFiltersViewModel(from: container.launchesViewModel.currentFilters)
            FiltersView(
                filtersViewModel: filtersViewModel,
                launchesViewModel: container.launchesViewModel
            )
        }
    }
}

