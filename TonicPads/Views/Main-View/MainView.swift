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
    @Binding var showMainView: Bool     
    
    
    var body: some View {
        ZStack {
            if showSettings {
                // Navigate to SettingsPage
                SettingsPage(showSettings: $showSettings, viewModel: viewModel)
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
                        //back button
                        Button(action: {
                            showMainView = false
                            viewModel.engineOff()
                            
                        }){
                            Image("icons8-back-48" )
                                .resizable()
                                .frame(width:50, height:50)
                            
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        VStack{
                            
                            //settings button
                            Button(action: {
                                showSettings = true
                                
                            }){
                                Image("settings-icon-14963" )
                                    .resizable()
                                    .frame(width:50, height:50)
                            }
                            
                            
                            //help button
                            Button(action: {
                                showHelp = true
                            }){
                                Image("icons8-help-64" )
                                    .resizable()
                                    .frame(width:50, height:50)
                                
                            }
                            .sheet(isPresented: $showHelp) {
                                // display help page as a sheet
                                HelpPage()
                            }
                        }
                        .padding(.trailing, 30)
                    }
                    
                    .padding(.top, 16) // padding from the top edge
                    Spacer()
                }
                
                Spacer()
                
                // Toggle implementation for Play/Pause
                VStack {
                    
                    Spacer()
                    
                    if !isPlaying {
                            Text("Sound is OFF. Tap to toggle sound.")
                            .font(.custom("AvenirNext-Bold", size: 20))
                            .foregroundColor(.red)
                            .padding(.bottom, 8)
                        }
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
            skView.allowsTransparency = true
            skView.isMultipleTouchEnabled = true
            
            let scene = MainPadsScene.shared // Create the SpriteKit scene
            scene.size = size
            scene.viewModel = viewModel
            scene.scaleMode = .resizeFill // Scale the scene to fill the SKView
            skView.presentScene(scene) // Attach the scene to the SKView
            
            return skView
        }
        
        func updateUIView(_ uiView: SKView, context: Context) {
            
        }
    }
}






