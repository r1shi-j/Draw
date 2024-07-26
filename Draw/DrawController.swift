//
//  DrawViewModel.swift
//  Draw
//
//  Created by Rishi Jansari on 24/07/2024.
//

import SwiftUI

@Observable
class DrawController {
    private var model = Draw()
    
    var lines: [Line] { get { model.lines } set { model.lines = newValue } }
    var lastLines: [Line] { get { model.lastLines } set { model.lastLines = newValue } }
    
    var lineColor: String { get { model.lineColor } set { model.lineColor = newValue } }
    var lineWidth: Double { get { model.lineWidth } set { model.lineWidth = newValue } }
    
    var selectedColorAsColor: Color { convert(hex: lineColor) }
    
    var settingsShown: Bool { get { model.settingsShown } set { model.settingsShown = newValue } }
    var showingSecondaryView: Bool { get { model.showingSecondaryView } set { model.showingSecondaryView = newValue } }
    var showColors: Bool { get { model.showColors } set { model.showColors = newValue } }
    var showWidths: Bool { get { model.showWidths } set { model.showWidths = newValue } }
    
    var y: CGFloat { get { model.y } set { model.y = newValue } }
    
    var height: CGFloat { showingSecondaryView ? 140 : 90 }
    var offset: CGFloat { showingSecondaryView ? 25 : 0 }
    
    func convert(hex: String) -> Color {
        return Color(hex: hex)
    }
    
    func clearInvisibleLines() {
        model.clearInvisibleLines()
    }
    
    let colors: [String] = ["000000", "007AFF", "4CD964", "FF9500", "FFCC00", "FF3B30", "FFFFFF"]
    // black, blue, green, orange, yellow, red, white
    let grayHex = "8f8e94"
    
    func save(_ what: String...) {
        var list: [String] = []
        for i in what {
            list.append(i)
        }
        model.save(list)
    }
    
    func open() {
        model.open()
    }
}
