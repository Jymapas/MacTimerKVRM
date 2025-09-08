import AppKit

enum WindowLevelAccessor {
    static func setAlwaysOnTop(_ level: NSWindow.Level) {
        if let window = NSApp.windows.first {
            window.level = level
        }
    }
}
