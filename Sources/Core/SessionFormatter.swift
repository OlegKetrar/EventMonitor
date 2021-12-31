//
//  SessionFormatter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//

import Foundation

public struct SessionFormatter: SessionFormatting {
   let header: (EventSession) -> String?
   let separator: String
   let terminator: String
   let eventFormatter: EventFormatting

   public init(
      header: @escaping (EventSession) -> String? = { _ in nil },
      separator: String = "",
      terminator: String = "\n\n",
      eventFormatter: EventFormatting
   ) {
      self.header = header
      self.separator = separator
      self.terminator = terminator
      self.eventFormatter = eventFormatter
   }

   public func format(_ session: EventSession) -> String {
      let headerStr = header(session).flatMap { "\($0)\(terminator)" } ?? ""

      return headerStr + session.events
         .map { "\(separator)\(eventFormatter.format($0))" }
         .joined(separator: terminator)
   }
}
