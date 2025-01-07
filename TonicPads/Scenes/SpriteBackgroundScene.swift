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
    private var activeTouches: [UITouch: CGPoint] = [:] // Dictionary to track active touches and their locations

    override func didMove(to view: SKView) {
        // Set the background color to a soft gradient color
        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
        
        // Add glowing light nodes
        addGlowingLight(at: CGPoint(x: size.width * 0.3, y: size.height * 0.6), glowRadius: 100)
        addGlowingLight(at: CGPoint(x: size.width * 0.7, y: size.height * 0.4), glowRadius: 150)
        
        // Add subtle animations
        animateBackgroundGlow()
    }
    

      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Add new touches to the dictionary
          for touch in touches {
              activeTouches[touch] = touch.location(in: self)
          }
          printActiveFingers()
      }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                
                let deltaX = location.x - previousLocation.x
                let deltaY = location.y - previousLocation.y
                
                // Determine touch direction
                if abs(deltaX) > abs(deltaY) {
                    if deltaX > 0 {
                        print("Moving right")
                    } else {
                        print("Moving left")
                    }
                } else {
                    if deltaY > 0 {
                        print("Moving up")
                    } else {
                        print("Moving down")
                    }
                }
                
                // Optional: Visualize or act on touch
                visualizeTouch(at: location)
            }
        }

      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Remove ended touches from the dictionary
          for touch in touches {
              activeTouches.removeValue(forKey: touch)
          }
          printActiveFingers()
      }

      override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Remove cancelled touches from the dictionary
          for touch in touches {
              activeTouches.removeValue(forKey: touch)
          }
          printActiveFingers()
      }

      private func printActiveFingers() {
          print("Active fingers: \(activeTouches.count)")
      }

      func visualizeTouch(at location: CGPoint) {
          let circle = SKShapeNode(circleOfRadius: 10)
          circle.position = location
          circle.fillColor = .cyan
          circle.alpha = 0.7
          addChild(circle)

          let fadeOut = SKAction.fadeOut(withDuration: 0.5)
          let remove = SKAction.removeFromParent()
          circle.run(SKAction.sequence([fadeOut, remove]))
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
        skView.isMultipleTouchEnabled = true
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Updates the view if SwiftUI triggers a state change (not needed here)
    }
}
