//
//  SplashView.swift
//  SymbolGrid
//
//  Created by Dalton on 6/17/24.
//

import SwiftUI
import SFSymbolKit

struct SplashView: View {
    @State private var vmo = ViewModel()

    @Binding var fontSize: Double
    @Binding var selectedWeight: Weight
    @Binding var isAnimating: Bool
    var firstSymbols: [Symbol]

    var body: some View {
        let limitedIcons: [Symbol] = Array(firstSymbols.prefix(200))
        GeometryReader { geo in
            let minColumnWidth = 1.5 * fontSize
            let numberOfColumns = max(1, Int(geo.size.width / minColumnWidth))
            let columns = Array(
                repeating: GridItem(
                    .adaptive(minimum: minColumnWidth)
                ),
                count: numberOfColumns
            )
            ZStack {
                ProgressView()
                NavigationView {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: fontSize * 0.1) {
                                ForEach(limitedIcons, id: \.self) { icon in
                                    Image(systemName: icon.name)
                                        .padding(8)
                                        .font(.system(size: fontSize, weight: selectedWeight.weight))
                                        .symbolEffect(.breathe.byLayer.pulse)
                                        .foregroundStyle(Color.random())
                                        .animation(.default, value: isAnimating)
                                        .scrollTransition(.interactive, axis: .vertical) { content, phase in
                                            content
                                                .scaleEffect(phase.isIdentity ? 1 : 0.25, anchor: .center)
                                                .opacity(phase.isIdentity ? 1 : 0.05)
                                        }
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.14) {
                                                withAnimation(.easeInOut(duration: 2)) {
                                                    isAnimating = false
                                                }
                                            }
                                        }
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.14) {
                                if limitedIcons.count > numberOfColumns {
                                    proxy.scrollTo(limitedIcons[1], anchor: .init(x: 0, y: 10))
                                }
                            }
                        }
                    }
                }
            }

#if os(macOS)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    if let selectedIcon = vmo.selected {
                        Text("\(selectedIcon.name)")
                            .padding()
                            .onTapGesture(count: 1) {
                                NSPasteboard.general.setString(selectedIcon.name, forType: .string)
                                print(selectedIcon.name)
                            }
                    }
                }
            }
#endif
        }
    }
}

#Preview {
    SplashView(
        fontSize: .constant(50.0),
        selectedWeight: .constant(.regular),
        isAnimating: .constant(true),
        firstSymbols: []
    )
}
