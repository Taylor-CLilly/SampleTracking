//
//  MockAPI.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/18/24.
//

import Foundation

// Define a Sample struct to hold the sample information
struct Sample: Identifiable {
    let id: String
    let name: String
    let description: String
    let dateCollected: Date
    var wellLocation: String
}

// Mock API class to provide sample data
class MockAPI {
    // Sample data stored in a dictionary
    private static let samples: [String: Sample] = [
        "1234567890": Sample(id: "1234567890", name: "Sample A", description: "Description for Sample A", dateCollected: Date(), wellLocation: "A11"),
        "0987654321": Sample(id: "0987654321", name: "Sample B", description: "Description for Sample B", dateCollected: Date(), wellLocation: "G5"),
        "1122334455": Sample(id: "1122334455", name: "Sample C", description: "Description for Sample C", dateCollected: Date(), wellLocation: "C7"),
        "P105701": Sample(id: "P105701", name: "Sample D", description: "Description for Sample D", dateCollected: Date(), wellLocation: "D7")
    ]
    
    // Function to fetch sample information based on the scanned barcode
    static func fetchSampleInfo(for barcode: String, completion: @escaping (Sample?) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let sample = samples[barcode]
            // Call the completion handler with the sample information
            DispatchQueue.main.async {
                completion(sample)
            }
        }
    }
}
