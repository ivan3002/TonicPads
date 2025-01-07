//
//  MainView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI
import SpriteKit




struct MainView: View {
    @StateObject private var viewModel = SoundViewModel()
    var body: some View {
        ZStack {
            SpriteKitBackgroundView() // The glowing SpriteKit background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
                .navigationBarBackButtonHidden(true)
            Button(action: {
                viewModel.playSound()
                sleep(1)
                viewModel.stopSound()
                
            }) {
                Text("Sound Test")
                
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


