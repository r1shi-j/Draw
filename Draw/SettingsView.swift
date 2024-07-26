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
                    colorSettingsView
                    widthSettingsView
                    backgroundColorSettingsView
                }
                .offset(y: -32)
            }
            .position(x: geometry.size.width / 2 , y: 14)
            .offset(y: (data.showSettings ? 0 : -200))
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
            HStack(spacing: 42) {
                Undo(data: data).undoButton
                Redo(data: data).redoButton
                colorButton
                widthButton
                backgroundColorButton
            }
            .frame(maxWidth: 308)
            .font(.title2)
        }
    }
    
    // MARK: - Menu Buttons
    
    var colorButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                if data.showColorsView {
                    data.showingSecondaryView = false
                } else {
                    if data.showingSecondaryView {
                        data.showWidthsView = false
                        data.showBackgroundColorView = false
                    } else {
                        data.showingSecondaryView = true
                    }
                }
                data.showColorsView.toggle()
            }
        }, label: {
            Image(systemName: "paintpalette")
                .font(.title)
                .symbolRenderingMode(data.showColorsView ? .multicolor : .none)
                .tint(data.showColorsView ? .none : (data.selectedColorAsColor == .black ? .gray : data.selectedColorAsColor))
                .symbolEffect(.bounce, value: data.showColorsView)
                .offset(y:10)
        })
    }
    
    var widthButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                if data.showWidthsView {
                    data.showingSecondaryView = false
                } else {
                    if data.showingSecondaryView {
                        data.showColorsView = false
                        data.showBackgroundColorView = false
                    } else {
                        data.showingSecondaryView = true
                    }
                }
                data.showWidthsView.toggle()
            }
        }, label: {
            Image(systemName: "rectangle.portrait.arrowtriangle.2.inward")
                .symbolEffect(.bounce, value: data.showWidthsView)
                .overlay {
                    Text("\(Int(data.lineWidth))")
                        .font(.caption2.width(.condensed))
                }
                .tint(data.showWidthsView ? .none : (data.selectedColorAsColor == .black ? .gray : data.selectedColorAsColor))
        })
    }
    
    var backgroundColorButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                if data.showBackgroundColorView {
                    data.showingSecondaryView = false
                } else {
                    if data.showingSecondaryView {
                        data.showColorsView = false
                        data.showWidthsView = false
                    } else {
                        data.showingSecondaryView = true
                    }
                }
                data.showBackgroundColorView.toggle()
            }
        }, label: {
            Image(systemName: "paintbrush\(data.showBackgroundColorView ? "" : ".fill")")
                .symbolEffect(.bounce, value: data.showBackgroundColorView)
                .tint(data.selectedBackgroundColorAsColor)
        })
    }
    
    // MARK: - Color Settings View
    
    var colorSettingsView: some View {
        HStack {
            ForEach(data.colors, id:\.self) { color in
                Button(action: {
                    withAnimation(.snappy) {
                        data.lineColor = color
                        data.save("Line Color")
                    }
                }, label: {
                    Image(systemName: "paintbrush.pointed\(color == data.lineColor ? ".fill" : "")")
                        .foregroundColor(data.convertHexToColor(hex:color) == .black ? data.convertHexToColor(hex: data.grayHex) : data.convertHexToColor(hex: color))
                        .symbolEffect(.bounce, options: .nonRepeating, isActive: data.lineColor == color)
                        .contentTransition(.interpolate)
                })
                .padding(.horizontal, 9)
            }
        }
        .frame(maxWidth: 308)
        .opacity(data.showColorsView ? 1 : 0)
    }
    
    // MARK: - Width Settings View
    
    var widthSettingsView: some View {
        Slider(
            value: $data.lineWidth,
            in: 1...25,
            step: 1
        )
        .frame(maxWidth: 308)
        .opacity(data.showWidthsView ? 1 : 0)
        .onChange(of: data.lineWidth) {
            data.save("Line Width")
        }
    }
    
    // MARK: - Background Color Settings View

    var backgroundColorSettingsView: some View {
        ColorPicker("Background Color", selection: $data.selectedBackgroundColorAsColor, supportsOpacity: false)
            .frame(maxWidth: 308)
            .font(.caption.bold())
            .foregroundColor(data.selectedBackgroundColorAsColor)
            .opacity(data.showBackgroundColorView ? 1 : 0)
            .onChange(of: data.backgroundColor) {
                data.save("Background Color")
            }
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
                        data.showColorsView = false
                        data.showWidthsView = false
                        data.showBackgroundColorView = false
                        data.showingSecondaryView = false
                        data.showSettings = false
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
