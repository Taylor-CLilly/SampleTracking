//
//  WellPlateWindow.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/28/24.
//

import Foundation
import SwiftUI
import AVFoundation
import SwiftUI
import AVFoundation

struct WellPlateWindow: View {
    let wellLocation: String // The well location to highlight
    var onScanAnother: () -> Void // Closure for scanning another barcode

    var body: some View {
        VStack {
            Text("96 Well Plate")
                .font(.title)
                .padding()
            
            // Display a 96-well plate grid
            Grid {
                ForEach(0..<8) { row in
                    GridRow {
                        ForEach(0..<12) { column in
                            CellViewA(row: row, column: column, wellLocation: wellLocation)
                        }
                    }
                }
            }
            .padding()
            .aspectRatio(12.0/8.0, contentMode: .fit)
            .onAppear {
                // Vocalize the well location using Azure Speech Service
                Speech.speak(text: "Place the sample in well \(wellLocation)")
            }

            // Button to scan another barcode
            Button("Scan Another Barcode") {
                onScanAnother() // Call the closure to scan another barcode
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 300) // Adjust minimum size for resizing
    }
}

struct CellViewA: View {
    let row: Int
    let column: Int
    let wellLocation: String

    var body: some View {
        let wellLabel = "\(Character(UnicodeScalar(65 + row)!))\(column + 1)"
        let isHighlighted = wellLabel == wellLocation
        
        return Text(wellLabel)
            .frame(width: 30, height: 30)
            .background(isHighlighted ? Color.red : Color.clear)
            .cornerRadius(5)
            .border(Color.black)
            .foregroundColor(isHighlighted ? .white : .black)
    }
}

struct WellPlateWindow_Previews: PreviewProvider {
    static var previews: some View {
        WellPlateWindow(wellLocation: "A1", onScanAnother: {}) // Preview WellPlateView with a sample well location
    }
}
