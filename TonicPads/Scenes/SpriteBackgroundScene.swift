//
//  SpriteBackgroundScene.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import SpriteKit
import SwiftUI

class GlowingBackgroundScene: SKScene {
    override func didMove(to view: SKView) {
        // Set the background color to a soft gradient color
        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
        
        // Add glowing light nodes
        addGlowingLight(at: CGPoint(x: size.width * 0.3, y: size.height * 0.6), glowRadius: 100)
        addGlowingLight(at: CGPoint(x: size.width * 0.7, y: size.height * 0.4), glowRadius: 150)
        
        // Add subtle animations
        animateBackgroundGlow()
    }
    
    func addGlowingLight(at position: CGPoint, glowRadius: CGFloat) {
        // Create a circular glow
        let glow = SKShapeNode(circleOfRadius: glowRadius)
        glow.position = position
        glow.fillColor = SKColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 0.2)
        glow.strokeColor = .clear
        glow.glowWidth = 20
        addChild(glow)
        
        // Animate opacity to create a subtle glowing effect
        let fadeInOut = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 2),
            SKAction.fadeAlpha(to: 0.2, duration: 2)
        ])
        glow.run(SKAction.repeatForever(fadeInOut))
    }
    
    func animateBackgroundGlow() {
        // Create a subtle scaling animation to give life to the background
        //let scaleUp = SKAction.scale(to: 1.02, duration: 4)
        //let scaleDown = SKAction.scale(to: 1.0, duration: 4)
        //let pulse = SKAction.sequence([scaleUp, scaleDown])
        //self.run(SKAction.repeatForever(pulse))
    }
}


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
