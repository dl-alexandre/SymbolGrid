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
    @AppStorage("showingSearch") var showingSearch = true
    @AppStorage("showingRender") var showingRender = true
    @AppStorage("showingWeight") var showingWeight = true
    @AppStorage("showingCanvas") var showingCanvas = false
    @AppStorage("canvasIcon") var canvasIcon = ""
        //    let speechSynthesizer = AVSpeechSynthesizer()
    var icon: String
        // @State var mode: RenderSamples
    @AppStorage("fontSize") var fontSize = 50.0
    
    var body: some View {
#if os(iOS)
            Button {
                UIPasteboard.general .setValue(icon.description,
                                               forPasteboardType: UTType.plainText .identifier)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }

            Section("Size") {
                Stepper(value: $fontSize, in: 9...200, step: 10) { EmptyView() }
                
            }
            
#endif
                //            Button {
                //                speak(say: icon)
                //            } label: {
                //                Label("Speak",
                //                      systemImage:
                //                        "speaker.wave.3")
                //            }
//            Section("Font Weight") {
                Button {
                    showingWeight.toggle()
                } label: {
                    Label("Weight", systemImage: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
                }
//            }
//            Section("Color Mode") {
                Button {
                    showingRender.toggle()
                } label: {
                    Label("Render", systemImage: "paintbrush")
                }
//            }
//            Section("Search") {
                Button {
                    showingSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
//            }
//            Section("Canvas") {
//                Button {
//                    showingCanvas = true
//                    canvasIcon = icon
//                } label: {
//                    Label("Canvas", systemImage: "square")
//                }
//            }
        
        
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

