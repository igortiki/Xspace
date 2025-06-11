//
//  RootViewController.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    // MARK: - Properties
    private var launchesViewController: LaunchesViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupInitialScreen()
    }
    
    // MARK: - Setup
    private func setupInitialScreen() {
        do {
            let apiEnvironment = try APIEnvironment()
            let launchesViewModel = LaunchesViewModel(apiService: apiEnvironment.apiService)
            let companyViewModel = CompanyViewModel(apiService: apiEnvironment.apiService)
            
            let launchesVC = LaunchesViewController(viewModel: launchesViewModel, companyViewModel: companyViewModel)
            self.launchesViewController = launchesVC
            
            addChild(launchesVC)
            launchesVC.view.frame = view.bounds
            launchesVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(launchesVC.view)
            launchesVC.didMove(toParent: self)
            
        } catch {
            fatalError("API init failed: \(error)")
        }
    }
}
