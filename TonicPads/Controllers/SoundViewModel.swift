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

    func updateVolume( value: CGFloat) {
        soundEngine.setVolume(v: value)
    }

    func updateFrequency(swipeDistance: CGFloat) {
        print(swipeDistance)
        let chromaticScale: [Float] = [
            261.63, // C4
            277.18, // C#4/Db4
            293.66, // D4
            311.13, // D#4/Eb4
            329.63, // E4
            349.23, // F4
            369.99, // F#4/Gb4
            392.00, // G4
            415.30, // G#4/Ab4
            440.00, // A4
            466.16, // A#4/Bb4
            493.88,  // B4
            523.25 //C5
        ]
        
        let dxRange: CGFloat = 65 // Define sensitivity for a full note step
          let steps = Int(swipeDistance / dxRange) // Calculate steps from swipe distance
          
          // Calculate the potential new index
          var newNoteIndex = currentNoteIndex + steps

          // Clamp the index to stay within valid bounds
          if newNoteIndex < 0 {
              newNoteIndex = 0 // Stay at the lowest note (C4)
          } else if newNoteIndex >= chromaticScale.count {
              newNoteIndex = chromaticScale.count - 1 // Stay at the highest note (B4)
          }

          // Update only if the index actually changes
          if newNoteIndex != currentNoteIndex {
              currentNoteIndex = newNoteIndex
              let frequency = chromaticScale[currentNoteIndex]

              // Update the sound engine or oscillator with the new frequency
              print("Swipe distance: \(swipeDistance), New Frequency: \(frequency) Hz (Note index: \(currentNoteIndex))")
              soundEngine.setFrequency(f: AUValue(frequency))
          } else {
              print("Swipe distance: \(swipeDistance), Frequency unchanged (Note index: \(currentNoteIndex))")
          }
      }
    
}
