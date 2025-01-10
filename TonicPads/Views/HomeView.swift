//
//  HomeView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var hueRotationAngle: Double = 0
    @State private var showMainView: Bool = false

    var body: some View {
        ZStack {
            if showMainView {
                MainView()
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
                    Button(action: {
                        showMainView = true
                    }) {
                        Text("Go Inside")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Text("Tutorial")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
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
