//
//  MonitorComposer.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import class UIKit.UIViewController

struct FileStorage: EventStorage {}

public class MonitorComposer {
   public static let shared = MonitorComposer()

   private let processor: EventProcessor = {
      let storage = FileStorage()
      let processor = EventProcessor(storage: storage)

      return processor
   }()

   private var configs: [AnyEventViewFactory] = []

   public func register<SomeEvent, ViewConfiguration>(
      event: SomeEvent.Type,
      configuration: ViewConfiguration
   ) where
      SomeEvent: Event,
      ViewConfiguration: EventViewConfiguration,
      ViewConfiguration.Event == SomeEvent
   {

      configs.append(AnyEventViewFactory(configuration))
   }

   public func log<SomeEvent: Event>(_ event: SomeEvent) {
      processor.log(event: event)
   }

   public func makeView() -> MonitorView {
      UIKitMonitorView(
         provider: processor,
         configs: configs)
   }
}

extension EventProcessor: EventProvider {

   public func getSessions() -> [Session] {
      []
   }

   public func getActiveSession() -> ActiveSession {
      ActiveSession()
   }

   public func getEventsForSession(_ session: Session) -> [AnyEvent] {
      []
   }

   public func getActionsForEvent(_ event: AnyEvent) -> [String] {
      []
   }
}
