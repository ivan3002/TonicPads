import Foundation

class SoundViewModel: ObservableObject {
    private var soundEngine = SoundEngine()

    func playSound() {
        soundEngine.startSound()
    }

    func stopSound() {
        soundEngine.stopSound()
    }

    func updateVolume(_ value: AUValue) {
        soundEngine.setVolume(value)
    }

    func updateFrequency(_ value: AUValue) {
        soundEngine.setFrequency(value)
    }
}
