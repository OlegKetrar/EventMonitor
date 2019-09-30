//
//  JsonCodeView.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import JsonSyntax

final class JsonCodeView: UIView {
   private let theme = JsonCodeViewTheme.postman
   private let syntax = JsonSyntax()

   private let contentLabel = UITextView(frame: .zero).with {
      $0.backgroundColor = .clear
      $0.isScrollEnabled = false
      $0.isEditable = false
      $0.isSelectable = true
      $0.translatesAutoresizingMaskIntoConstraints = false
   }

   override init(frame: CGRect) {
      super.init(frame: frame)
      defaultConfiguring()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      defaultConfiguring()
   }

   func setText(_ text: String, highlight: Bool = false) {

      let attrStr = NSMutableAttributedString(string: text, attributes: [
         .font : theme.font,
         .foregroundColor : theme.textColor
      ])

      guard highlight else {
         contentLabel.attributedText = attrStr
         return
      }

      let mutAttrStr = NSMutableAttributedString(attributedString: attrStr)
      let highlights = getHighlights(from: text)

      for item in highlights {
         mutAttrStr.addAttribute(.foregroundColor, value: item.color, range: item.range)
      }

      contentLabel.attributedText = mutAttrStr
   }
}

// MARK: - Private

private extension JsonCodeView {
   typealias Highlight = (range: NSRange, color: UIColor)

   func getHighlights(from str: String) -> [Highlight] {
      guard let tree = try? syntax.parse(str) else { return [] }

      return tree.getHighlightTokens().map { token in
         switch token.kind {

         case .syntax(.openBracket),
              .syntax(.closeBracket),
              .syntax(.openBrace),
              .syntax(.closeBrace):

            return token.withColor(theme.bracesColor)

         case .syntax(.colon), .syntax(.comma):
            return token.withColor(theme.delimiterColor)

         case .literalValue:
            return token.withColor(theme.literalColor)

         case .numberValue:
            return token.withColor(theme.numberColor)

         case .stringValue:
            return token.withColor(theme.stringColor)

         case .key:
            return token.withColor(theme.keyColor)
         }
      }
   }

   func defaultConfiguring() {

      let scrollView = UIScrollView(frame: .zero)
      scrollView.backgroundColor = .clear
      scrollView.indicatorStyle = .white
      scrollView.alwaysBounceHorizontal = true
      scrollView.alwaysBounceVertical = false
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      scrollView.addSubview(contentLabel)
      addSubview(scrollView)
      backgroundColor = theme.backgroundColor

      NSLayoutConstraint.activate([
         scrollView.leftAnchor.constraint(equalTo: leftAnchor),
         scrollView.topAnchor.constraint(equalTo: topAnchor),
         scrollView.rightAnchor.constraint(equalTo: rightAnchor),
         scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

         contentLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
         contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
         contentLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
         contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         contentLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
      ])
   }
}

// MARK: - Convenience

private extension HighlightToken {

   func withColor(_ color: UIColor) -> JsonCodeView.Highlight {
      return (range: nsRange, color: color)
   }

   var nsRange: NSRange {
      return NSRange(location: pos.location, length: pos.length)
   }
}
