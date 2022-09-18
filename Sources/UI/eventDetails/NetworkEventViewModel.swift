//
//  NetworkEventViewModel.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

struct NetworkEventViewModel {
   var titleString: String
   var requestVerb: String
   var statusString: String
   var isFailed: Bool

   var postParameters: String?
   var headers: String
   var response: String
}

extension NetworkEventViewModel {

   init(_ event: NetworkEvent) {
      self.init(
         titleString: event.formattedTitle(),
         requestVerb: event.request.verb.uppercased(),
         statusString: event.formattedStatusString(),
         isFailed: event.response.failureReason != nil,
         postParameters: event.request.getFormattedPostParameters(),
         headers: event.request.getFormattedHeaders() ?? "",
         response: event.response.jsonString ?? "no-response")
   }
}

// MARK: - Private

private extension NetworkEvent {

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
