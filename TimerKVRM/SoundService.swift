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

    // Имена файлов — положите в Assets или просто в Bundle
    // и замените расширения/имена под ваши ресурсы:
    private let startName = "start"              // Resources.start
    private let breakName = "bBreak"             // Resources.bBreak
    private let tenName = "tenSeconds"           // Resources.tenSeconds
    private let finalName = "finialCountdown"    // Resources.finialCountdown (орфография как в коде)
    private let warningName = "finalWarning"     // Resources.finalWarning
    private let ext = "wav"                      // или "mp3" — подставьте актуальное

    private func play(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            players.append(p) // держим сильную ссылку, иначе звук может оборваться
        } catch {
            // можно добавить простое логирование в консоль
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
