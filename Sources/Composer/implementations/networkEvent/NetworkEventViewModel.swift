//
//  NetworkEventViewModel.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore
import MonitorUI
import JsonSyntax

struct NetworkEventViewState {

   struct CodeContent {
      var title: String
      var text: NSAttributedString
      var backgroundColor: UIColor
      var menuProvider: CodeViewContextMenuProvider
   }

   var verb: String
   var method: String
   var query: NSAttributedString?
   var basepoint: String
   var status: String
   var failureReason: String?
   var codeBlocks: [CodeContent] = []

   var isFailed: Bool {
      failureReason != nil
   }
}

final class NetworkEventViewModel {
   let theme: JsonCodeTheme
   private(set) var viewState: NetworkEventViewState

   init(_ event: NetworkEvent) {
      self.theme = JsonCodeTheme.postman

      self.viewState = NetworkEventViewState(
         verb: event.request.verb.uppercased(),
         method: event.request.method,
         query: event.formattedQuery(),
         basepoint: event.request.basepoint,
         status: event.response.statusCode.map(String.init) ?? "(null)",
         failureReason: event.response.failureReason.map { "FAILURE: \($0)" })

      if event.request.hasBody, event.request.parameters.isEmpty == false {
         self.viewState.codeBlocks.append(
            NetworkEventViewState.CodeContent(
               title: "PARAMETERS",
               text: formatDictionary(event.request.parameters),
               backgroundColor: theme.backgroundColor,
               menuProvider: CopyContextMenuProvider()))
      }

      if event.request.headers.isEmpty == false {
         self.viewState.codeBlocks.append(
            NetworkEventViewState.CodeContent(
               title: "HEADERS",
               text: formatDictionary(event.request.headers),
               backgroundColor: theme.backgroundColor,
               menuProvider: CopyContextMenuProvider()))
      }

      let jsonTree = event.response.jsonString.flatMap {
         try? JsonSyntax().parse($0)
      }

      self.viewState.codeBlocks.append(
         NetworkEventViewState.CodeContent(
            title: "RESPONSE",
            text: format(
               json: event.response.jsonString ?? "no-response",
               parseTree: jsonTree),
            backgroundColor: theme.backgroundColor,
            menuProvider: CopyContextMenuProvider()))
   }

   func formatDictionary(_ dict: [String : String]) -> NSAttributedString {
      let attrStr = NSMutableAttributedString()

      dict.forEach { key, value in
         attrStr.append(NSAttributedString(
            string: key,
            attributes: [
               .foregroundColor : theme.keyColor
            ]))

         attrStr.append(NSAttributedString(
            string: " : ",
            attributes: [
               .foregroundColor : theme.delimiterColor
            ]))

         attrStr.append(NSAttributedString(
            string: value,
            attributes: [
               .foregroundColor : theme.stringColor
            ]))

         attrStr.append(NSAttributedString(string: "\n"))
      }

      attrStr.addAttribute(
         .font, 
         value: theme.font,
         range: NSRange(location: 0, length: attrStr.length))

      return NSAttributedString(attributedString: attrStr)
   }

   func format(json: String, parseTree: ParseTree?) -> NSAttributedString {

      let attrStr = NSMutableAttributedString(string: json, attributes: [
         .font : theme.font,
         .foregroundColor : theme.textColor
      ])

      guard let parseTree = try? JsonSyntax().parse(json) else {
         return NSAttributedString(attributedString: attrStr)
      }

      parseTree
         .getHighlightTokens()
         .map { $0.convertToHighlight(theme) }
         .forEach {
            attrStr.addAttribute(.foregroundColor, value: $0.color, range: $0.range)
         }

      return NSAttributedString(attributedString: attrStr)
   }
}

// MARK: - Private

private struct Highlight {
    var range: NSRange
    var color: UIColor
}

private extension HighlightToken {

   func convertToHighlight(_ theme: JsonCodeTheme) -> Highlight {
      switch kind {

      case .syntax(.openBracket),
           .syntax(.closeBracket),
           .syntax(.openBrace),
           .syntax(.closeBrace):

         return withColor(theme.bracesColor)

      case .syntax(.colon), .syntax(.comma):
         return withColor(theme.delimiterColor)

      case .literalValue:
         return withColor(theme.literalColor)

      case .numberValue:
         return withColor(theme.numberColor)

      case .stringValue:
         return withColor(theme.stringColor)

      case .key:
         return withColor(theme.keyColor)
      }
   }

   func withColor(_ color: UIColor) -> Highlight {
      Highlight(
         range: NSRange(location: pos.location, length: pos.length),
         color: color)
   }
}

private extension NetworkEvent {

   func formattedQuery() -> NSAttributedString? {
      guard request.hasBody == false, request.parameters.isEmpty == false else {
         return nil
      }

      let attrStr = NSMutableAttributedString()

      request.parameters
         .enumerated()
         .forEach { index, pair in
            attrStr.append(NSAttributedString(
               string: index == 0 ? "? " : "& ",
               attributes: [
                  .font : UIFont.monospacedSystemFont(ofSize: 16, weight: .semibold)
               ]))

            attrStr.append(NSAttributedString(
               string: "\(pair.key) = \(pair.value)",
               attributes: [
                  .font : UIFont.systemFont(ofSize: 16, weight: .regular)
               ]))
         }

      attrStr.addAttribute(
         .foregroundColor,
         value: UIColor.grayPrimaryText,
         range: NSRange(location: 0, length: attrStr.length))

      return attrStr
   }
}
