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

   public init(storage: EventStorage) {
      let activeSessionID = SessionIdentifier()

      self.storage = storage
      self.storage.startSession(identifier: activeSessionID)

      self.activeSession = Observable(EventSession(
         identifier: activeSessionID,
         isActive: true,
         events: []))
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
               identifier: $0.identifier,
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
}
