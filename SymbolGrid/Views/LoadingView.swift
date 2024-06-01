//
//  LoadingView.swift
//  SymbolView
//
//  Created by Dalton Alexandre on 5/29/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isActive: Bool
    var body: some View {
        ZStack {
#if os(iOS)
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
#endif
#if os(macOS)
            Color(.controlBackgroundColor)
                .edgesIgnoringSafeArea(.all)
#endif
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


#Preview {
    LoadingView(isActive: .constant(true))
}
