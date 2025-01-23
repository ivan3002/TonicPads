//
//  SettingsPage.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 18/01/2025.
//


import SwiftUI

struct SettingsPage: View {
    @Binding var showSettings: Bool // Binding to control visibility from MainView
    @ObservedObject var viewModel: SoundViewModel
    
    
    let selectorOptions = ["Option 1", "Option 2", "Option 3"] // Options for the picker
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 60) {
                Spacer()
                
                // Vertical Sliders
                HStack {
                    VStack {
                        Slider(value: Binding(
                            get: { Double(viewModel.getAttack())},
                            set: { viewModel.setStartAttack(attack: $0) }
                        ), in: 0...5)
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                            .rotationEffect(.degrees(-90)) // Vertical slider
                            .padding()
                    
                        
                        Text("Attack:\n\(String(format: "%.2f", viewModel.getAttack()))")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                    }
                    
                    VStack {
                        Slider(value: Binding(
                            get: { Double(viewModel.getRelease()) },
                            set: { viewModel.setStopRelease(release: $0) }
                        ), in: 0...5)
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                            .rotationEffect(.degrees(-90)) // Vertical slider
                            .padding()
                    
                        
                        Text("Release:\n\(String(format: "%.2f", viewModel.getRelease()))")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                    }
                }
                
                
                // Back Button
                Button(action: {
                    showSettings = false // Close SettingsPage and return to MainView
                }) {
                    Text("Back")
                        .font(.title2)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage(showSettings: .constant(true), viewModel: SoundViewModel())
    }
}
