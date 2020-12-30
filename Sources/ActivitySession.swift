//
//  ActivitySession.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

struct ActivitySession {
   var title: String
   var createdAt: Date = Date()
   var groupedEvents: [GroupedActivityEvent]
   var isActive: Bool = false

   var events: [ActivityEvent] {
      return groupedEvents.map { $0.event }
   }
}

struct GroupedActivityEvent: Codable {
   var subsystem: String
   var event: ActivityEvent
}
