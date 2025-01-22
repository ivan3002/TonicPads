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
    @State private var slider3Value: Double = 0.5 // For third slider
    @State private var isToggleOn: Bool = false // For toggle switch
    @State private var selectedOption: Int = 0 // For selector (picker)
    
    let selectorOptions = ["Option 1", "Option 2", "Option 3"] // Options for the selector
    
    var body: some View {
        GeometryReader{ geometry in
            VStack (spacing: 40){
                // Vertical Sliders
                Spacer()
                HStack {
                    VStack(spacing: 20) {
                        Slider(value: $slider1Value, in: 0...1)
                            .rotationEffect(.degrees(-90)) // vertical slider
                            .frame(height: geometry.size.height * 0.3) // height
                            .padding()
                        Text("Attack:\n \(String(format: "%.2f", slider1Value))")
                            .font(.title3)
                        
                    }
                    
                    
                    VStack(spacing: 20) {
                        Slider(value: $slider2Value, in: 0...1)
                            .rotationEffect(.degrees(-90)) // vertical slider
                            .frame(height: geometry.size.height * 0.3) // height
                            .padding()
                        
                        Text("Decay:\n \(String(format: "%.2f", slider2Value))")
                            .font(.title3)
                        
                    }
                }
                Spacer()
                VStack{
                    Slider(value: $slider3Value, in: 0...1)
                        .padding()
                        .frame(width: geometry.size.width * 0.4)
                    
                    Text("Glide Amount: \(String(format: "%.2f", slider3Value))")
                        .font(.title3)
                }
                
                // Toggle Switch
                Toggle(isOn: $isToggleOn){
                    
                }
                .frame(width: geometry.size.width * 0.01)
                .padding()
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
                .padding()
                Spacer()
            }
            .padding()
        }
    }
        
        struct SettingsPage_Previews: PreviewProvider {
            static var previews: some View {
                SettingsPage(showSettings: .constant(true))
            }
    }
}
