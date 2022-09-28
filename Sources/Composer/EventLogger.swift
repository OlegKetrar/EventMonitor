//
//  EventLogger.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import MonitorCore

protocol LoggerImpl {
   func log<T: Event>(event: T, subsystem: String)
}

/// Wrapper.
public struct EventLogger {
   let subsystem: String
   let impl: LoggerImpl

   public func log<T: Event>(_ event: T) {
      impl.log(event: event, subsystem: subsystem)
   }
}
