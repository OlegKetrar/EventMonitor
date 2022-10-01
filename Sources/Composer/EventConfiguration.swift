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

   func formatForSessionExport(event: Event) -> String?
}

extension EventConfiguration {
   public var actions: [AnyEventContextAction<Event>] { [] }
   public func formatForSessionExport(event: Event) -> String? { nil }
}
