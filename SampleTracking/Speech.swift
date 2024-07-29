//
//  Speech.swift
//  SampleTracking
//
//  Created by Taylor Colbert on 7/25/24.
//

import Foundation
import SwiftUI
import AVFoundation

class Speech {
    static let synthesizer = AVSpeechSynthesizer()

    static func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
