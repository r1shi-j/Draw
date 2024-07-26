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
                data.undo()
            }
    }
    
    var undoButton: some View {
        Button(action: {
            data.undo()
        }, label: {
            Image(systemName: "arrow.uturn.backward.circle")
        })
        .disabled(data.lines.count <= 1)
        .animation(nil, value: data.lines)
    }
}

struct Redo: ViewModifier {
    @Bindable var data: DrawController
    
    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 3) {
                data.redo()
            }
    }
    
    var redoButton: some View {
        Button(action: {
            data.redo()
        }, label: {
            Image(systemName: "arrow.uturn.forward.circle")
        })
        .disabled(data.lastLines.isEmpty)
        .animation(nil, value: data.lastLines)
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
