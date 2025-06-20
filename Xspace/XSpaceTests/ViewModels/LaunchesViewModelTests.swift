//
//  LaunchesViewModelTests.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/13/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import XCTest
@testable import XSpace

final class LaunchesViewModelTests: XCTestCase {
    
    func test_loadNextPage_success() async {
        
        
        // Provide mocked responses
        let launchResponse = XSpace.LaunchesResponse(
            docs: [
                XSpace.Launch(
                    id: "1",
                    name: "Falcon 9",
                    dateUnix: 1234567890,
                    success: true,
                    rocket: "rocket1",
                    links: XSpace.Launch.Links(
                        patch: XSpace.Launch.Links.Patch(small: "https://example.com/image.png")
                    )
                )
            ],
            totalDocs: 1,
            limit: 10,
            totalPages: 1,
            page: 1,
            pagingCounter: 1,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil
        )
        
        
        
        
        let rocketResponse = XSpace.RocketResponse(
            docs: [XSpace.Rocket(id: "rocket1", name: "Falcon Heavy", type: "rocket")]
        )
        
        let mockAPI = MockLaunchesAPIService(launchResponse: launchResponse, rocketResponse: rocketResponse)
        
        let viewModel = await LaunchesViewModel(apiService: mockAPI)
        
        await viewModel.loadNextPage()
        
        await MainActor.run {
            XCTAssertEqual(viewModel.enrichedLaunchesCount, 1)
        }
    }
    
    
    @MainActor
    func test_fetchLaunches_failure_sendsErrorState() async {
        var capturedState: LoadState<Bool>?
        
        let error = NSError(domain: "network", code: -1009)
        let mockAPI = MockLaunchesAPIService(error: error)
        let viewModel = LaunchesViewModel(apiService: mockAPI)
        
        viewModel.onViewStateChange = { state in
            capturedState = state
        }
        
        await viewModel.loadNextPage()
        
        guard let state = capturedState else {
            XCTFail("Expected a state, got nil")
            return
        }
        
        guard case .error(let message) = state else {
            XCTFail("Expected .error state")
            return
        }
        
        XCTAssertTrue(message.contains("The operation couldn’t be completed"))
    }
}

