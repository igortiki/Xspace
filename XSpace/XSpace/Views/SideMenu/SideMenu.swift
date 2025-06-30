//
//  SideMenu.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 28.06.2025.
//

import SwiftUI

struct SideMenu: View {
    @AppStorage("selectedColorScheme") private var selectedColorScheme: String = "system"

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Appearance")
                .font(.headline)

            Button("🌞 Light") {
                selectedColorScheme = "light"
            }

            Button("🌙 Dark") {
                selectedColorScheme = "dark"
            }

            Spacer()
        }
        .padding(.top, 100)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

