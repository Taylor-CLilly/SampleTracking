//
//  SampleTrackingApp.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/8/24.
//

import SwiftUI

@main
struct SampleTrackingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
