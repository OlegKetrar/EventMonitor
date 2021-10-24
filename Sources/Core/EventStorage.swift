//
//  EventStorage.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public protocol EventStorage {

   /// Return all ended sessions.
   func readStoredSessions(_ completion: @escaping ([StoredEventSession]) -> Void)

   /// Read events for stored session
   func readEvents(
      session: StoredEventSession,
      completion: @escaping ([GroupedEvent]) -> Void)

   /// Start new session with name.
   func startSession(createdAt: Date) // TODO: ID type

   /// Save event to active session.
   func write(event: GroupedEvent)
}
