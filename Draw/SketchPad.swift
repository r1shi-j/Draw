//
//  SketchPad.swift
//  Draw
//
//  Created by Rishi Jansari on 25/07/2024.
//

import SwiftUI

struct SketchPad: View {
    @Bindable var data: DrawController
    
    var body: some View {
        sketch
        .onTapGesture {
            data.clearInvisibleLines()
        }
        .undo(lines: $data.lines, lastLines: $data.lastLines)
        .redo(lines: $data.lines, lastLines: $data.lastLines)
        .clear(lines: $data.lines, lastLines: $data.lastLines)
        .settingsToggle(settingsShown: $data.settingsShown)
        .gesture(drawGesture)
        .ignoresSafeArea()
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
            }
    }
}
