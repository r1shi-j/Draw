//
//  ContentView.swift
//  Draw
//
//  Created by Rishi Jansari on 23/07/2024.
//

import SwiftUI

struct DrawView: View {
    @Bindable private var data: DrawController = DrawController()

    var body: some View {
        ZStack {
            SketchPad(data: data)
            SettingsView(data: data)
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    DrawView()
}
