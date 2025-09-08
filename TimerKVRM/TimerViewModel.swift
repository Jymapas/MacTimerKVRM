import Foundation
import SwiftUI
import Combine

final class TimerViewModel: ObservableObject {

    // Константы как в WPF
    private let questionTotal = 60
    private let dupletSeg = 30
    private let blitzSeg = 20
    private let blitzCount = 3
    private let finalTotal = 10

    enum Mode { case none, question, duplet, blitz, final }

    private let sound: SoundServiceProtocol
    private var timer: Timer?
    private var mode: Mode = .none
    private var segmentIndex = 0
    private var segmentRemaining = 0
    private var segmentsCount = 0
    private var waitingNextSegment = false

    @Published var timerText: String = "60"
    @Published var timerColor: Color = .black

    private(set) var totalRemaining = 60 {
        didSet { timerText = "\(totalRemaining)" }
    }

    init(sound: SoundServiceProtocol) {
        self.sound = sound
        resetToIdle()
    }

    // MARK: — Public API (аналог команд)

    var isRunning: Bool { timer != nil }

    var canStartQuestion: Bool {
        !isRunning && !waitingNextSegment && mode == .none
    }

    var canStartDupletOrContinue: Bool {
        !isRunning && ((mode == .none && !waitingNextSegment) || (mode == .duplet && waitingNextSegment))
    }

    var canStartBlitzOrContinue: Bool {
        !isRunning && ((mode == .none && !waitingNextSegment) || (mode == .blitz && waitingNextSegment && segmentIndex < blitzCount))
    }

    var canStop: Bool {
        isRunning || mode == .final || waitingNextSegment
    }

    func startQuestion() {
        guard canStartQuestion else { return }
        sound.playStart()
        mode = .question
        totalRemaining = questionTotal
        segmentsCount = 1
        segmentIndex = 0
        segmentRemaining = questionTotal
        timerColor = .black
        startTimer()
    }

    func startDupletOrContinue() {
        guard canStartDupletOrContinue else { return }
        sound.playStart()
        if mode == .none {
            mode = .duplet
            totalRemaining = dupletSeg * 2
            segmentsCount = 2
            segmentIndex = 0
        } else {
            segmentIndex += 1
        }
        waitingNextSegment = false
        segmentRemaining = dupletSeg
        timerColor = .black
        startTimer()
    }

    func startBlitzOrContinue() {
        guard canStartBlitzOrContinue else { return }
        sound.playStart()
        if mode == .none {
            mode = .blitz
            totalRemaining = blitzSeg * blitzCount
            segmentsCount = blitzCount
            segmentIndex = 0
        } else {
            segmentIndex += 1
        }
        waitingNextSegment = false
        segmentRemaining = blitzSeg
        timerColor = .black
        startTimer()
    }

    func stop() {
        sound.stopAll()
        stopTimer()
        resetToIdle()
    }

    // MARK: — Timer

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.onTick()
        }
        RunLoop.main.add(timer!, forMode: .common)
        objectWillChange.send()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        objectWillChange.send()
    }

    private func onTick() {
        guard mode != .none else { return }

        if mode != .final {
            totalRemaining -= 1
            segmentRemaining -= 1

            if totalRemaining == 11 {
                sound.playTenSeconds()
            }

            if segmentRemaining != 0 {
                return
            }

            stopTimer()

            if totalRemaining == 0 {
                beginFinalCountdown()
            } else {
                waitingNextSegment = true
                sound.playBreak()
            }
        } else {
            totalRemaining -= 1
            if totalRemaining != 0 {
                return
            }
            stop()
            sound.playFinalWarning()
        }
    }

    private func beginFinalCountdown() {
        mode = .final
        totalRemaining = finalTotal
        timerColor = .red
        sound.playFinal()
        startTimer()
    }

    private func resetToIdle() {
        mode = .none
        waitingNextSegment = false
        totalRemaining = questionTotal
        segmentRemaining = 0
        segmentIndex = 0
        segmentsCount = 0
        timerColor = .black
        timerText = "60"
    }
}
