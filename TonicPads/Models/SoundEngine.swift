//
//  SoundEngine.swift
//  TonicPads
//
//  Created by Ivan Agyapong on 13/12/2024.
//

import Foundation
import AudioKit


class SoundEngine{
    
    private var volume: Double
    
    init(vol: Double) {
        self.volume = vol
    }

    func startEngine(){}
    func stopEngine(){}
    func setAttack(){}
    func setDecay(){}
    func setVolume(){}
    func setComplexity(){}
    func setLowpassCutoff(){}
    
};
