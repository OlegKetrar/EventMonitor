//
//  EventDetailsViewModel.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

struct NetworkEventDetailsViewState {
   var titleString: String
   var requestVerb: String
   var statusString: String
   var isFailed: Bool

   var postParameters: String?
   var headers: String
   var response: String
}

final class NetworkEventDetailsViewModel {
   private let event: NetworkEvent
   private let subsystem: String

   let state: NetworkEventDetailsViewState

   init(event: NetworkEvent, subsystem: String) {
      self.event = event
      self.subsystem = subsystem
      self.state = event.format()
   }

   func formatEvent() -> String {
      fatalError()
   }
}

private extension NetworkEvent {

   func format() -> NetworkEventDetailsViewState {
      NetworkEventDetailsViewState(
         titleString: formattedTitle(),
         requestVerb: request.verb.uppercased(),
         statusString: formattedStatusString(),
         isFailed: response.failureReason != nil,
         postParameters: request.getFormattedPostParameters(),
         headers: request.getFormattedHeaders() ?? "",
         response: response.jsonString ?? "no-response")
   }

   func formattedTitle() -> String {
      "\(request.basepoint)\(request.method)\(request.getParams)"
   }

   func formattedStatusString() -> String {
      let codeStr = response.statusCode.map { "\($0)" } ?? "no-status-code"

      if let failureStr = response.failureReason {
         return "\(codeStr) FAILURE\n\(failureStr)"
      } else {
         return "\(codeStr) SUCCESS"
      }
   }
}

private extension NetworkEvent.Request {

   func getFormattedHeaders() -> String? {
      headers.isEmpty
         ? nil
         : headers.semicolonSeparatedPairList()
   }

   func getFormattedPostParameters() -> String? {
      postParams.isEmpty
         ? nil
         : postParams.semicolonSeparatedPairList()
   }
}

private extension Dictionary where Key == String, Value == String {

   func semicolonSeparatedPairList() -> String {
      self.map { "\($0) : \($1)" }.joined(separator: "\n")
   }
}

private extension GroupedEvent {

   var fileName: String {
      fatalError()
//      return "\(request.verb)\(request.method).log"
//         .replacingOccurrences(of: "/", with: "_")
//         .lowercased()
   }
}
