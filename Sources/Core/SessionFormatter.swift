//
//  SessionFormatter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public struct SessionFormatter {
   public typealias AnyEventFormatter = (AnyEvent) -> String

   let header: (EventSession) -> String?
   let separator: String
   let terminator: String
   let eventFormatter: AnyEventFormatter

   public init(
      header: @escaping (EventSession) -> String? = { _ in nil },
      separator: String = "",
      terminator: String = "\n\n",
      eventFormatter: @escaping AnyEventFormatter
   ) {
      self.header = header
      self.separator = separator
      self.terminator = terminator
      self.eventFormatter = eventFormatter
   }

   public func formatSession(_ session: EventSession) -> String {
      let headerStr = header(session).flatMap { "\($0)\(terminator)" } ?? ""

      return headerStr + session.events
         .map { "\(separator)\(eventFormatter($0))" }
         .joined(separator: terminator)
   }
}
