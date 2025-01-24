//
//  SpriteBackgroundScene.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import SpriteKit
import SwiftUI


//for dominant direction of swipes
enum Direction {
    case x
    case y
}

class MainPadsScene: SKScene {
    
    static let shared = MainPadsScene(size: UIScreen.main.bounds.size)
    //--------------------------------**INIT**------------------------------------------------------------------------------
    var viewModel: SoundViewModel!
    private var activeTouches: [UITouch: CGPoint] = [:] // Dictionary to track active touches and their locations
    private var volumeLabel: SKLabelNode!
    private var volumeValueLabel: SKLabelNode!
    
    private var noteLabel: SKLabelNode!
    private var noteValueLabel: SKLabelNode!
    
    //Array of note names to be displays
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
    
    //proportional movement values relative to the screen size
    private var normalisedDeltaX: CGFloat!
    private var normalisedDeltaY: CGFloat!
    
    private var accumulatedDeltaX: CGFloat = 0.0 // Tracks motion between updates
    private var totalDeltaX: CGFloat = 0.0       // Tracks total motion for the gesture
    
   
    private var currentDirection: Direction?
    
    
    
    override func didMove(to view: SKView) {
        
        // Setting the background color here
        
        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.3, alpha: 1.0)
        
    }
    
    //did this because size is initialising to 0,0 if done in didMove() for some reason therefore labels not appearing
    override func didChangeSize(_ oldSize: CGSize) {
        initLabels()
        
        // Add the particle emitter
        addParticleEmitter()
           
    }
    
    func addChildren(){
        initLabels()
        addParticleEmitter()
    }

    func addParticleEmitter() {
        if let particleEmitter = SKEmitterNode(fileNamed: "MainBackground.sks") {
        particleEmitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        particleEmitter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        particleEmitter.zPosition = -1 //bottom position on screen
        addChild(particleEmitter)
        }
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
        handleGestures(touches: touches)
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
        
        //removes touch points from dictionary
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
            
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Remove cancelled touches from the dictionary
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        fadeOutLabels()
        
    }
    
    //below are some helper functions for touch functionality
    
    private func determineGestureDirection(deltaX: CGFloat, deltaY: CGFloat) -> Direction {
        return abs(deltaX) > abs(deltaY) ? .x : .y
    }
    
    func handleGestures(touches: Set<UITouch>){
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            // Calculate deltas
            let deltaX = location.x - previousLocation.x
            let deltaY = location.y - previousLocation.y
            
            // normalise deltas
            normalisedDeltaX = deltaX / size.width
            normalisedDeltaY = deltaY / size.height
            
           
            accumulatedDeltaX += normalisedDeltaX
            totalDeltaX += normalisedDeltaX
            
            // Determine direction
            currentDirection = determineGestureDirection(deltaX: normalisedDeltaX, deltaY: normalisedDeltaY)
            
            // actions based on touches and direction
            switch (activeTouches.count, currentDirection) {
            case (1, .y):
                showLabels()
                viewModel.updateVolume(volumeDistance: normalisedDeltaY)
            case (1, .x):
                showLabels()
            case (2, .x):
                viewModel.updateFilterCutoff(cutoffDistance: normalisedDeltaX)
                showLabels()
            case (2, .y):
                viewModel.updateComplexity(complexity: normalisedDeltaY)
                showLabels()
            case (3, .y):
                viewModel.updateReverbAmount(revAmount: normalisedDeltaY)
                showLabels()
            default:
                break
            }
            
            // Visualise the touch - (circles appear on screen)
            visualiseTouch(at: location)
        }
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
    
    
    //---------------------------***Labels, Text & Buttons ***-----------------------------------------------------------
    
    private func initLabels(){
        //-----------Labels on side----------------//
        
        if volumeLabel == nil{
            
            volumeLabel = SKLabelNode(text: "Volume:" )
            volumeLabel.fontName = ""
            volumeLabel.fontSize = 26
            volumeLabel.fontColor = .white
            volumeLabel.alpha = 0.0
            volumeLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
            volumeLabel.zPosition = 10
            addChild(volumeLabel)
            //print("hey")
            
            volumeValueLabel = SKLabelNode(text: "" )
            volumeValueLabel.fontName = "Raleway Extra Bold"
            volumeValueLabel.fontSize = 26
            volumeValueLabel.fontColor = .white
            volumeValueLabel.alpha = 0.0
            volumeValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
            addChild(volumeValueLabel)
        }
        
         if reverbLabel == nil{
             
             reverbLabel = SKLabelNode(text: "Reverb: ")
             reverbLabel.fontName = "Raleway Extra Bold"
             reverbLabel.fontSize = 26
             reverbLabel.fontColor = .white
             reverbLabel.alpha = 0.0
             reverbLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
             addChild(reverbLabel)
             
             reverbValueLabel = SKLabelNode(text: "")
             reverbValueLabel.fontName = "Raleway Extra Bold"
             reverbValueLabel.fontSize = 26
             reverbValueLabel.fontColor = .white
             reverbValueLabel.alpha = 0.0
             reverbValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
             addChild(reverbValueLabel)
         }
        
        if complexityLabel == nil{
            
            complexityLabel = SKLabelNode(text: "Complexity: ")
            complexityLabel.fontName = "Raleway Extra Bold"
            complexityLabel.fontSize = 26
            complexityLabel.fontColor = .white
            complexityLabel.alpha = 0.0
            complexityLabel.position = CGPoint(x: size.width * 0.09, y: size.height/2)
            addChild(complexityLabel)
            
            complexityValueLabel = SKLabelNode(text: "")
            complexityValueLabel.fontName = "Raleway Extra Bold"
            complexityValueLabel.fontSize = 26
            complexityValueLabel.fontColor = .white
            complexityValueLabel.alpha = 0.0
            complexityValueLabel.position = CGPoint(x: size.width * 0.09, y: size.height * 0.47)
            addChild(complexityValueLabel)
        }
        
        
        //-------------------labels on top-------------//
         
         if noteLabel == nil{
             noteLabel = SKLabelNode(text: "Note: ")
             noteLabel.fontName = "Raleway Extra Bold"
             noteLabel.fontSize = 26
             noteLabel.fontColor = .white
             noteLabel.alpha = 0.0
             noteLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
             addChild(noteLabel)
             
             noteValueLabel = SKLabelNode(text: noteNames[0])
             noteValueLabel.fontName = "Raleway Extra Bold"
             noteValueLabel.fontSize = 26
             noteValueLabel.fontColor = .white
             noteValueLabel.alpha = 0.0
             noteValueLabel.position = CGPoint(x: size.width/2, y: size.height * 0.86)
             addChild(noteValueLabel)
         }
         
         if filterCutoffLabel == nil{
             filterCutoffLabel = SKLabelNode(text: "Filter Cutoff(Hz): ")
             filterCutoffLabel.fontName = "Raleway Extra Bold"
             filterCutoffLabel.fontSize = 26
             filterCutoffLabel.fontColor = .white
             filterCutoffLabel.alpha = 0.0
             filterCutoffLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
             addChild(filterCutoffLabel)
             
             filterCutoffValueLabel = SKLabelNode(text: "")
             filterCutoffValueLabel.fontName = "Raleway Extra Bold"
             filterCutoffValueLabel.fontSize = 26
             filterCutoffValueLabel.fontColor = .white
             filterCutoffValueLabel.alpha = 1.0
             filterCutoffValueLabel.position = CGPoint(x: size.width/2, y: size.height * 0.86)
             addChild(filterCutoffValueLabel)
             
         }
        
    }
    
    
    //little helper for Note Label since this needs update continously even though frequency isn't selected until touchesEnded() is called
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

