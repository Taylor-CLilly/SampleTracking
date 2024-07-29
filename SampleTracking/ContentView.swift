//
//  ContentView.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/8/24.
//


import SwiftUI
import Vision
import VisionKit
import AVFAudio
import AVFoundation

struct ContentView: View {
    @State private var showScanner = false // State variable to control barcode scanner presentation
    @State private var scannedCode: String? // State variable to store scanned barcode
    @State private var sample: Sample? // State variable to store sample information
    @State private var showWellPlateWindow = false // State variable to control well plate window presentation

    var body: some View {
        VStack {
            // Button to scan barcode
            Button("Scan Barcode") {
                showScanner.toggle() // Toggle barcode scanner presentation
            }
            .sheet(isPresented: $showScanner) {
                BarcodeScannerViewController(scannedCode: $scannedCode) { scannedCode in
                    // Handle scanned barcode
                    fetchSampleInfo(for: scannedCode) // Fetch sample information for the scanned barcode
                }
            }
            
            // Display scanned barcode if available
            if let scannedCode = scannedCode {
                Text("Scanned Code: \(scannedCode)")
                    .padding()
                
                // Display sample information if available
                if let sample = sample {
                    VStack(alignment: .leading) {
                        Text("Sample Name: \(sample.name)")
                        Text("Description: \(sample.description)")
                        Text("Date Collected: \(sample.dateCollected)")
                        Text("Well Location: \(sample.wellLocation)") // Display well location
                    }
                    .padding()

                    // Button to show well plate
                    Button("Show Well Plate") {
                        showWellPlateWindow.toggle() // Show the well plate window
                        Speech.speak(text: "Sample should be pipetted in: \(sample.wellLocation)") // Speak the well location
                    }
                    .padding()
                    .sheet(isPresented: $showWellPlateWindow) {
                        WellPlateWindow(wellLocation: sample.wellLocation) {
                            // Logic for scanning another barcode can be added here
                            showWellPlateWindow = false // Close the well plate view
                        }
                    }
                } else {
                    Text("Sample information not yet fetched.")
                        .padding()
                    
                    // Button to fetch sample information
                    Button("Fetch Sample Info") {
                        fetchSampleInfo(for: scannedCode) // Fetch sample information for the scanned barcode
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
    
    // Function to fetch sample information for a given barcode
    private func fetchSampleInfo(for barcode: String) {
        MockAPI.fetchSampleInfo(for: barcode) { fetchedSample in
            self.sample = fetchedSample // Update sample information
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Preview ContentView
    }
}
