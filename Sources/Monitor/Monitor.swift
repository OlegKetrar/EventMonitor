//
//  Monitor.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

public typealias Event = MonitorCore.Event
public typealias NetworkEvent = MonitorCore.NetworkEvent
public typealias GroupedEvent = MonitorCore.GroupedEvent
public typealias ExportOption = MonitorCore.ExportOption
public typealias EventFormatting = MonitorCore.EventFormatting

public final class Monitor {

   private static let processor: EventProcessor = {
      let tmpDir = NSTemporaryDirectory() as NSString
      let path = tmpDir.appendingPathComponent("network-monitor.session-logs")
      let store = FileEventStorage(directoryPath: path)
      let processor = EventProcessor(storage: store)

      return processor
   }()

   @available(*, unavailable, message: "Unimplemented yet")
   public static func setExportOptions(_ options: [ExportOption]) {
      processor.setExportOptions(options)
   }

   public static let presenter = PresenterConfig(provider: processor)

   public static func makeLogger(subsystem: String) -> Logger {
      LoggerImpl {
         processor.log(event: GroupedEvent(subsystem: subsystem, event: $0))
      }
   }
}

private class LoggerImpl: Logger {
   private let logFunction: (Event) -> Void

   init(_ logFunction: @escaping (Event) -> Void) {
      self.logFunction = logFunction
   }

   func log(event: Event) {
      logFunction(event)
   }
}
