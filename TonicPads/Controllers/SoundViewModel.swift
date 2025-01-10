//
//  SoundViewModel.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 07/01/2025.
//


import Foundation
import AudioKit

class SoundViewModel: ObservableObject {
    var currentNoteIndex: Int = 0
    private var soundEngine = SoundEngine()

    func playSound() {
        soundEngine.startSound()
    }

    func stopSound() {
        soundEngine.stopSound()
    }

    func updateVolume( volumeDistance: CGFloat) {
        soundEngine.setVolume(v: volumeDistance/460)
    }

    func updateFrequency(swipeDistance: CGFloat) {
        print(swipeDistance)
        
        
        let dxRange: CGFloat = 65 // Define sensitivity for a full note step
          let steps = Int(swipeDistance / dxRange) // Calculate steps from swipe distance
          
          // Calculate the potential new index
          var newNoteIndex = currentNoteIndex + steps

          // Clamp the index to stay within valid bounds
          if newNoteIndex < 0 {
              newNoteIndex = 0 // Stay at the lowest note (C4)
          } else if newNoteIndex >= soundEngine.chromaticScale.count {
              newNoteIndex = soundEngine.chromaticScale.count - 1 // Stay at the highest note (B4)
          }

          // Update only if the index actually changes
          if newNoteIndex != currentNoteIndex {
              currentNoteIndex = newNoteIndex
              let frequency = soundEngine.chromaticScale[currentNoteIndex]

              // Update the sound engine or oscillator with the new frequency
              print("Swipe distance: \(swipeDistance), New Frequency: \(frequency) Hz (Note index: \(currentNoteIndex))")
              soundEngine.setFrequency(f: AUValue(frequency))
          } else {
              print("Swipe distance: \(swipeDistance), Frequency unchanged (Note index: \(currentNoteIndex))")
          }
      }
    
}
