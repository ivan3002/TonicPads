//
//  MainView.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import SwiftUI
import SpriteKit


struct SpriteKitBackgroundView: UIViewRepresentable {
   
    func makeUIView(context: Context) -> SKView {
        let skView = SKView() // Create an SKView instance
        let scene = GlowingBackgroundScene(size: UIScreen.main.bounds.size) // Create the SpriteKit scene
        scene.scaleMode = .resizeFill // Scale the scene to fill the SKView
        skView.presentScene(scene) // Attach the scene to the SKView
        skView.allowsTransparency = true // Optional: Allows transparent backgrounds
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Updates the view if SwiftUI triggers a state change (not needed here)
    }
}


struct MainView: View {
    let engineTest = SoundEngine()
    var body: some View {
        ZStack {
            SpriteKitBackgroundView() // The glowing SpriteKit background
                .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
                .navigationBarBackButtonHidden(true)
            Button(action: {
                engineTest.startSound()
                sleep(1)
                engineTest.stopSound()
                
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


