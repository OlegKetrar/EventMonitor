//
//  Monitor.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 21.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore
import MonitorUI

public typealias Event = MonitorCore.Event
public typealias NetworkEvent = MonitorCore.NetworkEvent
public typealias MessageEvent = MonitorCore.MessageEvent

public final class Monitor {

   private static let processor = EventProcessor(storage: {
      let tmpDir = NSTemporaryDirectory() as NSString
      let path = tmpDir.appendingPathComponent("network-monitor.session-logs")

      return FileEventStorage(directoryPath: path)
   }())

   public static var exportOptions: [ExportOption] = [
      // .. default
   ]

   public static let presenter = PresenterConfig(
      getExportOptions: { exportOptions },
      getEventProvider: { processor })

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
