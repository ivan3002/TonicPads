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
    @State private var showHelp = false
    @State private var isPlaying = false
    @State private var showSettings: Bool = false
    @Binding var showMainView: Bool // Accept a binding
    
    
    
    var body: some View {
        ZStack {
            if showSettings {
                // Navigate to SettingsPage
                SettingsPage(showSettings: $showSettings)
            }else{
                
                GeometryReader{ geometry in
                    SpriteKitBackgroundView(size: geometry.size)
                        .environmentObject(viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all) // Ensure it fills the entire screen
                }
                //---------------------
                VStack{
                    
                    HStack{
                        //--------------------------------
                        Button(action: {
                            showMainView = false 
                            print("hi3")
                        }){
                            Image("icons8-back-48" )
                                .resizable()
                                .frame(width:50, height:50)
                            
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        VStack{
                            
                            Button(action: {
                                showSettings = true
                                print("hi")
                                
                            }){
                                Image("settings-icon-14963" )
                                    .resizable()
                                    .frame(width:50, height:50)
                            }
                            
                            
                            //--------------------------------
                            Button(action: {
                                print("hi2")
                                showHelp = true
                            }){
                                Image("icons8-help-64" )
                                    .resizable()
                                    .frame(width:50, height:50)
                                
                            }
                            .sheet(isPresented: $showHelp) {
                                // Embed HelpPage storyboard
                                HelpPage()
                            }
                        }
                        .padding(.trailing, 30)
                    }
                    
                    .padding(.top, 16) // Add padding from the top edge
                    Spacer()
                }
                
                Spacer()
                // Toggle for Play/Pause
                VStack {
                    Spacer()
                    Toggle("", isOn: $isPlaying)
                        .labelsHidden()
                        .padding(.bottom, 40)
                        .onChange(of: isPlaying) { newValue in
                            if newValue {
                                viewModel.playSound()
                            } else {
                                viewModel.stopSound()
                            }
                        }
                        .hueRotation(Angle(degrees: 70))
                    
                }
                
                
            }
        }
    }
    
    
    struct MainView_Previews: PreviewProvider {
        @State static var showMainView = true
        static var previews: some View {
            MainView(showMainView: $showMainView)
        }
    }
    
    
    //-------------------------------------------------------------------------------------------
    
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
}






