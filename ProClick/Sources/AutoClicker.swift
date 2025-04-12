//
//  AutoClicker.swift
//  ProClick
//
//  Created by ChatGPT on behalf of user.
//

import Foundation
import AppKit

class AutoClicker {
    private var timer: Timer?
    private var clickInterval: TimeInterval = 0.01 // default 100 clicks per second

    func startClicking() {
        guard AXIsProcessTrusted() else {
            showAccessibilityAlert()
            return
        }

        stopClicking() // ensure no previous timers
        timer = Timer.scheduledTimer(timeInterval: clickInterval,
                                     target: self,
                                     selector: #selector(performClick),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopClicking() {
        timer?.invalidate()
        timer = nil
    }

    func setInterval(_ interval: TimeInterval) {
        clickInterval = interval
    }

    @objc private func performClick() {
        let loc = NSEvent.mouseLocation
        let point = CGPoint(x: loc.x, y: NSScreen.screens.first!.frame.height - loc.y)
        let clickDown = CGEvent(mouseEventSource: nil, 
                                mouseType: .leftMouseDown, 
                                mouseCursorPosition: point, 
                                mouseButton: .left)
        let clickUp = CGEvent(mouseEventSource: nil, 
                              mouseType: .leftMouseUp, 
                              mouseCursorPosition: point, 
                              mouseButton: .left)
        clickDown?.post(tap: .cghidEventTap)
        clickUp?.post(tap: .cghidEventTap)
    }

    private func showAccessibilityAlert() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Access Needed"
        alert.informativeText = "ProClick needs Accessibility permissions to simulate clicks. Go to System Settings → Privacy & Security → Accessibility and enable ProClick."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
