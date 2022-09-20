//
//  AnyEvent.swift
//
//
//  Created by Oleg Ketrar on 19.09.2022.
//

public struct AnyEvent {
   public var subsystem: String
   public var type: Any.Type
   public var payload: Any

   public init<T: Event>(_ event: GroupedEvent<T>) {
      self.subsystem = event.0
      self.type = T.self
      self.payload = event.1
   }
}
