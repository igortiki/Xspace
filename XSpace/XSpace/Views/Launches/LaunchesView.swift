//
//  LaunchesView.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 19.06.2025.
//

import SwiftUI

struct LaunchesView: View {
    @State private var isMenuVisible = false
    let container: DependencyContainer
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Main content
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                    }
                    .offset(x: isMenuVisible ? 200 : 0)
                    Spacer()
                }
                .padding()
                
                VStack(spacing: 0) {
                    LaunchesTopSection(container: container)
                    LaunchesBottomSection(launchesViewModel: container.launchesViewModel)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // ← Important!
                .background(Color(.systemBackground))
                
            }
            .disabled(isMenuVisible)
            .blur(radius: isMenuVisible ? 3 : 0)
            
            // Overlay
            if isMenuVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuVisible = false
                        }
                    }
            }
            
            // Side Menu with custom offset instead of transition
            SideMenu()
                .frame(width: 250)
                .offset(x: isMenuVisible ? 0 : -300) // <-- Control initial and final position
                .animation(.easeInOut(duration: 0.3), value: isMenuVisible)
        }
    }
}

