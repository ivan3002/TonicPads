//
//  HomeView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var hueRotationAngle: Double = 0
    var body: some View {
        NavigationView{
            ZStack {
                Color(red: 0.2, green: 0.4, blue: 0.5)
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(hueRotationAngle))
                    .onAppear{
                        withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: true).speed(1)) {
                            hueRotationAngle = 100
                        }
                    }
                NavigationLink(destination: MainView()) {
                    Text("Start!")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        //.transition(t)
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
