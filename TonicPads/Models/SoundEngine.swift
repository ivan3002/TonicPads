//
//  SoundEngine.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit
import DunneAudioKit

class SoundEngine {
    
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
    
    let twelveTETIntervals: [Float] = [
        1.0, //root
        pow(2.0, 7.0 / 12.0),  // Perfect 5th
        pow(2.0, 14.0 / 12.0), // Major 9th
        pow(2.0, 2.0 / 12.0),  // Major 2nd
        pow(2.0, 9.0 / 12.0),  // Major 6th
        pow(2.0, -12.0 / 12.0) // Sub-Octave
        
        
    ]
    
    
    var envelope: AmplitudeEnvelope
    var engineInstance = AudioEngine()
    
    var volume: AUValue = 0.1
    private var frequency: AUValue = 261.63
    
    
    var oscillators: [MorphingOscillator]
    var waveforms: Table
    var reverb: CostelloReverb
    var chorus: Chorus
    var chorusAmount: AUValue = 0
    var flanger: Flanger
    var flangeAmount: AUValue = 0
    var attack: AUValue = 0.5
    var release: AUValue = 0.5
    
    var lowPass: LowPassButterworthFilter
    var cutoff: AUValue = 0
    
    var dryWetMix: AUValue = 0.5
    
    let drySignal: Mixer
    let wetSignal: Mixer
    let finalMix: Mixer
    
    var complexity = 0.0
    
    init() {
        
        
        waveforms = Table()
        waveforms.square(harmonicCount: 10, clear: true)
        oscillators = []
        
        // Initialize 6 oscillators
        for _ in 0..<6 {
            let osc = MorphingOscillator()
            
            //waveformArray: [Table] = [Table(.triangle), Table(.square), Table(.sine), Table(.sawtooth)]
            osc.index = AUValue(3)
            
            osc.frequency = frequency
            
            
            
            osc.detuningOffset = AUValue(0)
            osc.detuningMultiplier = AUValue(1)
            
            // Store the oscillator in the array
            oscillators.append(osc)
        }
        
        
        oscillators[0].amplitude = volume
        oscillators[1].amplitude = 0
        oscillators[2].amplitude = 0
        oscillators[3].amplitude = 0
        oscillators[4].amplitude = 0
        oscillators[5].amplitude = 0
       // print("Initial root frequency: \(frequency) Hz")
        //print("Oscillator[0] frequency: \(oscillators[0].frequency) Hz")
        
        let mixer = Mixer(oscillators)
        
        chorus = Chorus(mixer, frequency: 0.2, depth: 0.4, feedback: 0, dryWetMix: chorusAmount)
        lowPass = LowPassButterworthFilter(chorus, cutoffFrequency: 1000)
        flanger = Flanger(lowPass,frequency: 0.2, depth: 0.8, feedback: 0.8, dryWetMix: flangeAmount)
        
        
        
        
        reverb = CostelloReverb(lowPass, feedback: 0.9, cutoffFrequency: 7000)
        
        
        drySignal = Mixer(flanger) // Unprocessed signal
        wetSignal = Mixer(reverb) // Processed signal
        finalMix = Mixer(drySignal, wetSignal) // Combine both signals
        
        envelope = AmplitudeEnvelope(finalMix)
        envelope.attackDuration = AUValue(attack)
        envelope.sustainLevel = 1
        envelope.decayDuration = 0.1
        envelope.releaseDuration = AUValue(release)
        
        engineInstance.output = envelope
        
    
        
        setOscIntervals()
        
        print("SoundEngine setup complete.")
    }
    
    
    func setOscIntervals(){
        // chooses the interval set based on the current tuning system
        let intervals = twelveTETIntervals
        // Update each oscillator's frequency based on the intervals
        for (index, interval) in intervals.enumerated() {
            if index > 0 && index < oscillators.count {
                // Set oscillator frequency to the base frequency * interval
                oscillators[index].frequency = oscillators[0].frequency * interval
            }
        }
        
    }
    

    func startSound() {
        print("start: ", attack)
        envelope.attackDuration = attack
        envelope.releaseDuration = release
        oscillators.forEach{$0.start()}
        do {
            try engineInstance.start()
            print("Audio engine started.")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
        envelope.openGate()
        
    }
    
    func stopSound() {
        envelope.closeGate() // Trigger the release phase
        sleep(4)
        self.oscillators.forEach { $0.stop() }
        self.engineInstance.stop()
        print("Audio engine stopped.")
       
        
    }
    
    func setVolume(v: CGFloat) {
        // Clamp the new volume to the range [0.0, 0.5]
        let newVolume = min(max(volume + AUValue(v), 0.0), 0.5)
        
        // Update the root oscillator's amplitude
        oscillators[0].amplitude = AUValue(newVolume)
        
        // Define a scale factor for the other oscillators
        let scaleFactor: AUValue = 0.8 // Adjust this to control harmonic amplitude scaling
        
        // Update the amplitudes of the other oscillators
        for (index, oscillator) in oscillators.enumerated() {
            if index > 0 {
                // Only scale if the oscillator's amplitude is greater than 0 and ensure it doesn't exceed the root note
                if oscillator.amplitude > 0.0 {
                    let scaledAmplitude = newVolume * scaleFactor
                    oscillator.amplitude = min(scaledAmplitude, newVolume) // Clamp to root note's volume
                    //print("Oscillator[\(index)] Amplitude: \(oscillator.amplitude)")
                } else {
                    // Oscillator amplitude remains 0 if it was initially 0
                    //print("Oscillator[\(index)] Amplitude remains: 0.0")
                }
            }
        }
        
        // Update the stored volume
        volume = newVolume
    }
    
    func setFrequency(f: AUValue){
        // Predefined frequencies for the 12 notes in the chromatic scale (starting from A4 = 440 Hz)
        //oscillators.forEach{$0.frequency = f}
        oscillators[0].frequency = f
        setOscIntervals()
    }
    
    func setCutoff(lopass: CGFloat){
        lowPass.cutoffFrequency = AUValue(lopass)
        cutoff = AUValue(lopass)
    }
    
    func setDryWetMix(dry: AUValue, wet: AUValue) {
        drySignal.volume = dry
        wetSignal.volume = wet
        dryWetMix = wet // Keep track of wet level for debugging
        //print("Dry/Wet Mix - Dry: \(dry), Wet: \(wet)")
    }
    
    func setReverb(dryWet:AUValue){
        //reverb.feedback = reverbAmount
        let dry = 1.0 - dryWet
        let wet = dryWet
        setDryWetMix(dry: dry, wet: wet)
    }
    
    private func updateModulationEffects(c: CGFloat) {
        let chorusCoef = min(max(chorusAmount + AUValue(c), 0.0), 0.5)
        let flangeCoef = min(max(flangeAmount + AUValue(c), 0.0), 0.8)
        
        // Update modulation effects
        chorusAmount = chorusCoef
        flangeAmount = flangeCoef
        chorus.dryWetMix = AUValue(chorusCoef)
        flanger.dryWetMix = AUValue(flangeCoef)
    }
    
    //---------------COMPLEXITY IMPLEMENTATION----------------------------------------//
    
    //helper function for increasing the level of each note in a chord as complexity increases
    func increaseNoteLevels(by: CGFloat){
        for (index, oscillator) in oscillators.enumerated() {
            if index == 0 {
                // Root oscillator remains at fixed volume
                oscillator.amplitude = volume
            } else {
                // Check if the previous oscillator has reached its max amplitude
                if oscillators[index - 1].amplitude == volume {
                    // Incrementally increase this oscillator's amplitude
                    let newHarmVolume = min(max(oscillator.amplitude + AUValue(by), 0.0), volume)
                    oscillator.amplitude = newHarmVolume
                    
                    //print("Oscillator[\(index)] Amplitude: \(oscillator.amplitude)")
                    
                    // Stop introducing new harmonics if this one isn't maxed out
                    if oscillator.amplitude < volume {
                        break
                    }
                }
            }
        }
    }
    
    //helper function for decreasing the level of each note in a chord as complexity decreases
    func decreaseNoteLevels(by: CGFloat){
        for (index, oscillator) in oscillators.enumerated().reversed() {
            if index == 0 {
                // Root oscillator remains at fixed volume
                oscillator.amplitude = volume
            } else {
                                    // Decrease the amplitude of the previous oscillator
                let newHarmVolumeDec = max(oscillator.amplitude + AUValue(by), 0.0) //adding because negative value
                oscillator.amplitude = newHarmVolumeDec
                
                //print("Oscillator[\(index)] Amplitude (Decreasing): \(oscillator.amplitude)")
                
                // Stop removing notes if this one isn't fully off
                if oscillator.amplitude > 0.0 {
                    break
                    }
                }
            }
        }
    
    
    func complexityAlg(complexityValue: CGFloat) {
        complexity = min(max(complexity + (complexityValue),0.0), 1.0)
        updateModulationEffects(c: complexityValue)
    
        // Base volume step for each harmonic (scaled by complexity)
        let harmonicStep = complexityValue  // Adjust scaling as needed
        print(harmonicStep)
        
        if harmonicStep>0 {
            increaseNoteLevels(by: harmonicStep)
        }else {
            decreaseNoteLevels(by: harmonicStep)
            // Removing notes (decreasing complexity)
            
        }
  
    }
}


