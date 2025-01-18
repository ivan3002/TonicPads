//
//  SettingsPage.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 18/01/2025.
//

import SwiftUI

struct SettingsPage: View {
    @Binding var showSettings: Bool // Binding to control visibility from MainView
    
    @State private var slider1Value: Double = 0.5 // For first slider
    @State private var slider2Value: Double = 0.5 // For second slider
    @State private var isToggleOn: Bool = false // For toggle switch
    @State private var selectedOption: Int = 0 // For selector (picker)

    let selectorOptions = ["Option 1", "Option 2", "Option 3"] // Options for the selector

    var body: some View {
        
        VStack() {
            Spacer()
            // Vertical Sliders
            HStack {
                VStack {
                    Slider(value: $slider1Value, in: 0...1)
                        .rotationEffect(.degrees(-90)) // vertical slider
                        .frame(width: 300, height: 400) // Adjust height for vertical slider
                    Text("Attack: \(String(format: "%.2f", slider1Value))")
                        .font(.title)
                }
                
                VStack {
                    Slider(value: $slider2Value, in: 0...1)
                        .rotationEffect(.degrees(-90)) // vertical slider
                        .frame(width: 300, height: 400) // Adjust height for vertical slider
                    Text("Decay: \(String(format: "%.2f", slider2Value))")
                        .font(.title)
                }
            }
            
            
            // Toggle Switch
            Toggle(isOn: $isToggleOn){
                
            }
            .position()
            .toggleStyle(SwitchToggleStyle())
            
            
            // Back Button
            Button(action: {
                showSettings = false // Close SettingsPage and return to MainView
            }) {
                Text("Back")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage(showSettings: .constant(true))
    }
}
