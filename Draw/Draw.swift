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
    
    var lineColor = "000000"
    var lineWidth = 3.0
    
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
    
    func save(_ what: [String]) {
        let encoder = JSONEncoder()
        let storage = UserDefaults.standard
        
        let itemsToSave: [String: AnyEncodable] = [
            "Lines": AnyEncodable(lines),
            "Lastlines": AnyEncodable(lastLines),
            "Line Color": AnyEncodable(lineColor),
            "Line Width": AnyEncodable(lineWidth)
        ]

        for item in what {
            if let value = itemsToSave[item] {
                if let encoded = try? encoder.encode(value) {
                    storage.set(encoded, forKey: "SavedData: \(item)")
                }
            }
        }
    }
    
    mutating func open() {
        let decoder = JSONDecoder()
        let storage = UserDefaults.standard
        
        if let linedata = storage.data(forKey: "SavedData: Lines") {
            if let decoded = try? decoder.decode([Line].self, from: linedata) {
                lines = decoded
            }
        }
        if let lastlinedata = storage.data(forKey: "SavedData: Lastlines") {
            if let decoded = try? decoder.decode([Line].self, from: lastlinedata) {
                lastLines = decoded
            }
        }
        if let linecolordata = storage.data(forKey: "SavedData: Line Color") {
            if let decoded = try? decoder.decode(String.self, from: linecolordata) {
                lineColor = decoded
            }
        }
        if let linewidthdata = storage.data(forKey: "SavedData: Line Width") {
            if let decoded = try? decoder.decode(Double.self, from: linewidthdata) {
                lineWidth = decoded
            }
        }
    }
}

struct Line: Equatable, Codable {
    var points: [CGPoint]
    var color: String
    var width: Double
}
