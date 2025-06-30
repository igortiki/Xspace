//
//  LaunchCellViewModel.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//


import SwiftUI

@MainActor
final class LaunchCellViewModel: ObservableObject, Identifiable {
    
    // MARK: - Published Properties
    @Published var missionPatchImage: Image? = nil

    // MARK: - Identifiers
    let id: String

    // MARK: - Private Properties
    private var imageLoadTask: Task<Void, Never>?
    private let apiService: APIServiceProtocol
    private let enrichedLaunch: EnrichedLaunch

    // MARK: - Init
    init(enrichedLaunch: EnrichedLaunch, apiService: APIServiceProtocol) {
        self.enrichedLaunch = enrichedLaunch
        self.apiService = apiService
        self.id = enrichedLaunch.launch.id
    }

    // MARK: - Computed Properties
    var missionName: String {
        "Mission: \(enrichedLaunch.launch.name)"
    }

    var rocketDescription: String {
        if let rocket = enrichedLaunch.rocket {
            return "Rocket: \(rocket.name) / \(rocket.type)"
        } else {
            return "Rocket: \"Unknown / N/A."
        }
    }

    var successIcon: Image {
        Image(systemName: enrichedLaunch.launch.success == true ? "checkmark.circle" : "xmark.octagon")
    }

    var successIconTintColor: Color {
        enrichedLaunch.launch.success == true ? .green : .red
    }

    var dateTimeString: String {
        let date = FormatterHelper.formattedDate(from: enrichedLaunch.launch.dateUnix)
        let time = FormatterHelper.formattedTime(from: enrichedLaunch.launch.dateUnix)
        return "Date/Time: \(date) at \(time)"
    }

    var daysSinceText: String {
        let signed = FormatterHelper.signedDaysDifference(from: enrichedLaunch.launch.dateUnix)
        return "Days: \(signed)"
    }

    var fromNowText: String {
        let launchDate = Date(timeIntervalSince1970: TimeInterval(enrichedLaunch.launch.dateUnix))
        let word = launchDate < Date() ? "Since" : "From"
        let relative = FormatterHelper.relativeDate(from: enrichedLaunch.launch.dateUnix)
        return "\(word) now: \(relative)"
    }

    // MARK: - Image Handling
    func loadMissionImageIfNeeded() {
        guard missionPatchImage == nil else { return }

        imageLoadTask?.cancel()
        imageLoadTask = Task {
            if let uiImage = await fetchUIImage() {
                missionPatchImage = Image(uiImage: uiImage)
            } else {
                missionPatchImage = nil
            }
        }
    }

    func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }

    private func fetchUIImage() async -> UIImage? {
        guard let urlString = enrichedLaunch.launch.links?.patch?.small,
              let url = URL(string: urlString) else {
            return nil
        }

        return try? await apiService.asyncImage(from: url)
    }
}
