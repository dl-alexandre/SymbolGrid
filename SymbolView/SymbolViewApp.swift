//
//  SymbolViewApp.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/24/24.
//

import SwiftUI

@main
struct SymbolViewApp: App {
    @State private var isActive: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                LoadingView(isActive: $isActive)
            } else {
                ContentView(symbols: decodePList())
                    .transition(.move(edge: .bottom))
            }
           
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
        
        .commands {
            SidebarCommands()
            
            CommandMenu("Symbols") {
                Button {
                    showSearch()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }.keyboardShortcut("s")
                Button {
                    clearSearch()
                } label: {
                    Label("Clear", systemImage: "delete.left")
                }.keyboardShortcut(.escape, modifiers: [])
                Button {
                    gridSize = max(9, gridSize - 5)
                } label: {
                    Label("Smaller", systemImage: "minus")
                }.keyboardShortcut("-")
                Button {
                    gridSize = min(2000, gridSize + 10)
                } label: {
                    Label("Larger", systemImage: "plus")
                }.keyboardShortcut("=")
            }
        }
#endif
    }
    @AppStorage("showingSearch") var showingSearch = false
    @AppStorage("searchText") var searchText = ""
    @AppStorage("gridsize") var gridSize = 50.0
    func showSearch() { showingSearch.toggle() }
    
    func clearSearch() {
        showingSearch = false
        searchText = ""
    }
}

extension App {
    
    func decodePList() -> [String] {
            // Get the URL of the plist file in the main bundle
        guard let fileURL = Bundle.main.url(forResource: "symbol_categories", withExtension: "plist") else {
            fatalError("Can't find symbol_categories.plist")
        }
            // Get the data from the plist file
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Can't read data from symbol_categories.plist")
        }
            // Create a PropertyListDecoder instance
        let decoder = PropertyListDecoder()
            // Decode the data into a dictionary of type [String: String]
        guard let dict = try? decoder.decode([String: [String]].self, from: data) else {
            fatalError("Can't decode data from symbol_categories.plist")
        }
        
        let symbols = dict.keys
        
        return Array(symbols)
    }
}

struct SettingsView: View {
    
    
    var body: some View {
        TabView {
            LanguageSetting().tabItem { Label("lang", systemImage: "character") }
            GridSizeSetting().tabItem { Label("size", systemImage: "textformat.size")}
        }.padding()
            .frame(width: 400, height: 300)
    }
}

struct GridSizeSetting: View {
    @AppStorage("gridsize") var gridSize = 50.0
    @State private var linearValue: Double = log10(50) // Linear slider value
    var exponentialValue: Double {
        get {
                // Convert the linear slider value to an exponential value
            pow(10, linearValue)
        }
        set {
                // Convert the new exponential value back to a linear slider value
            linearValue = log10(newValue)
            gridSize = newValue
        }
    }
    
    var body: some View {
        VStack {
            Slider(value: Binding(
                get: { self.linearValue },
                set: { newValue in
                    self.linearValue = newValue
                    self.gridSize = pow(10, newValue)
                }
            ), in: log10(9)...log10(2000))
            Text("Grid Size: \(gridSize, specifier: "%.2f")")

            HStack {
                Button {
                    gridSize = max(9, gridSize - 5)
                } label: {
                    Label("Smaller", systemImage: "minus")
                }.keyboardShortcut("-")
                Button {
                    gridSize = min(2000, gridSize + 10)
                } label: {
                    Label("Larger", systemImage: "plus")
                }.keyboardShortcut("=")
            }
        }
    }
}

struct LanguageSetting: View {
    @AppStorage("Arabic") private var arabicSetting = true
    @AppStorage("Hebrew") private var hebrewSetting = true
    @AppStorage("Hindi") private var hindiSetting = true
    @AppStorage("Japanese") private var japaneseSetting = true
    @AppStorage("Korean") private var koreanSetting = true
    @AppStorage("Thai") private var thaiSetting = true
    @AppStorage("Chinese") private var chineseSetting = true
    
    var body: some View {
        Form {
            Text("**Special Characters**")
            Toggle("Arabic", isOn: $arabicSetting).keyboardShortcut("a")
            Toggle("Hebrew", isOn: $hebrewSetting).keyboardShortcut("b")
            Toggle("Hindi", isOn: $hindiSetting).keyboardShortcut("h")
            Toggle("Japanese", isOn: $japaneseSetting).keyboardShortcut("j")
            Toggle("Korean", isOn: $koreanSetting).keyboardShortcut("k")
            Toggle("Thai", isOn: $thaiSetting).keyboardShortcut("t")
            Toggle("Chinese", isOn: $chineseSetting).keyboardShortcut("c")
        }
        
    }
}

struct LoadingView: View {
    @Binding var isActive: Bool
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(DefaultProgressViewStyle())
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeOut(duration: 2)) {
                    self.isActive = false
                }
            }
        }
    }
}
