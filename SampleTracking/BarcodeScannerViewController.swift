//
//  BarcodeScannerViewController.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/12/24.
//

import Foundation
import SwiftUI
import Vision
import VisionKit

struct BarcodeScannerViewController: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    
    // Coordunator class to handle VNDocumentCameraViewControllerDelegate methods
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: BarcodeScannerViewController

        init(parent: BarcodeScannerViewController) {
            self.parent = parent
        }

        // Called when scanning is completed
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // Iterate through each scanned item and process its image
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                parent.processImage(image)
            }
            // Dismiss the scanner view controller
            controller.dismiss(animated: true)
        }

        // Called when the user cancels scanning
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            // Dismiss the scanner view controller
            controller.dismiss(animated: true)
        }
        
        // Called when an error occurs during the scanning
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            // Print the wrror and dismiss the scanning
            print("Document camera failed with error: \(error)")
            controller.dismiss(animated: true)
        }
    }

    // Creates and returns an instance of Coordinator ?????????
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Creates and returns an instance of VNDocumentCameraViewController
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        // Assigns the Coordinator as the delegate of the VNDocumentCameraViewController
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }

    // Updates the VNDocumentCameraViewController when SwiftUI's environment or properties change
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let request = VNDetectBarcodesRequest { request, error in
            if let results = request.results as? [VNBarcodeObservation] {
                for result in results {
                    print("Barcode found: \(result.payloadStringValue ?? "Unknown")")
                }
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform barcode detection: \(error)")
        }
    }
}


