//
//  XSpaceApp.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 17.06.2025.
//

import SwiftUI


@main
struct XSpaceApp: App {
    @AppStorage("selectedColorScheme") private var selectedColorScheme: String = "system"
    
    private let container: DependencyContainer?
    
    var colorScheme: ColorScheme? {
        switch selectedColorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
    
    init() {
        if let apiEnv = try? APIEnvironment() {
            self.container = DependencyContainer(apiService: apiEnv.apiService)
        } else {
            self.container = nil
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let container {
                LaunchesView(container: container)
                    .preferredColorScheme(colorScheme) 
            } else {
                Text("Failed to initialize dependencies.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

