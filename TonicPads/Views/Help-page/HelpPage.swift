//
//  HelpPage.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 17/01/2025.
//

import SwiftUI

//see HelpText.swift for content

struct HelpPage: View {
    let helpText = HelpText()
    var body: some View {
        VStack {
            // Title at the top
            Text("How to shape your sound")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            
            Spacer() // Push content to center
            
            // Vertical stack for image-label pairs
            ScrollView{
                HStack{
                    VStack(spacing: 10) {
                        Text(helpText.intro)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            Image("1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            
                            Text(helpText.oneVerticalFingerInfo)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            
                            Text(helpText.oneHorizontalFingerInfo)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            
                            Text(helpText.twoVerticalFingerInfo)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("4")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            
                            Text(helpText.twoHorizontalFingerInfo)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        HStack {
                            Image("5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            
                            Text(helpText.threeFingerInfo)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        
                    }
                    
                    Spacer() // Push content to the center
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
