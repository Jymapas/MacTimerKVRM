import Foundation
import AVFoundation

protocol SoundServiceProtocol {
    func playStart()
    func playBreak()
    func playTenSeconds()
    func playFinal()
    func playFinalWarning()
    func stopAll()
}

final class SoundService: SoundServiceProtocol {
    private var players: [AVAudioPlayer] = []

    private let startName = "start"
    private let breakName = "break"
    private let tenName = "tenSeconds"
    private let finalName = "finialCountdown"
    private let warningName = "finalWarning"
    private let ext = "wav"

    private func play(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            players.append(p) // держим сильную ссылку, иначе звук может оборваться
        } catch {
        }
    }

    func playStart() { play(startName) }
    func playBreak() { play(breakName) }
    func playTenSeconds() { play(tenName) }
    func playFinal() { play(finalName) }
    func playFinalWarning() { play(warningName) }

    func stopAll() {
        players.forEach { $0.stop() }
        players.removeAll()
    }
}
