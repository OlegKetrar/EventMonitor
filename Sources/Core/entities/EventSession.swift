//
//  EventSession.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

public struct EventSession {
   public let identifier: SessionIdentifier
   public var isActive: Bool
   public var events: [AnyEvent]
}

public struct SessionInfo {
   public var identifier: SessionIdentifier
   public var isActive: Bool
}
