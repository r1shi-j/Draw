//
//  SketchPad.swift
//  Draw
//
//  Created by Rishi Jansari on 25/07/2024.
//

import SwiftUI

struct SketchPad: View {
    @Bindable var data: DrawController
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        sketch
            .onTapGesture {
                data.clearInvisibleLines()
            }
            .undo(data: data)
            .redo(data: data)
            .clear(data: data)
            .settingsToggle(settingsShown: $data.settingsShown)
            .gesture(drawGesture)
            .ignoresSafeArea()
        
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    data.open()
                } else if newPhase == .inactive {
                    data.save("Lines", "Lastlines", "Line Color", "Line Width")
                }
            }
    }
    
    private var sketch: some View {
        Canvas { context, size in
            for line in data.lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(data.convert(hex: line.color)), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
            }
        }
        .background(.gray.opacity(0.4))
    }
    
    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
            .onChanged { value in
                if value.translation == .zero {
                    let newLine = Line(points: [value.location], color: data.lineColor, width: data.lineWidth)
                    data.lines.append(newLine)
                } else {
                    guard let lastIndex = data.lines.indices.last else { return }
                    data.lines[lastIndex].points.append(value.location)
                    data.clearInvisibleLines()
                }
                data.save("Lines")
            }
    }
}
