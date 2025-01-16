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
    var size: CGSize // Pass the size explicitly
    
    // Store the scene for external access
    var scene = MainPadsScene(size: .zero)
    
    func makeUIView(context: Context) -> SKView {
        
        let skView = SKView() // Create an SKView instance
        skView.allowsTransparency = true // Optional: Allows transparent backgrounds
        skView.isMultipleTouchEnabled = true
        //print("makeUIView: SKView bounds at creation: \(skView.bounds.size)")
       
        print("makeUIView: Passing size to scene: \(size)")
        let scene = MainPadsScene(size: size) // Create the SpriteKit scene
        scene.viewModel = viewModel
        scene.scaleMode = .resizeFill // Scale the scene to fill the SKView
        skView.presentScene(scene) // Attach the scene to the SKView
       
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
           
            GeometryReader{ geometry in
                SpriteKitBackgroundView(size: geometry.size)
                    .environmentObject(viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
            }
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


