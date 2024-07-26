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
    
    let colors: [String] = ["000000", "007AFF", "4CD964", "FF9500", "FFCC00", "FF3B30", "FFFFFF"]
    // black, blue, green, orange, yellow, red, white
    let grayHex = "8f8e94"
    
    var lines: [Line] { get { model.lines } set { model.lines = newValue } }
    var lastLines: [Line] { get { model.lastLines } set { model.lastLines = newValue } }
    
    var lineColor: String { get { model.lineColor } set { model.lineColor = newValue } }
    var lineWidth: Double { get { model.lineWidth } set { model.lineWidth = newValue } }
    var backgroundColor: String { get { model.backgroundColor } set { model.backgroundColor = newValue } }
    
    var selectedColorAsColor: Color { convertHexToColor(hex: lineColor) }
    var selectedBackgroundColorAsColor: Color { 
        get { convertHexToColor(hex: backgroundColor) }
        set { backgroundColor = convertColorToHex(color: newValue) }
    }
    
    var showSettings: Bool { get { model.showSettings } set { model.showSettings = newValue } }
    var showingSecondaryView: Bool { get { model.showingSecondaryView } set { model.showingSecondaryView = newValue } }
    var showColorsView: Bool { get { model.showColorsView } set { model.showColorsView = newValue } }
    var showWidthsView: Bool { get { model.showWidthsView } set { model.showWidthsView = newValue } }
    var showBackgroundColorView: Bool { get { model.showBackgroundColorView } set { model.showBackgroundColorView = newValue } }
    
    var y: CGFloat { get { model.y } set { model.y = newValue } }
    
    var height: CGFloat { showingSecondaryView ? 140 : 90 }
    var offset: CGFloat { showingSecondaryView ? 25 : 0 }
    
    func convertHexToColor(hex: String) -> Color {
        Color(hex: hex)
    }
    
    func convertColorToHex(color: Color) -> String {
        color.toHex()
    }
    
    func createNewLine() {
        model.createNewLine()
    }
    
    func reindexLines() {
        model.reindexLines()
    }
    
    func undo() {
        model.undo()
    }
    
    func redo() {
        model.redo()
    }
    
    func save(_ what: String?...) {
        var list: [String] = []
        
        if what.isEmpty {
            list = ["Lines"]
        } else {
            for i in what {
                list.append(i!)
            }
        }
        model.save(list)
    }
    
    func open() {
        model.open()
    }
}
