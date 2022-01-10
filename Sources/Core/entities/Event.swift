//
//  Event.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public enum Event: Codable {
   case network(NetworkEvent)
}

public struct GroupedEvent: Codable {
   public var subsystem: String
   public var event: Event

   public init(subsystem: String, event: Event) {
      self.subsystem = subsystem
      self.event = event
   }
}
