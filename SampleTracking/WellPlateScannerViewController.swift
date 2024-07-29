//
//  WellPlateScannerViewController.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/18/24.
//

import SwiftUI
import Vision
import VisionKit
import AVFoundation

struct WellPlateScannerViewController: View {
    let wellLocation: String // The well location to highlight

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
                            CellView(row: row, column: column, wellLocation: wellLocation)
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
        }
    }
}

struct CellView: View {
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

struct WellPlateScannerViewController_Previews: PreviewProvider {
    static var previews: some View {
        WellPlateScannerViewController(wellLocation: "A1") // Preview WellPlateView with a sample well location
    }
}
