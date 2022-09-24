//
//  EventConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorUI
import MonitorCore
import class UIKit.UIImage
import class UIKit.UINavigationController

/// Describes custom events.
public protocol EventConfiguration<Event>: EventViewConfiguration {
   associatedtype EventAction: EventContextAction<Event>
   var actions: [EventAction] { get }
   func format(event: Event) -> String
}

extension EventConfiguration {
   public var actions: [EmptyEventContextAction<Event>] { [] }
}

public struct EmptyEventContextAction<Event>: EventContextAction {
   public let title = String()
   public let image = UIImage()

   public func perform(
      _ event: Event,
      navigation: UINavigationController?) async throws {}
}
