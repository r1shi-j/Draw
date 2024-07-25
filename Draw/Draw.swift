//
//  DrawModel.swift
//  Draw
//
//  Created by Rishi Jansari on 24/07/2024.
//

import Foundation

struct Draw: Codable {
    var lines = [Line]()
    var lastLines = [Line]()
    
    var lineWidth = 3.0
    var lineColor = "000000"
    
    var settingsShown = true
    var showingSecondaryView = false
    var showColors = false
    var showWidths = false
    
    var y: CGFloat = 0
    
    mutating func clearInvisibleLines() {
        for line in lines  {
            if line.points.count == 1 {
                let index = lines.firstIndex { $0.points.count == 1 }
                lines.remove(at: index!)
            }
        }
    }
}

struct Line: Equatable, Codable {
    var points: [CGPoint]
    var color: String
    var width: Double
}
