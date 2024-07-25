//
//  DrawApp.swift
//  Draw
//
//  Created by Rishi Jansari on 23/07/2024.
//

import SwiftUI

@main
struct DrawApp: App {
    @State private var data = DrawController()

    var body: some Scene {
        WindowGroup {
            DrawView()
                .environment(data)
        }
    }
}
