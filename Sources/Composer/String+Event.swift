//
//  String+Event.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 28.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation

extension MonitorComposer {

   public func log(
      _ message: String,
      file: String = #file,
      line: UInt = #line,
      function: String = #function
   ) {

      let event = MessageEvent(message,
         file: file,
         line: line,
         function: function)

      log(event)
   }
}

extension EventLogger {

   public func log(
      _ message: String,
      file: String = #file,
      line: UInt = #line,
      function: String = #function
   ) {

      let event = MessageEvent(message,
         file: file,
         line: line,
         function: function)

      log(event)
   }
}
