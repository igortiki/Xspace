//
//  LaunchCellViewModel.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import UIKit


final class LaunchCellViewModel: LaunchCellViewModelProtocol {
    
    // MARK: - Properties
    private var imageLoadTask: Task<Void, Never>?
    private let apiService: APIServiceProtocol
    private let enrichedLaunch: EnrichedLaunch
    private(set) var missionPatchImage: UIImage?
    
    // MARK: - Initialization
    init(enrichedLaunch: EnrichedLaunch, apiService: APIServiceProtocol) {
        self.enrichedLaunch = enrichedLaunch
        self.apiService = apiService
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
    
    var successIcon: UIImage? {
        UIImage(systemName: enrichedLaunch.launch.success == true ? "checkmark.circle" : "xmark.octagon")
    }
    
    var successIconTintColor: UIColor {
        enrichedLaunch.launch.success == true ? .systemGreen : .systemRed
    }
    
    var dateTimeString: String {
        let date = DateFormatterHelper.formattedDate(from: enrichedLaunch.launch.dateUnix)
        let time = DateFormatterHelper.formattedTime(from: enrichedLaunch.launch.dateUnix)
        return "Date/Time: \(date) at \(time)"
    }
    
    var daysSinceText: String {
        let signed = DateFormatterHelper.signedDaysDifference(from: enrichedLaunch.launch.dateUnix)
        return "Days: \(signed)"
    }
    
    var fromNowText: String {
        let launchDate = Date(timeIntervalSince1970: TimeInterval(enrichedLaunch.launch.dateUnix))
        let word = launchDate < Date() ? "Since" : "From"
        let relative = DateFormatterHelper.relativeDate(from: enrichedLaunch.launch.dateUnix)
        return "\(word) now: \(relative)"
    }
    
    // MARK: - Image Handling
    
    /// Fetches mission patch image from URL and stores it
    private func fetchAndStoreMissionPatchImage(from urlString: String?) async -> UIImage? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return nil
        }
        
        return try? await apiService.asyncImage(from: url)
    }
    
    /// Prepares image and calls completion handler on main thread
    func prepareImage(completion: @escaping (UIImage?) -> Void) {
        imageLoadTask?.cancel()
        
        imageLoadTask = Task { [weak self] in
            guard let self = self else { return }
            
            let image = await self.fetchAndStoreMissionPatchImage(
                from: self.enrichedLaunch.launch.links?.patch?.small
            )
            self.missionPatchImage = image
            
            await MainActor.run {
                completion(image)
            }
        }
    }
    
    func cancelImageLoad() {
        imageLoadTask?.cancel()
        imageLoadTask = nil
    }
}

