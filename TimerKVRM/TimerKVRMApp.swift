import SwiftUI

@main
struct TimerKVRMApp: App {
    @StateObject private var vm = TimerViewModel(sound: SoundService())

    var body: some Scene {
        WindowGroup("Таймер") {
            ContentView()
                .environmentObject(vm)
                .frame(minWidth: 250, maxWidth: 250, minHeight: 350, maxHeight: 350)
                .onAppear {
                    WindowLevelAccessor.setAlwaysOnTop(.floating)
                }
        }
        .defaultSize(width: 250, height: 350)
    }
}
