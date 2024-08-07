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
    @Binding var scannedCode: String? // Binding to store scanned barcode
    var completionHandler: (String) -> Void // Completion handler to pass scanned barcode

    // Coordinator class to handle VNDocumentCameraViewControllerDelegate methods
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: BarcodeScannerViewController

        init(parent: BarcodeScannerViewController) {
            self.parent = parent
        }

        // Called when scanning is completed
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                parent.processImage(image) // Process each scanned image
            }
            controller.dismiss(animated: true) // Dismiss scanner view controller
        }

        // Called when the user cancels scanning
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) // Dismiss scanner view controller
        }

        // Called when an error occurs during scanning
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera failed with error: \(error)")
            controller.dismiss(animated: true) // Dismiss scanner view controller
        }
    }

    // Create and return an instance of Coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // Create and return an instance of VNDocumentCameraViewController
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator // Set coordinator as delegate
        return documentCameraViewController
    }

    // Update the view controller if needed
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    // Process the captured image to detect barcodes
    func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        // Create a barcode detection request
        let request = VNDetectBarcodesRequest { request, error in
            if let results = request.results as? [VNBarcodeObservation] {
                for result in results {
                    if let barcodeValue = result.payloadStringValue {
                        DispatchQueue.main.async {
                            self.scannedCode = barcodeValue // Update scannedCode with the detected barcode
                            self.completionHandler(barcodeValue) // Invoke completion handler with the scanned barcode
                        }
                    }
                }
            } else {
                print("No barcodes detected or error: \(String(describing: error))")
            }
        }

        // Perform the barcode detection request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform barcode detection: \(error)")
        }
    }
}
