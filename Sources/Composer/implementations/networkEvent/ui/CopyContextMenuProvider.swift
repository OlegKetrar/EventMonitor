//
//  CopyContextMenuProvider.swift
//
//  Created by Oleg Ketrar on 20.10.2024.
//

import Foundation
import UIKit

final class CopyContextMenuProvider: CodeViewContextMenuProvider {

   static func makeShareAction(
      _ textView: UITextView,
      _ textRange: UITextRange
   ) -> UIAction {
      UIAction(title: "Copy") { [weak textView] _ in
         if let text = textView?.text(in: textRange) {
            UIPasteboard.general.string = text
         }
      }
   }

   func contextMenu(textView: UITextView, textRange: UITextRange) -> UIMenu? {
      var actions: [UIMenuElement] = []
      actions.append(Self.makeShareAction(textView, textRange))

      return UIMenu(children: actions)
   }
}
