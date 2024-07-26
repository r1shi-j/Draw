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
            .undo(data: data)
            .redo(data: data)
            .clear(data: data)
            .settingsToggle(settingsShown: $data.showSettings)
            .gesture(drawGesture)
            .ignoresSafeArea()
        
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    data.open()
                    data.reindexLines()
                } else if newPhase == .inactive || newPhase == .background {
                    data.reindexLines()
                    data.save("Lines", "Lastlines", "Line Color", "Line Width", "Background Color")
                }
            }
    }
    
    private var sketch: some View {
        Canvas { context, size in
            for line in data.lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(data.convertHexToColor(hex: line.color)), style: StrokeStyle(lineWidth: line.width, lineCap: .round, lineJoin: .round))
            }
        }
        .background(data.selectedBackgroundColorAsColor)
    }

    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
            .onChanged { value in
                if data.lines.isEmpty {
                    let newLine = Line(points: [value.location], color: data.lineColor, width: data.lineWidth)
                    data.lines.append(newLine)
                } else {
                    let lastIndex = data.lines.indices.last!
                    data.lines[lastIndex].color = data.lineColor
                    data.lines[lastIndex].width = data.lineWidth
                    data.lines[lastIndex].points.append(value.location)
                }
                data.save()
            }
            .onEnded { _ in
                data.reindexLines()
                data.save("Lines", "Lastlines")
            }
    }
}
