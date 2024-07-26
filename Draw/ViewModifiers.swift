//
//  ViewModifiers.swift
//  Draw
//
//  Created by Rishi Jansari on 24/07/2024.
//

import SwiftUI

extension View {
    func undo(data: DrawController) -> some View {
        modifier(Undo(data:data))
    }
    func redo(data: DrawController) -> some View {
        modifier(Redo(data:data))
    }
    func clear(data: DrawController) -> some View {
        modifier(Clear(data:data))
    }
    func settingsToggle(settingsShown: Binding<Bool>) -> some View {
        modifier(ToggleSettings(settingsShown: settingsShown))
    }
}

struct Undo: ViewModifier {
    @Bindable var data: DrawController
    
    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2) {
                action()
            }
    }
    
    func action() {
        withAnimation(.easeInOut(duration: 3)) {
            guard let lastLine = data.lines.last else { return }
            data.lastLines.append(lastLine)
            data.lines.removeLast()
        }
        data.save("Lines", "Lastlines")
    }
}

struct Redo: ViewModifier {
    @Bindable var data: DrawController
    
    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 3) {
                action()
            }
    }
    
    func action() {
        withAnimation(.easeInOut(duration: 3)) {
            guard let lastUndoneLine = data.lastLines.last else { return }
            data.lines.append(lastUndoneLine)
            data.lastLines.removeLast()
        }
        data.save("Lines", "Lastlines")
    }
}

struct Clear: ViewModifier {
    @Bindable var data: DrawController
    
    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 10) {
                withAnimation(.easeInOut(duration: 3)) {
                    data.lines.removeAll()
                    data.lastLines.removeAll()
                }
                data.save("Lines", "Lastlines")
            }
    }
}

struct ToggleSettings: ViewModifier {
    @Binding var settingsShown: Bool
    
    func body(content: Content) -> some View {
        content
            .onLongPressGesture(minimumDuration: 1) {
                withAnimation {
                    settingsShown.toggle()
                }
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
