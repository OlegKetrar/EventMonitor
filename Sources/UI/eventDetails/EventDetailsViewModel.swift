//
//  EventDetailsViewModel.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

struct EventDetailsViewState {
   var postParameters: String? // presenter.event.request.getFormattedPostParameters()
   var headers: String = "" // presenter.event.request.getFormattedHeaders() ?? ""
   var response: String = "" // presenter.event.response.jsonString ?? "no-response"

   var statusString: String = "" // presenter.event.statusString
   var requestVerb: String = "" // presenter.event.request.verb.uppercased()
   var isFailed: Bool = false // presenter.event.response.failureReason == nil
   var titleString: String = "" // presenter.event.titleString
}

final class EventDetailsViewModel {
   let state: Observable<EventDetailsViewState>

   init() {
      self.state = Observable(EventDetailsViewState())
   }

   func formatEvent() -> String {
      fatalError()
   }
}

private extension NetworkEvent {

   var titleString: String {
      return "\(request.basepoint)\(request.method)\(request.getParams)"
   }

   var statusString: String {
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
      guard !headers.isEmpty else { return nil }
      return headers.semicolonSeparatedPairList()
   }

   func getFormattedPostParameters() -> String? {
      guard !postParams.isEmpty else { return nil }
      return postParams.semicolonSeparatedPairList()
   }
}

private extension Dictionary where Key == String, Value == String {

   func semicolonSeparatedPairList() -> String {
      return self
         .map { "\($0) : \($1)" }
         .joined(separator: "\n")
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
