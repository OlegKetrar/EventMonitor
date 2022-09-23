//
//  PlainTextFormatter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 16.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
/*
public struct PlainTextFormatter: EventFormatting {
   public init() {}

   public func format(_ event: GroupedEvent) -> String {
      switch event.event {
      case let .network(e):
         return format(event: e)
      }
   }

   func format(event e: NetworkEvent) -> String {

      let statusStr = e.response.failureReason == nil ? "success" : "failure"
      let statusCodeStr = e.response.statusCode.map { "\($0)" } ?? "no-status-code"

      var descriptionStr = """
      \(e.request.verb.uppercased()) \(e.request.basepoint)\(e.request.method)\(e.request.getParams)
      \(statusCodeStr) \(statusStr.uppercased())
      \nheaders: \(e.request.headers.prettyPrintedString)
      """

      if !e.request.postParams.isEmpty {
         descriptionStr += "\n\nparameters: \(e.request.postParams.prettyPrintedString)"
      }

      descriptionStr += "\n\nresponse: \(e.response.jsonString ?? "no-response")"

      if let failureStr = e.response.failureReason {
         descriptionStr += "\n\nresponse-error: \(failureStr)"
      }

      return descriptionStr
   }
}

// MARK: - Convenience

private extension Dictionary {

   var prettyPrintedString: String {
      guard !isEmpty else { return "{}" }

      let pairsStr = reduce("") { str, header in
         var valueStr = "\(header.value)"

         if valueStr.isEmpty {
            valueStr = "\"\""
         }

         return "\(str)\n  \(header.key) : \(valueStr)"
      }

      return "{\(pairsStr)\n}"
   }
}
*/
