//
//  EventProcessor.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public final class EventProcessor {
   private let storage: EventStorage
   private let activeSession: Observable<EventSession>
   private let sessionExport: ExportCapability<SessionFormatting>
   private var eventExport: [ExportCapability<EventFormatting>]

   public init(storage: EventStorage) {
      let activeSessionID = SessionIdentifier()

      self.storage = storage
      self.storage.startSession(identifier: activeSessionID)

      let defaultFormatter = PlainTextFormatter()

      let sessionFormatter = SessionFormatter(
         header: { "Created at: \($0.identifier.timestamp)" },
         separator: "--> ",
         terminator: "\n\n",
         eventFormatter: defaultFormatter)

      self.sessionExport = ExportCapability(
         name: "plain text",
         exporter: FileExporter(formatter: sessionFormatter))

      self.eventExport = [
         ExportCapability(
            name: "plain text",
            exporter: FileExporter(formatter: defaultFormatter))
      ]

      self.activeSession = Observable(EventSession(
         identifier: activeSessionID,
         isActive: true,
         events: []))
   }

   public func setExportOptions(_ options: [ExportOption]) {
      self.eventExport.append(contentsOf: options.map {
         switch $0 {
         case let .eventOption(name, formatter):
            return ExportCapability(
               name: name,
               exporter: FileExporter(formatter: formatter))
         }
      })
   }

   public func log(event: GroupedEvent) {
      activeSession.mutate {
         $0.events.append(event)
      }

      storage.write(event: event)
   }
}

extension EventProcessor: EventProvider {

   public func fetchSessions() -> Observable<[SessionInfo]> {
      var allSessions: [SessionInfo] = [
         SessionInfo(
            identifier: activeSession.value.identifier,
            isActive: true)
      ]

      storage.readStoredSessions {
         allSessions.append(contentsOf: $0.map {
            SessionInfo(
               identifier: $0,
               isActive: false)
         })
      }

      return Observable(allSessions)
   }

   public func fetchActiveSession() -> Observable<EventSession> {
      activeSession
   }

   public func fetchEventSession(
      identifier: SessionIdentifier,
      completion: @escaping (Observable<EventSession>) -> Void
   ) {

      if identifier == activeSession.value.identifier {
         completion(activeSession)

      } else {
         storage.readEvents(
            sessionIdentifier: identifier,
            completion: {
               completion(Observable(EventSession(
                  identifier: identifier,
                  isActive: false,
                  events: $0)))
            })
      }
   }

   public func sessionExportCapability() -> ExportCapability<SessionFormatting> {
      sessionExport
   }

   public func eventExportCapabilities() -> [ExportCapability<EventFormatting>] {
      eventExport
   }
}
