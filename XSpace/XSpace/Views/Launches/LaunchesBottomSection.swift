//
//  LaunchesBottomSection.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 23.06.2025.
//

import SwiftUI

struct LaunchesBottomSection: View {
    @ObservedObject var launchesViewModel: LaunchesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            Text(launchesViewModel.launchesSectionTitle)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(white: 0.95))
                .padding(.horizontal, 8)
                .frame(height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 28/255, green: 36/255, blue: 58/255))
            
            if launchesViewModel.isLoading && launchesViewModel.cellViewModels.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = launchesViewModel.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button(launchesViewModel.retryButtonText) {
                        Task {
                            await launchesViewModel.loadNextPage()
                        }
                    }
                }
                .padding()
            } else if launchesViewModel.cellViewModels.isEmpty {
                Text(launchesViewModel.emptyLaunchesText)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                
                /*
                 List {
                 ForEach(launchesViewModel.cellViewModels) { cellVM in
                 VStack(spacing: 0) {
                 LaunchRowView(viewModel: cellVM)
                 Divider()
                 }
                 .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                 .listRowSeparator(.hidden)
                 }
                 } */
                
                List {
                    ForEach(Array(launchesViewModel.cellViewModels.enumerated()), id: \.element.id) { index, cellVM in
                        VStack(spacing: 0) {
                            LaunchRowView(viewModel: cellVM)
                            Divider()
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if index == launchesViewModel.cellViewModels.count - 1 {
                                Task {
                                    await launchesViewModel.loadNextPage()
                                }
                            }
                            
                            print ("UPDATED")
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(UIColor.separator), lineWidth: 1)
        )
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .task {
            if launchesViewModel.cellViewModels.isEmpty {
                await launchesViewModel.loadNextPage()
            }
        }
    }
}

