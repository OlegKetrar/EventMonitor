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
public typealias EventMenuItem = MonitorUI.EventMenuItem

public class MonitorComposer {
   public static let shared = MonitorComposer()

   private var viewConfig = EventConfig()
   private var initialSubsystemFilters: [String] = []

   private lazy var lastUsedFiltering = FilterModel<String>(
      applied: initialSubsystemFilters)

   private let processor: EventProcessor = {
      let tmpDir = NSTemporaryDirectory() as NSString
      let path = tmpDir.appendingPathComponent("event-monitor.session-logs")
      let store = FileEventStorage(directoryPath: path)
      let processor = EventProcessor(storage: store)

      return processor
   }()

   public private(set) lazy var presenter = PresenterConfig(viewFactory: {
      UIKitMonitorView(
         provider: self.processor,
         config: { session, navigation in

            let viewModel = SessionViewModel(
               session: session,
               filtering: self.lastUsedFiltering)

            return SessionViewAdapter(
               viewModel: viewModel,
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

   public func register<SomeEvent, Configuration>(
      event: SomeEvent.Type,
      configuration: Configuration
   ) where
      SomeEvent: Event,
      Configuration: EventConfiguration,
      Configuration.Event == SomeEvent
   {

      TypeRegistry.register(
         id: String(describing: event),
         value: event)

      viewConfig.add(configuration)
   }

   public func registerCustomNetwork<SomeEvent: CustomNetworkEvent>(
      event: SomeEvent.Type,
      configuration builder: (NetworkEventConfig<SomeEvent>) -> NetworkEventConfig<SomeEvent>
   ) {

      let networkConfig = NetworkEventConfig<SomeEvent>()

      register(
         event: event,
         configuration: builder(networkConfig))
   }

   public func setInitialSubsystems(_ subsystems: [String]) {
      initialSubsystemFilters = subsystems
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
