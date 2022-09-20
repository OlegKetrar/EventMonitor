//
//  AnyEventConfiguration.swift
//
//
//  Created by Oleg Ketrar on 19.09.2022.
//

//struct AnyEventConfiguration<Config: ViewFramework> {
//   let eventType: Any.Type
//   let buildElementFunction: (AnyEvent) -> Config.EventView
//   let buildDetailScreenFunction: (AnyEvent) -> Config.EventDetailView?
//
//   init<T>(
//      _ config: T
//   ) where
//      T: EventViewConfiguration,
//      Config.EventView == T.EventView,
//      Config.EventDetailView == T.EventDetailView
//   {
//
//      self.eventType = T.Event.self
//
//      self.buildElementFunction = { anyEvent in
//         guard let event = anyEvent.payload as? T.Event else {
//            fatalError()
//         }
//
//         return config.buildElement(event)
//      }
//
//      self.buildDetailScreenFunction = { anyEvent in
//         guard let event = anyEvent.payload as? T.Event else {
//            assertionFailure()
//            return nil
//         }
//
//         return config.buildDetailScreen(event)
//      }
//   }
//
//   func buildElement(_ event: AnyEvent) -> Config.EventView {
//      buildElementFunction(event)
//   }
//
//   func buildDetailScreen(_ event: AnyEvent) -> Config.EventDetailView? {
//      buildDetailScreenFunction(event)
//   }
//}
