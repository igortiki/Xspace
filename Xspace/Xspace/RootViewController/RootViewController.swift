//
//  RootViewController.swift
//  Xspace
//
//  Created by Admin on 6/11/25.
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
            print("API init failed: \(error)")
        }
    }
}
