//
//  EventDetailsViewModel.swift
//  EventMonitor
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
   private let exportCapabilities: [ExportCapability<EventFormatting>]

   private lazy var exportFileName: String = {
      "\(event.request.verb.lowercased())\(event.request.method).log"
         .replacingOccurrences(of: "/", with: "_")
   }()

   let state: NetworkEventDetailsViewState

   init(
      event: NetworkEvent,
      subsystem: String,
      exportCapabilities: [ExportCapability<EventFormatting>]
   ) {
      self.event = event
      self.subsystem = subsystem
      self.exportCapabilities = exportCapabilities
      self.state = event.format()
   }

   func makeExportableFile(_ completion: @escaping (LocalFileRef?) -> Void) {
      guard let exporter = exportCapabilities.first?.exporter else {
         completion(nil)
         return
      }

      exporter.prepareFile(
         named: exportFileName,
         content: {
            $0.format(GroupedEvent(subsystem: subsystem, event: .network(event)))
         },
         completion: {
            completion($0)
         })
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

   func makeFileName() -> String {
      switch event {
      case let .network(e):
         return "\(e.request.verb)\(e.request.method).log"
            .replacingOccurrences(of: "/", with: "_")
            .lowercased()
      }
   }
}
