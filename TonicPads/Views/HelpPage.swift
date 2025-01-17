//
//  HelpPage.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 17/01/2025.
//

import SwiftUI

struct HelpPage: View {
    var body: some View {
        VStack {
            // Title at the top
            Text("How to shape your sound")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            
            Spacer() // Push content to center dynamically
            
            // Vertical stack for image-label pairs
            ScrollView{
                HStack{
                    VStack(spacing: 10) { // Adjust spacing as needed
                        
                        HStack {
                            Image("1") // Replace with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200) // Adjust as needed
                            
                            Text("Label")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("2") // Replace with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200) // Adjust as needed
                            
                            Text("Label")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("3") // Replace with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200) // Adjust as needed
                            
                            Text("Label")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("4") // Replace with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200) // Adjust as needed
                            
                            Text("Label")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("5") // Replace with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200) // Adjust as needed
                            
                            Text("Label")
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        
                    }
                    
                    Spacer() // Push content dynamically to the center
                }
                .padding(.horizontal, 16) // Add padding on the sides
            }
        }
    }
}

struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
