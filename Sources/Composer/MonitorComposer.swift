//
//  MonitorComposer.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore
import MonitorUI
import class UIKit.UIViewController

public typealias Event = MonitorCore.Event

struct ConcreteNetworkEvent: CustomNetworkEvent {
   var networkData: NetworkEvent
   var cUrlRepresentation: String
//   var realRequest: URLRequest
}

public class MonitorComposer {
   public static let shared = MonitorComposer()

   private var viewConfig = EventConfig()

   private let processor: EventProcessor = {
      let tmpDir = NSTemporaryDirectory() as NSString
      let path = tmpDir.appendingPathComponent("network-monitor.session-logs")
      let store = FileEventStorage(directoryPath: path)
      let processor = EventProcessor(storage: store)

      return processor
   }()

   public private(set) lazy var presenter = PresenterConfig(viewFactory: {
      UIKitMonitorView(
         provider: self.processor,
         config: { session, navigation in
            SessionViewAdapter(
               viewModel: SessionViewModel(session: session),
               config: self.viewConfig,
               navigation: navigation)
         })
   })

   init() {
      self.register(
         event: NetworkEvent.self,
         configuration: NetworkEventConfig<NetworkEvent>())

      self.register(
         event: MessageEvent.self,
         configuration: MessageEventConfig())
   }

   public func register<ConcreteEvent, Configuration>(
      event: ConcreteEvent.Type,
      configuration: Configuration
   ) where
      ConcreteEvent: Event,
      Configuration: EventConfiguration,
      Configuration.Event == ConcreteEvent
   {

      TypeRegistry.register(
         id: String(describing: event),
         value: event)

      viewConfig.add(configuration)
   }

   public func log<SomeEvent: Event>(_ event: SomeEvent) {
      processor.log(event: event, subsystem: "default")
   }

   public func makeLogger(subsystem: String) -> EventLogger {
      EventLogger(
         subsystem: subsystem,
         impl: processor)
   }
}

extension EventProcessor: LoggerImpl {}
