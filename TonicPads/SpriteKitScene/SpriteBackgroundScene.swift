//
//  SpriteBackgroundScene.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import SpriteKit
import SwiftUI

enum Direction {
    case x
    case y
}

class MainPadsScene: SKScene {
    
    //--------------------------------**INIT**------------------------------------------------------------------------------
    var viewModel: SoundViewModel!
    private var activeTouches: [UITouch: CGPoint] = [:] // Dictionary to track active touches and their locations
    private var volumeLabel: SKLabelNode!
    private var volumeValueLabel: SKLabelNode!
    
    private var noteLabel: SKLabelNode!
    private var noteValueLabel: SKLabelNode!
    private var noteNames: [String] = [
        "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B", "C"
    ]
    private var currentIndex: Int = 0

    
    private var filterCutoffLabel: SKLabelNode!
    private var filterCutoffValueLabel: SKLabelNode!
    
    private var reverbLabel: SKLabelNode!
    private var reverbValueLabel: SKLabelNode!
    
    private var complexityLabel: SKLabelNode!
    private var complexityValueLabel: SKLabelNode!
    
    private var normalizedDeltaX: CGFloat!
    private var normalizedDeltaY: CGFloat!
    
    private var accumulatedDeltaX: CGFloat = 0.0 // Tracks motion between updates
    private var totalDeltaX: CGFloat = 0.0       // Tracks total motion for the gesture
    
   
    private var currentDirection: Direction?
    
    
    
    override func didMove(to view: SKView) {
        // Set the background color to a soft gradient color
        
        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
        
        // Add glowing light nodes
        //note that origin is bottom left
        addGlowingLight(at: CGPoint(x: size.width * 0.3, y: size.height * 0.6), glowRadius: 100)
        addGlowingLight(at: CGPoint(x: size.width * 0.7, y: size.height * 0.4), glowRadius: 150)
        
        
        print("Scene initialized with size: \(size)")
        initLabels()
    }
    
    //did this because size is initialising to 0,0 if done in didMove() for some reason
    override func didChangeSize(_ oldSize: CGSize) {
        
        print("Scene size changed to \(size)")
        
        // Add the particle emitter
        if let particleEmitter = SKEmitterNode(fileNamed: "MainBackground.sks") {
            particleEmitter.position = CGPoint(x: size.width/2, y: size.height/2)
            particleEmitter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
            particleEmitter.zPosition = -1 //making lowest layer of scene
            addChild(particleEmitter)
        }
        
        initLabels()
        
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
            normalizedDeltaX = deltaX / maxWidth
            normalizedDeltaY = deltaY / maxHeight
            
            // Accumulate the delta values
            accumulatedDeltaX += normalizedDeltaX
            totalDeltaX += normalizedDeltaX // Tracks total motion
            
            //print("Normalized x: ", normalizedDeltaX, " y: ", normalizedDeltaY)
            
            // Determine the dominant direction of movement
            if abs(normalizedDeltaX) > abs(normalizedDeltaY) {
                if normalizedDeltaX > 0 {
                    //print("Moving right")
                    currentDirection = .x
                } else {
                    //print("Moving left")
                    currentDirection = .x
                }
            } else {
                if normalizedDeltaY > 0 {
                    //print("Moving up")
                    currentDirection = .y
                } else {
                    //print("Moving down")
                    currentDirection = .y
                }
            }
            
            // Handle gestures based on the number of active touches
            if activeTouches.count == 1 && currentDirection == .y {
                showLabels()
                viewModel.updateVolume(volumeDistance: normalizedDeltaY)
            }else if activeTouches.count == 1 && currentDirection == .x{
                showLabels()
            }else if activeTouches.count == 2 && currentDirection == .x{
                viewModel.updateFilterCutoff(cutoffDistance: normalizedDeltaX)
                showLabels()
            }else if activeTouches.count == 2 && currentDirection == .y{
                viewModel.updateComplexity(complexity: normalizedDeltaY)
                showLabels()
            }else if activeTouches.count == 3 && currentDirection == .y{
                viewModel.updateReverbAmount(revAmount: normalizedDeltaY)
                showLabels()
            }
            
            // Optional: Visualize or act on the touch
            visualiseTouch(at: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Remove ended touches from the dictionary
        if let touch = touches.first, activeTouches[touch] != nil {
            
            if activeTouches.count == 1{
                viewModel.updateFrequency(swipeDistance: totalDeltaX)
            }
            
           if viewModel.getCurrentNoteIndex() != currentIndex{
                currentIndex = viewModel.getCurrentNoteIndex()
                noteValueLabel.text = noteNames[currentIndex]
            }
            fadeOutLabels()
            accumulatedDeltaX = 0 // Reset for next gesture
            totalDeltaX = 0
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
        fadeOutLabels()
        printActiveFingers()
        
    }
    
    
    private func printActiveFingers() {
        print("Active fingers: \(activeTouches.count)")
    }
    
    
    //-----------------------------------------**Animations**-----------------------------------------------
    
    func visualiseTouch(at location: CGPoint) {
        let circle = SKShapeNode(circleOfRadius: 4)
        circle.position = location
        circle.fillColor = .cyan
        circle.alpha = 0.7
        addChild(circle)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        circle.run(SKAction.sequence([fadeOut, remove]))
    }
    
    
    func showLabels(){
        if activeTouches.count == 1 && currentDirection == .y {
            
            volumeValueLabel.text = viewModel.getCurrentVolumeAsString()
            volumeLabel.run(SKAction.fadeIn(withDuration: 0.8))
            volumeValueLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            //In the case that labels in the same position don't disappear fade them out here
            complexityLabel.run(SKAction.fadeOut(withDuration: 0.5))
            complexityValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            reverbLabel.run(SKAction.fadeOut(withDuration: 0.5))
            reverbValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            
        }else if activeTouches.count == 1 && currentDirection == .x{
            updateNoteLabel(steps: accumulatedDeltaX)
            
            //In the case that labels in the same position don't disappear fade them out here
            filterCutoffLabel.run(SKAction.fadeOut(withDuration: 0.5))
            filterCutoffValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            
        }else if activeTouches.count == 2 && currentDirection == .y{
            complexityValueLabel.text = viewModel.getComplexityAsString()
            complexityLabel.run(SKAction.fadeIn(withDuration: 0.8))
            complexityValueLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            //In the case that labels in the same position don't disappear fade them out here
            volumeLabel.run(SKAction.fadeOut(withDuration: 0.5))
            volumeValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            reverbLabel.run(SKAction.fadeOut(withDuration: 0.5))
            reverbValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            
        }else if activeTouches.count == 2 && currentDirection == .x{
            
            filterCutoffValueLabel.text = viewModel.getCurrentFilterCutoffAsString()
            filterCutoffLabel.run(SKAction.fadeIn(withDuration: 0.8))
            filterCutoffValueLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            //In the case that labels in the same position don't disappear fade them out here
            noteLabel.run(SKAction.fadeOut(withDuration: 0.5))
            noteValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
          
        }else if activeTouches.count == 3 && currentDirection == .y{
            
            reverbValueLabel.text = viewModel.getCurrentReverbAmountAsString()
            reverbLabel.run(SKAction.fadeIn(withDuration: 0.8))
            reverbValueLabel.run(SKAction.fadeIn(withDuration: 0.8))
            
            //In the case that labels in the same position don't disappear fade them out here
            complexityLabel.run(SKAction.fadeOut(withDuration: 0.5))
            complexityValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
            volumeLabel.run(SKAction.fadeOut(withDuration: 0.5))
            volumeValueLabel.run(SKAction.fadeOut(withDuration: 0.5))
        }
    }
    
    func fadeOutLabels(){

        noteLabel.run(SKAction.fadeOut(withDuration: 1.5))
        noteValueLabel.run(SKAction.fadeOut(withDuration: 1.5))
        volumeLabel.run(SKAction.fadeOut(withDuration: 1.5))
        volumeValueLabel.run(SKAction.fadeOut(withDuration: 1.5))
        filterCutoffLabel.run(SKAction.fadeOut(withDuration: 1.5))
        filterCutoffValueLabel.run(SKAction.fadeOut(withDuration: 1.5))
        reverbLabel.run(SKAction.fadeOut(withDuration: 1.5))
        reverbValueLabel.run(SKAction.fadeOut(withDuration: 1.5))
        complexityLabel.run(SKAction.fadeOut(withDuration: 1.5))
        complexityValueLabel.run(SKAction.fadeOut(withDuration: 1.5))
        
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
    
    
    
    //---------------------------***Labels, Text & Buttons ***-----------------------------------------------------------
    
    private func initLabels(){
        //-----------Labels on side----------------//
        
        if volumeLabel == nil{
            
            volumeLabel = SKLabelNode(text: "Volume:" )
            volumeLabel.fontName = "Avenir"
            volumeLabel.fontSize = 23
            volumeLabel.fontColor = .white
            volumeLabel.alpha = 0.0
            volumeLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
            addChild(volumeLabel)
            
            volumeValueLabel = SKLabelNode(text: "" )
            volumeValueLabel.fontName = "Avenir"
            volumeValueLabel.fontSize = 23
            volumeValueLabel.fontColor = .white
            volumeValueLabel.alpha = 0.0
            volumeValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
            addChild(volumeValueLabel)
        }
        
         if reverbLabel == nil{
             
             reverbLabel = SKLabelNode(text: "Reverb: ")
             reverbLabel.fontName = "Avenir"
             reverbLabel.fontSize = 24
             reverbLabel.fontColor = .white
             reverbLabel.alpha = 0.0
             reverbLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
             addChild(reverbLabel)
             
             reverbValueLabel = SKLabelNode(text: "")
             reverbValueLabel.fontName = "Avenir"
             reverbValueLabel.fontSize = 24
             reverbValueLabel.fontColor = .white
             reverbValueLabel.alpha = 0.0
             reverbValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
             addChild(reverbValueLabel)
         }
        
        if complexityLabel == nil{
            
            complexityLabel = SKLabelNode(text: "Complexity: ")
            complexityLabel.fontName = "Avenir"
            complexityLabel.fontSize = 24
            complexityLabel.fontColor = .white
            complexityLabel.alpha = 0.0
            complexityLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
            addChild(complexityLabel)
            
            complexityValueLabel = SKLabelNode(text: "")
            complexityValueLabel.fontName = "Avenir"
            complexityValueLabel.fontSize = 24
            complexityValueLabel.fontColor = .white
            complexityValueLabel.alpha = 0.0
            complexityValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
            addChild(complexityValueLabel)
        }
        
        
        //-------------------labels on top-------------//
         
         if noteLabel == nil{
             noteLabel = SKLabelNode(text: "Note: ")
             noteLabel.fontName = "Avenir"
             noteLabel.fontSize = 24
             noteLabel.fontColor = .white
             noteLabel.alpha = 0.0
             noteLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
             addChild(noteLabel)
             
             noteValueLabel = SKLabelNode(text: noteNames[0])
             noteValueLabel.fontName = "Avenir"
             noteValueLabel.fontSize = 24
             noteValueLabel.fontColor = .white
             noteValueLabel.alpha = 0.0
             noteValueLabel.position = CGPoint(x: size.width/2, y: size.height * 0.86)
             addChild(noteValueLabel)
         }
         
         if filterCutoffLabel == nil{
             filterCutoffLabel = SKLabelNode(text: "Filter Cutoff: ")
             filterCutoffLabel.fontName = "Avenir"
             filterCutoffLabel.fontSize = 24
             filterCutoffLabel.fontColor = .white
             filterCutoffLabel.alpha = 0.0
             filterCutoffLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
             addChild(filterCutoffLabel)
             
             filterCutoffValueLabel = SKLabelNode(text: "")
             filterCutoffValueLabel.fontName = "Avenir"
             filterCutoffValueLabel.fontSize = 24
             filterCutoffValueLabel.fontColor = .white
             filterCutoffValueLabel.alpha = 0.0
             filterCutoffValueLabel.position = CGPoint(x: size.width/2, y: size.height * 0.86)
             addChild(filterCutoffValueLabel)
             
         }
        
    }
    
    
    //little helper for Note Label
    func updateNoteLabel(steps: CGFloat) {
        
        
        
        let stepThreshold: CGFloat = 0.05 // Sensitivity threshold for updates

        // Process the accumulated delta if it exceeds the threshold
        guard abs(accumulatedDeltaX) >= stepThreshold  else{ return }

        let step = accumulatedDeltaX > 0 ? 1 : -1 // Determine direction
        let newIndex = currentIndex + step

        // Prevent updates if at the boundaries
        guard newIndex >= 0 && newIndex < noteNames.count else{
            accumulatedDeltaX -= stepThreshold * CGFloat(step) // Consume the delta even if at boundary
            return
            
        }
        // Update the note index and label
        currentIndex = newIndex
        noteValueLabel.text = noteNames[currentIndex]
            
        // Consume the processed delta
        accumulatedDeltaX -= stepThreshold * CGFloat(step)
            
        
        noteLabel.run(SKAction.fadeIn(withDuration: 0.5))
        noteValueLabel.run(SKAction.fadeIn(withDuration: 0.5))
        
    }
}
