//
//  SoundEngine.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit


class SoundEngine{
    
    private var volume: AUValue = 0.5
    private var frequency: AUValue = 444.0
    var engineInstance: AudioEngine
    var basicOscillator: Oscillator
    var waveforms: Table
    
    init() {
        // Initialize the AudioKit engine
        waveforms = Table()
        waveforms.square(harmonicCount: 15,clear: true)
        engineInstance = AudioEngine()
        basicOscillator = Oscillator(waveform: waveforms)
        basicOscillator.amplitude = volume
        basicOscillator.frequency = frequency
        setupEngine()
    }
    
    private func setupEngine() {
        // Add sound components here, e.g., oscillators or players
        // For now, placeholder setup
        engineInstance.output = basicOscillator
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
    
    
    func setVolume(){}
    func setComplexity(){}
    func setLowpassCutoff(){}
    
};
