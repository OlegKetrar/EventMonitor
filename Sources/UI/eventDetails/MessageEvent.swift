//
//  MessageEvent.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public struct MessageEvent: Codable {

   public var message: String
   public var file: String
   public var line: UInt
   public var function: String

   public init(
      _ message: String,
      file: String = #file,
      line: UInt = #line,
      function: String = #function
   ) {
      self.message = message
      self.file = file
      self.line = line
      self.function = function
   }
}
