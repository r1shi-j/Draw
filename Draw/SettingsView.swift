//
//  SettingsView.swift
//  Draw
//
//  Created by Rishi Jansari on 24/07/2024.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var data: DrawController
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                mainSettings
                ZStack {
                    colorSettings
                    widthSettings
                }
            }
            .position(x: geometry.size.width / 2 , y: 14)
            .offset(y: (data.settingsShown ? 0 : -200))
            .offset(y: data.y)
            .transition(.slide)
            .gesture(swipeGesture)
        }
    }
    
    var mainSettings: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 44)
                .frame(maxWidth: 371, maxHeight: data.height)
                .offset(y: data.offset)
                .foregroundColor(.black)
            HStack(spacing: 40) {
                undoButton
                redoButton
                colorButton
                widthButton
                settingsButton
            }
            .font(.title2)
        }
    }
    
    // MARK: - Menu Buttons
    
    var undoButton: some View {
        Button(action: {
            Undo(lines: $data.lines, lastLines: $data.lastLines).action()
        }, label: {
            Image(systemName: "arrow.uturn.backward.circle")
        })
        .disabled(data.lines.isEmpty)
        .animation(nil, value: data.lines)
    }
    
    var redoButton: some View {
        Button(action: {
            Redo(lines: $data.lines, lastLines: $data.lastLines).action()
        }, label: {
            Image(systemName: "arrow.uturn.forward.circle")
        })
        .disabled(data.lastLines.isEmpty)
        .animation(nil, value: data.lastLines)
    }
    
    var colorButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                data.showingSecondaryView.toggle()
                if data.showWidths {
                    data.showWidths.toggle()
                    data.showingSecondaryView = true
                }
                data.showColors.toggle()
            }
        }, label: {
            Image(systemName: "paintpalette")
                .font(.title)
                .symbolRenderingMode(data.showColors ? .multicolor : .none)
                .tint(data.showColors ? .none : (data.selectedColorAsColor == .black ? .gray : data.selectedColorAsColor))
                .symbolEffect(.bounce, value: data.showColors)
                .offset(y:10)
        })
    }
    
    var widthButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                data.showingSecondaryView.toggle()
                if data.showColors {
                    data.showColors.toggle()
                    data.showingSecondaryView = true
                }
                data.showWidths.toggle()
            }
        }, label: {
            Image(systemName: "rectangle.portrait.arrowtriangle.2.inward")
                .symbolRenderingMode(data.showWidths ? .hierarchical : .none)
                .symbolEffect(.bounce, value: data.showWidths)
                .overlay {
                    Text("\(Int(data.lineWidth))")
                        .font(.caption2)
                }
        })
    }
    
    var settingsButton: some View {
        Button(action: {
            // TODO: - Logic
        }, label: {
            Image(systemName: "gearshape")
        })
        .disabled(true)
    }
    
    // MARK: - Color Settings
    
    var colorSettings: some View {
        HStack {
            ForEach(data.colors, id:\.self) { color in
                Button(action: {
                    withAnimation(.snappy) {
                        data.lineColor = color
                    }
                }, label: {
                    Image(systemName: "paintbrush\(color == data.lineColor ? ".fill" : "")")
                        .foregroundColor(data.convert(hex:color) == .black ? data.convert(hex: data.grayHex) : data.convert(hex: color))
                        .symbolEffect(.bounce, options: .nonRepeating, isActive: data.lineColor == color)
                        .contentTransition(.interpolate)
                })
                .padding(.horizontal, 10)
            }
        }
        .offset(y: -29)
        .opacity(data.showColors ? 1 : 0)
    }
    
    // MARK: - Width Settings
    
    var widthSettings: some View {
        Slider(
            value: $data.lineWidth,
            in: 1...20,
            step: 1
        )
        .frame(maxWidth: 330)
        .offset(y: -29)
        .opacity(data.showWidths ? 1 : 0)
    }
    
    // MARK: - Gestures
    
    var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { offset in
                if offset.location.y < (data.showingSecondaryView ? 140 : 90) {
                    withAnimation(.bouncy(duration: 1)) {
                        data.y = offset.location.y
                    }
                }
            }
            .onEnded { offset in
                if abs(offset.translation.height) > (data.showingSecondaryView ? 50 : 30)
                    && offset.location.y <= (data.showingSecondaryView ? 150 : 100) {
                    withAnimation(.bouncy(duration: 2)) {
                        data.showColors = false
                        data.showWidths = false
                        data.showingSecondaryView = false
                        data.settingsShown = false
                        data.y = 0
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        data.y = 0
                    }
                }
            }
    }
}
