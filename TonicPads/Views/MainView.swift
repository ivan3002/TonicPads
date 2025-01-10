//
//  MainView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI
import SpriteKit


struct SpriteKitBackgroundView: UIViewRepresentable {
    @EnvironmentObject var viewModel: SoundViewModel
    func makeUIView(context: Context) -> SKView {
        let skView = SKView() // Create an SKView instance
        let scene = MainPadsScene(size: UIScreen.main.bounds.size) // Create the SpriteKit scene
        scene.viewModel = viewModel
        scene.scaleMode = .resizeFill // Scale the scene to fill the SKView
        skView.presentScene(scene) // Attach the scene to the SKView
        skView.allowsTransparency = true // Optional: Allows transparent backgrounds
        skView.isMultipleTouchEnabled = true
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Updates the view if SwiftUI triggers a state change (not needed here)
    }
}



struct MainView: View {
    @StateObject private var viewModel = SoundViewModel()
    @State private var startStopBool = false
    var body: some View {
        ZStack {
            SpriteKitBackgroundView() // The glowing SpriteKit background
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
                .navigationBarBackButtonHidden(true)
                .environmentObject(viewModel)
            Button(action: {
                if startStopBool == false{
                    viewModel.playSound()
                    startStopBool = true
                }else{
                    viewModel.stopSound()
                    startStopBool = false
                }
                
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


