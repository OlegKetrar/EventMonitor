//
//  ActivitySession.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct ActivitySession {
   public var title: String
   public var createdAt: Date = Date()
   public var groupedEvents: [GroupedEvent]
   public var isActive: Bool = false

   public var events: [Event] {
      groupedEvents.map { $0.event }
   }
}

public struct StoredEventSession {
   public var createdAt: Date

   public init(createdAt: Date = Date()) {
      self.createdAt = createdAt
   }
}
