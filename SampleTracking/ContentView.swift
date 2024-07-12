//
//  ContentView.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Vision
import AVFoundation
import VisionKit


struct ContentView: View { // declares a structure named "ContentView' that conforms to the 'View' protocol.
    @State private var showScanner = false // '@State' property wrapper that tells SwuftUI to manage this property and update the view whenever the property's value changes

    var body: some View {
        VStack { // Vertical Stack that arranges its childeren in a vertical line
            Button("Scan Barcode") { // creates the button
                showScanner.toggle() // when button is tapped, the action is executed
            }
            .sheet(isPresented: $showScanner) {
                BarcodeScannerViewController(scannedCode: <#Binding<String?>#>) 
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider { // structures that conforms to the 'PreviewProvider' protocol
    static var previews: some View { // returns a view, which is 'ContentView'
        ContentView()
    }
}

