//
//  CodeView.swift
//  SymbolGrid
//
//  Created by Dalton Alexandre on 9/19/24.
//

import SwiftUI
import Splash

struct CodeText: View {
    var code: String = """
Image(systemName: "plus")
  .font(
    .system(
      size: 200.0,
      weight: .Regular)
  )
  .imageScale(.medium)
  .foregroundStyle(
    Color(
      #colorLiteral(
        red: 219.0 / 255.0,
        green: 84.0 / 255.0,
        blue: 255.0 / 255.0,
        alpha: 104.0 / 255.0))
  )
  .shadow(
    color: Color(50%      gray),
    radius: 3,
    x: 0.0,
    y: 0.0 - 10)
"""

    let highlighter = SyntaxHighlighter(
        format: AttributedStringOutputFormat(
            theme: .sundellsColors(
                withFont: Font(
                    size: 15
                )
            )
        )
    )

    var body: some View {
        HighlightedTextView(attributedText: highlighter.highlight(code))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HighlightedTextView: UIViewRepresentable {
    var attributedText: NSAttributedString

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedText
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedText
    }
}

#Preview {
    let code: String = """
Image(systemName: "plus")
  .font(
    .system(
      size: 200.0,
      weight: .Regular)
  )
  .imageScale(.medium)
  .foregroundStyle(
    Color(
      #colorLiteral(
        red: 219.0 / 255.0,
        green: 84.0 / 255.0,
        blue: 255.0 / 255.0,
        alpha: 104.0 / 255.0))
  )
  .shadow(
    color: Color(50%      gray),
    radius: 3,
    x: 0.0,
    y: 0.0 - 10)
"""
    CodeText(code: code)
}
