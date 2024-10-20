//
//  CodeView.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

protocol CodeViewContextMenuProvider: AnyObject {
   func contextMenu(textView: UITextView, textRange: UITextRange) -> UIMenu?
}

final class CodeView: UIView {

   var ctxMenuProvider: CodeViewContextMenuProvider? {
      get { textView.ctxMenuProvider }
      set { textView.ctxMenuProvider = newValue }
   }

   private let textView = CodeTextView().with {
      $0.backgroundColor = .clear
      $0.isScrollEnabled = false
      $0.isEditable = false
      $0.isSelectable = true
      $0.translatesAutoresizingMaskIntoConstraints = false
   }

   override init(frame: CGRect) {
      super.init(frame: frame)
      configureUI()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      configureUI()
   }

   func setText(_ attributedString: NSAttributedString) {
      textView.attributedText = attributedString
   }
}

// MARK: - Private

private extension CodeView {

   func configureUI() {

      let scrollView = UIScrollView(frame: .zero)
      scrollView.backgroundColor = .clear
      scrollView.indicatorStyle = .white
      scrollView.alwaysBounceHorizontal = true
      scrollView.alwaysBounceVertical = false
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      scrollView.addSubview(textView)
      addSubview(scrollView)
//      backgroundColor = theme.backgroundColor

      NSLayoutConstraint.activate([
         scrollView.leftAnchor.constraint(equalTo: leftAnchor),
         scrollView.topAnchor.constraint(equalTo: topAnchor),
         scrollView.rightAnchor.constraint(equalTo: rightAnchor),
         scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

         textView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
         textView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         textView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
         textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         textView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
      ])
   }
}

// MARK: - Convenience

private class CodeTextView: UITextView {
   weak var ctxMenuProvider: CodeViewContextMenuProvider?

   @available(iOS 16.0, *)
   override func editMenu(
      for textRange: UITextRange,
      suggestedActions: [UIMenuElement]
   ) -> UIMenu? {

      if let ctxMenuProvider {
         return ctxMenuProvider.contextMenu(
            textView: self,
            textRange: textRange)
      } else {
         return UIMenu(children: suggestedActions)
      }
   }
}
