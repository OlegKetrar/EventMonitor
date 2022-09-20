//
//  EventLogger.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

/// Wrapper.
public struct EventLogger<Event> {
   let logFunction: (Event) -> Void

   public func log(_ event: Event) {
      logFunction(event)
   }
}
