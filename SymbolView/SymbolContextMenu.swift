//
//  File.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//


import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct SymbolContextMenu: View {
        //    let speechSynthesizer = AVSpeechSynthesizer()
    var icon: String
        // @State var mode: RenderSamples
    @AppStorage("gridsize") var gridSize = 50.0
    
    var body: some View {
        Section {
#if os(iOS)
            Button {
                UIPasteboard.general .setValue(icon.description,
                                               forPasteboardType: UTType.plainText .identifier)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
#endif
            Section("Size") {
                Stepper(value: $gridSize, in: 9...200, step: 10) { EmptyView() }
                
            }
                //            Button {
                //                speak(say: icon)
                //            } label: {
                //                Label("Speak",
                //                      systemImage:
                //                        "speaker.wave.3")
                //            }
        }
        
    }
    
        //    func speak(say: String) {
        //        let utterance = AVSpeechUtterance(string: say)
        //        utterance.voice = AVSpeechSynthesisVoice(identifier:"Aaron")
        //        utterance.rate = 0.4
        //        utterance.pitchMultiplier = 0.5
        //        utterance.preUtteranceDelay = 0
        //        utterance.volume = 1
        //        speechSynthesizer.speak(utterance)
        //    }
}

#Preview {
    SymbolContextMenu(icon: "doc.on.doc"/*, mode: .monochrome*/)
}

