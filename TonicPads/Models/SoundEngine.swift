//
//  SoundEngine.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit

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
    
    var engineInstance = AudioEngine()
    
    private var volume: AUValue = 0.1
    private var frequency: AUValue = 261.63
    private var wetDry: AUValue = 1 // Default to a mix
    
    var oscillators: [Oscillator]
    var waveforms: Table
    var reverb: Reverb

    init() {
        waveforms = Table()
        waveforms.square(harmonicCount: 7, clear: true)
        oscillators = []
        
        // Initialize 6 oscillators
        for _ in 0..<6 {
            let osc = Oscillator(waveform: waveforms)
            osc.amplitude = volume
            osc.frequency = frequency
            oscillators.append(osc)
        }
        
        let mixer = Mixer(oscillators)
        reverb = Reverb(mixer, dryWetMix: wetDry)

        engineInstance.output = reverb
        print("SoundEngine setup complete.")
    }


    func startSound() {
        oscillators.forEach{$0.start()}
        do {
            try engineInstance.start()
            print("Audio engine started.")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        oscillators.forEach { $0.stop() }
        engineInstance.stop()
        print("Audio engine stopped.")
    }

    func setVolume(v: CGFloat) {
       
        let newVolume = min(max(volume + Float(v), 0.0), 1.0)
        oscillators.forEach{$0.amplitude = AUValue(newVolume)}
        volume = newVolume
        //print("Amplitude set to: \(oscillators.amplitude)")
    }
    
    func setFrequency(f: AUValue){
        // Predefined frequencies for the 12 notes in the chromatic scale (starting from A4 = 440 Hz)
        oscillators.forEach{$0.frequency = f}
    }
}
