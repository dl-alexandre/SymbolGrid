//
//  Tab.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 5/31/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case favorites = "star"
}


class TabModel: ObservableObject {
    @Published var activeTab: Tab = .home
    @Published private(set) var isTabBarAdded: Bool = false
    let id: String = UUID().uuidString
#if os(macOS)
    func addTabBar() {
        guard !isTabBarAdded else { return }
        
        if let applicationWindow = NSApplication.shared.mainWindow {
            let customTabBar = NSHostingView(rootView: FloatingTabBarView().environmentObject(self))
            let floatingWindow = NSWindow()
            floatingWindow.styleMask = .borderless
            floatingWindow.contentView = customTabBar
            floatingWindow.backgroundColor = .clear
            floatingWindow.title = id
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 45, y: windowOrigin.y + (windowSize.height - 150) / 2))
            
            applicationWindow.addChildWindow(floatingWindow, ordered: .above)
        } else {
            print("No Window Found")
        }
    }
    
    func updateTabPosition() {
        if let floatingWindow = NSApplication.shared.windows.first(where: { $0.title == id }), let applicationWindow = NSApplication.shared.mainWindow {
            let windowSize = applicationWindow.frame.size
            let windowOrigin = applicationWindow.frame.origin
            
            floatingWindow.setFrameOrigin(.init(x: windowOrigin.x - 50, y: windowOrigin.y + (windowSize.height - 90) / 2))
        }
    }
    
    fileprivate struct FloatingTabBarView: View {
        @EnvironmentObject private var tabModel: TabModel
        @Environment(\.colorScheme) private var colorScheme
        @Namespace private var animation
        private let animationID: UUID = .init()
        var body: some View {
            VStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        tabModel.activeTab = tab
                    } label: {
                        Image(systemName: tab.rawValue)
                            .font(.title3)
                            .foregroundStyle(tabModel.activeTab == tab ? (colorScheme == .dark ? .black : .white) : .primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background {
                                if tabModel.activeTab == tab {
                                    Circle()
                                        .fill(.primary)
                                        .matchedGeometryEffect(id: animationID, in: animation)
                                }
                            }
                            .contentShape(.rect)
                            .animation(.bouncy, value: tabModel.activeTab)
                    }.buttonStyle(.plain)
                }
            }
            .padding(5)
            .frame(width: 45, height: 90)
            .background(.background)
            .clipShape(.capsule)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: 50)
            .contentShape(.capsule)
        }
    }
    #endif
}

#if os(macOS)
struct HideTabBar: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        return .init()
    }
    
    func updateNSView(
        _ nsView: NSView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let tabView = nsView.superview?.superview?.superview as? NSTabView {
                tabView.tabViewType = .noTabsNoBorder
                tabView.tabViewBorderType = .none
                tabView.tabPosition = .none
            }
        }
    }
}
#endif
