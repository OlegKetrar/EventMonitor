//
//  SessionIdentifier.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct SessionIdentifier: Equatable, Comparable {
   public var timestamp: Int

   public init(_ timestamp: Double = Date().timeIntervalSince1970) {
      self.timestamp = Int(timestamp)
   }

   public var createdAt: Date {
      Date(timeIntervalSince1970: Double(timestamp))
   }

   public static func <(
      lhs: SessionIdentifier,
      rhs: SessionIdentifier
   ) -> Bool {
      lhs.timestamp < rhs.timestamp
   }
}
