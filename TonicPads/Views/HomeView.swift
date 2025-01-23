//
//  HomeView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var hueRotationAngle: Double = 0
    @State var showMainView = false
    @State private var showHelp = false
    

    var body: some View {
        GeometryReader{geometry in
            ZStack {
                if showMainView == true{
                    MainView(showMainView: $showMainView)
                    
                } else {
                    Color(red: 0.2, green: 0.4, blue: 0.5)
                        .edgesIgnoringSafeArea(.all)
                        .hueRotation(.degrees(hueRotationAngle))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: true).speed(1)) {
                                hueRotationAngle = 100
                            }
                        }
                    VStack {
                        Image("TonicPads")
                            .resizable()
                            .frame(width: geometry.size.width * 0.5 ,height: geometry.size.width * 0.5)
                        
                        Button(action: {
                            showMainView = true
                        }) {
                            Text("Go Inside!")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            showHelp = true
                            
                        }){
                            Text("How to use TonicPads")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.teal)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showHelp) {
                            // Embed HelpPage storyboard
                            HelpPage()
                        }
                    }
                }
            }
            
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
