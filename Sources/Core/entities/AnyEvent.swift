//
//  AnyEvent.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 19.09.2022.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public struct AnyEvent {
   public var subsystem: String
   public var type: any Codable.Type
   public var payload: any Codable

   public init<T: Event>(_ event: T, subsystem: String) {
      self.subsystem = subsystem
      self.type = T.self
      self.payload = event
   }
}
