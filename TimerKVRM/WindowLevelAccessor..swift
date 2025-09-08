import AppKit

enum WindowLevelAccessor {
    static func setAlwaysOnTop(_ level: NSWindow.Level) {
        // Первый активный NSWindow группы
        if let window = NSApp.windows.first {
            window.level = level
        }
    }
}
