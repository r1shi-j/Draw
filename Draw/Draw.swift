//
//  DrawModel.swift
//  Draw
//
//  Created by Rishi Jansari on 24/07/2024.
//

import Foundation

struct Line: Equatable, Codable {
    var points: [CGPoint]
    var color: String
    var width: Double
}

struct Draw: Codable {
    var lines = [Line]()
    var lastLines = [Line]()
    
    var lineColor = "000000"
    var lineWidth = 3.0
    var backgroundColor = "D2D2D4"
    
    var showSettings = true
    var showingSecondaryView = false
    var showColorsView = false
    var showWidthsView = false
    var showBackgroundColorView = false
    
    var y: CGFloat = 0
        
    mutating func createNewLine() {
        let newLine = Line(points: [], color: lineColor, width: lineWidth)
        lines.append(newLine)
    }
    
    mutating func reindexLines() {
        lines.removeAll { $0.points == [] }
        lines.removeAll { $0.points.count == 1 }
        lastLines.removeAll { $0.points == [] }
        lastLines.removeAll { $0.points.count == 1 }
        createNewLine()
    }
    
    mutating func undo() {
        if lines.count >= 2 {
            lines.removeAll { $0.points == [] }
            lastLines.append(lines.last!)
            lines.removeLast()
            createNewLine()
            save(["Lines", "Lastlines"])
        }
        // else if lines.count == 1 { if lines.first?.points == [] { } else { exit(0) /* FIXME: find out when called.*/ } } else { }
    }
    
    mutating func redo() {
        lines.removeAll { $0.points == [] }
        lines.append(lastLines.last!)
        lastLines.removeLast()
        createNewLine()
        save(["Lines", "Lastlines"])
    }
    
    func save(_ what: [String] = ["Lines"]) {
        let itemsToSave: [String: AnyEncodable] = [
            "Lines": AnyEncodable(lines),
            "Lastlines": AnyEncodable(lastLines),
            "Line Color": AnyEncodable(lineColor),
            "Line Width": AnyEncodable(lineWidth),
            "Background Color": AnyEncodable(backgroundColor)
        ]
        
        for item in what {
            if let value = itemsToSave[item] {
                encode(value, to: "SavedData: \(item)")
            }
        }
    }
    
    private func encode<T: Encodable>(_ value: T, to key: String) {
        let encoder = JSONEncoder()
        let storage = UserDefaults.standard
        
        if let encoded = try? encoder.encode(value) {
            storage.set(encoded, forKey: key)
        }
    }
    
    mutating func open() {
        lines = decode(from: "SavedData: Lines") ?? []
        lastLines = decode(from: "SavedData: Lastlines") ?? []
        lineColor = decode(from: "SavedData: Line Color") ?? ""
        lineWidth = decode(from: "SavedData: Line Width") ?? 0.0
        backgroundColor = decode(from: "SavedData: Background Color") ?? ""
    }
    
    private func decode<T: Decodable>(from key: String) -> T? {
        let decoder = JSONDecoder()
        let storage = UserDefaults.standard
        
        if let data = storage.data(forKey: key) {
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }
}
