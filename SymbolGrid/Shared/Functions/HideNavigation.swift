//
//  HideNavigation.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 10/8/24.
//

import SwiftUI

#if os(iOS)
@MainActor func hideNavigationBar() {
    let appearance = UINavigationBar.appearance()
    appearance.setBackgroundImage(UIImage(), for: .default)
    appearance.shadowImage = UIImage()
    appearance.isTranslucent = true
}
#endif
