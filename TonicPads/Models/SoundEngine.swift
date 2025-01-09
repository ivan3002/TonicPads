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
    private var volume: AUValue = 0.1
    private var frequency: AUValue = 444.0
    private var wetDry: AUValue = 0.5 // Default to a mix
    var engineInstance: AudioEngine
    var basicOscillator: Oscillator
    var waveforms: Table
    var reverb: Reverb

    init() {
        waveforms = Table()
        waveforms.square(harmonicCount: 15, clear: true)
        engineInstance = AudioEngine()
        basicOscillator = Oscillator(waveform: waveforms)
        reverb = Reverb(basicOscillator, dryWetMix: wetDry)

        basicOscillator.amplitude = volume
        basicOscillator.frequency = frequency
        setupEngine()
    }

    private func setupEngine() {
        engineInstance.output = reverb
        print("SoundEngine setup complete.")
    }

    func startSound() {
        basicOscillator.start()

        do {
            try engineInstance.start()
            print("Audio engine started.")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        engineInstance.stop()
        print("Audio engine stopped.")
    }

    func setVolume(v: CGFloat) {
       
        let newVolume = min(max(volume + Float(v), 0.0), 1.0)
        basicOscillator.amplitude = AUValue(newVolume)
        volume = newVolume
        print("Amplitude set to: \(basicOscillator.amplitude)")
    }
    
    func setFrequency(f: AUValue){
        // Predefined frequencies for the 12 notes in the chromatic scale (starting from A4 = 440 Hz)
        basicOscillator.frequency = f
    }
}
