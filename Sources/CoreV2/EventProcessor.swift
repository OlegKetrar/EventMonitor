//
//  EventProcessor.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation

public protocol EventStorage {}

public class EventProcessor {
//   private var loggers: [Any] = []

//   func register<T, UIConfiguration, Action>(
//      event: T.Type,
//      configuration: UIConfiguration,
//      contextActions: [Action]
//   ) where
//      T: Event,
//      UIConfiguration: EventViewConfiguration,
//      Action: EventContextAction,
//      UIConfiguration.Event == T,
//      UIConfiguration.EventView == Config.EventView,
//      UIConfiguration.EventDetailView == Config.EventDetailView,
//      Action.Event == T
//   {
//
//      let logger = EventLogger<T>(logFunction: {
//         print("-- log: \($0)")
//      })
//
//      loggers.append(logger)
//   }

   public init(storage: EventStorage) {

   }

   public func log<T: Event>(event: T) {
   }

//   func getLogger<T: Event>(for type: T.Type) -> EventLogger<T>? {
//      loggers.lazy
//         .compactMap { $0 as? EventLogger<T> }
//         .first
//   }
}
