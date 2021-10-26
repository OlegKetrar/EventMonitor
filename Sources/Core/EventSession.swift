//
//  EventSession.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct EventSession {
   public let identifier: SessionIdentifier
   public var isActive: Bool
   public var events: [GroupedEvent]
}

public struct SessionInfo {
   public var identifier: SessionIdentifier
   public var isActive: Bool
}

public struct StoredSession {
   public var identifier: SessionIdentifier

   public init(identifier: SessionIdentifier) {
      self.identifier = identifier
   }
}

public struct SessionIdentifier: Equatable, Comparable {
   public var timestamp: Int

   public init(_ timestamp: Double = Date().timeIntervalSince1970) {
      self.timestamp = Int(timestamp)
   }

   public static func ==(
      lhs: SessionIdentifier,
      rhs: SessionIdentifier
   ) -> Bool {
      lhs.timestamp == rhs.timestamp
   }

   public static func <(
      lhs: SessionIdentifier,
      rhs: SessionIdentifier
   ) -> Bool {
      lhs.timestamp < rhs.timestamp
   }

   public var createdAt: Date {
      Date(timeIntervalSince1970: Double(timestamp))
   }
}
