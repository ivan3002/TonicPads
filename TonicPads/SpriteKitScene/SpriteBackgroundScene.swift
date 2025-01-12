//
//  SpriteBackgroundScene.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import SpriteKit
import SwiftUI


class MainPadsScene: SKScene {
    
//--------------------------------**INIT**------------------------------------------------------------------------------
    var viewModel: SoundViewModel!
    private var activeTouches: [UITouch: CGPoint] = [:] // Dictionary to track active touches and their locations
    
    private var dx: CGFloat = 0
    private var dy:CGFloat = 0
    private var startingX:CGFloat = 0
    


    override func didMove(to view: SKView) {
        // Set the background color to a soft gradient color
        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
        
        // Add glowing light nodes
        addGlowingLight(at: CGPoint(x: size.width * 0.3, y: size.height * 0.6), glowRadius: 100)
        addGlowingLight(at: CGPoint(x: size.width * 0.7, y: size.height * 0.4), glowRadius: 150)
    
    }
    
    
//---------------------***TouchFunctionality**-----------------------------------------------------------------------
    

      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Add new touches to the dictionary
          for touch in touches {
              activeTouches[touch] = touch.location(in: self)
          }
          if let touch = touches.first, let startingPoint = activeTouches[touch] {
              let startingX = startingPoint.x
              print("Starting X: \(startingX)")
          }
          
      }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)

            // Calculate deltas
            let deltaX = location.x - previousLocation.x
            let deltaY = location.y - previousLocation.y

            // Normalize deltaX and deltaY based on screen size
            let maxWidth = self.size.width
            let maxHeight = self.size.height
            let normalizedDeltaX = deltaX / maxWidth
            let normalizedDeltaY = deltaY / maxHeight

            print("Normalized x: ", normalizedDeltaX, " y: ", normalizedDeltaY)

            // Determine the dominant direction of movement
            if abs(normalizedDeltaX) > abs(normalizedDeltaY) {
                if normalizedDeltaX > 0 {
                    //print("Moving right")
                } else {
                    //print("Moving left")
                }
            } else {
                if normalizedDeltaY > 0 {
                    //print("Moving up")
                } else {
                    //print("Moving down")
                }
            }

            // Handle gestures based on the number of active touches
            if activeTouches.count == 1 {
                let volumeAdjustment = normalizedDeltaY
                viewModel.updateVolume(volumeDistance: volumeAdjustment)
            } else if activeTouches.count == 2 {
                let cutoffAdjustment = normalizedDeltaY
                viewModel.updateFilterCutoff(cutoffDistance: cutoffAdjustment)
            } else if activeTouches.count == 3 {
                let reverbAdjustment = normalizedDeltaY
                viewModel.updateReverbAmount(revAmount: reverbAdjustment)
            }

            // Optional: Visualize or act on the touch
            visualiseTouch(at: location)
        }
    }

      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Remove ended touches from the dictionary
          if let touch = touches.first, let startingPoint = activeTouches[touch] {
              let endingPoint = touch.location(in: self)
              let dx = endingPoint.x - startingPoint.x // Calculate horizontal distance
              let normalisedDX = dx / self.size.width
              //print("Starting X: \(startingPoint.x), Ending X: \(endingPoint.x), dx: \(dx)")
              
              if activeTouches.count == 1{
                  viewModel.updateFrequency(swipeDistance: normalisedDX)
              }
          }
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

    
//-----------------------------------------**Animations**-----------------------------------------------
    
      func visualiseTouch(at location: CGPoint) {
          let circle = SKShapeNode(circleOfRadius: 2)
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
    
}

//---------------------------***Labels and Text***-----------------------------------------------------------



