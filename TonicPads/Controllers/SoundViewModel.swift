//
//  SoundViewModel.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 07/01/2025.
//


import Foundation
import AudioKit

class SoundViewModel: ObservableObject {

    
    var mainPadsScene: MainPadsScene?
    var currentNoteIndex: Int = 0
    private var soundEngine = SoundEngine()
    
    func playSound() {
        soundEngine.startSound()
    }
    
    func stopSound() {
        soundEngine.stopSound()
    }
    
    func updateVolume( volumeDistance: CGFloat) {
        soundEngine.setVolume(v: volumeDistance)
    }
    
    func updateFrequency(swipeDistance: CGFloat) {
        print(swipeDistance)
        
        
        let dxRange: CGFloat = 0.05 // Define sensitivity for a full note step
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
            //print("Swipe distance: \(swipeDistance), New Frequency: \(frequency) Hz (Note index: \(currentNoteIndex))")
            soundEngine.setFrequency(f: AUValue(frequency))
        } else {
            //print("Swipe distance: \(swipeDistance), Frequency unchanged (Note index: \(currentNoteIndex))")
        }
    }
    
    func updateFilterCutoff(cutoffDistance: CGFloat) {
        //input cutoffDistance will be between -1 and 1
        // Define the cutoff range
        let minCutoff: CGFloat = 50      // 50 Hz
        let maxCutoff: CGFloat = 20000  // 20 kHz
        
        //let minLog = log10(minCutoff)
        //let maxLog = log10(maxCutoff)
        //let normalizedDistance = (cutoffDistance + 1) / 2  // Maps -1 -> 0, 0 -> 0.5, 1 -> 1
        
        // Scale the cutoffDistance to a meaningful range for frequency adjustment
        let cutoffChange = cutoffDistance * 8000 // Adjust scaling factor to control sensitivity
        
        // Update the frequency based on the last value
        var newFrequency = soundEngine.lowPass.cutoffFrequency + AUValue(cutoffChange)
        
        // Clamp the frequency to stay within the allowable range
        newFrequency = min(max(newFrequency, AUValue(minCutoff)), AUValue(maxCutoff))
        
        // Update the last frequency for the next iteration
        soundEngine.lowPass.cutoffFrequency = newFrequency
        
        // Set the new cutoff frequency in the sound engine
        soundEngine.setCutoff(lopass: CGFloat(newFrequency))
        
        //print("CutoffDistance: \(cutoffDistance), New Frequency: \(newFrequency) Hz")
    }
    
    func updateReverbAmount(revAmount: CGFloat){
        //let minAmount: CGFloat = 0.9
        //let maxAmount: CGFloat = 0.9
        let dry: CGFloat = 0.0
        let wet: CGFloat = 1.0
        
        //var newRevAmount = soundEngine.reverb.feedback + AUValue(revAmount)
        // newRevAmount = min(max(newRevAmount, AUValue(minAmount)), AUValue(maxAmount))
        
        var newDryWet = soundEngine.dryWetMix + AUValue(revAmount)
        newDryWet = min(max(newDryWet, AUValue(dry)), AUValue(wet))
        
        //soundEngine.reverb.feedback = newRevAmount
        soundEngine.dryWetMix = newDryWet
        
        soundEngine.setReverb(dryWet: newDryWet )
        
    }
    
    func updateComplexity(complexity: CGFloat){
        
        soundEngine.complexityAlg(c: complexity)
    }
    
    func setStartAttack(attack: Double) {
       soundEngine.attack = AUValue(attack)
        print(attack)
       }
       
   func setStopRelease(release: Double) {
       soundEngine.release = AUValue(release)
       }
       
   func setjustIntonation(isOn: Bool) {
       soundEngine.istwelveTET = isOn
       soundEngine.setOscIntervals()
           
       }
    
    //---------------------------------------**Getters**-----------------------------------------------------------------------------
    func getCurrentNoteIndex() -> Int {
        return currentNoteIndex
    }
    
    func getCurrentVolumeAsString() -> String {
        let v = soundEngine.volume
        let volu = Int(ceil(v * 20))
        return String(volu)
    }
    
    func getCurrentReverbAmountAsString() -> String {
        let r = soundEngine.dryWetMix
        let rev = round(r * 10) / 10.0
        return String(rev)
    }
        
    func getCurrentFilterCutoffAsString() -> String {
            let fil = soundEngine.cutoff
            let filRound = Int(ceil(fil))
            return String(filRound)
    }
    func getComplexityAsString() -> String{
        let complex = soundEngine.complexity
        
        let complexRound = ceil(complex * 100)
        return String(complexRound)
    }
    func getTwelveTET()->Bool{
        return soundEngine.istwelveTET
    }
    
    
    func getAttack() -> AUValue{
        
        return soundEngine.attack
    }
    
    func getRelease()-> AUValue{
        
        return soundEngine.release
    }
        
}
