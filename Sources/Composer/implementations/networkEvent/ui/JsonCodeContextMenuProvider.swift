//
//  JsonCodeContextMenuProvider.swift
//
//  Created by Oleg Ketrar on 20.10.2024.
//

import Foundation
import UIKit
import JsonSyntax

final class JsonCodeContextMenuProvider: CodeViewContextMenuProvider {
   var parseTree: ParseTree?
   var onReplace: (JsonPath) -> Void = { _ in }

   func contextMenu(textView: UITextView, textRange: UITextRange) -> UIMenu? {
      var actions: [UIMenuElement] = []
      actions.append(CopyContextMenuProvider.makeShareAction(textView, textRange))

      let jsonPath = parseTree?.getJsonKeyPath(
         for: textView.attributedText.string,
         at: textView.convertTextRange(textRange))

      if let jsonPath {
         actions.append(UIAction(title: "Replace") { [weak self] _ in
            self?.onReplace(jsonPath)
         })
      }

      return UIMenu(children: actions)
   }
}

private extension UITextView {

   func convertTextRange(_ textRange: UITextRange) -> Pos {
      let location = offset(from: beginningOfDocument, to: textRange.start)
      let length = offset(from: textRange.start, to: textRange.end)

      return Pos.from(location, length)
   }
}
