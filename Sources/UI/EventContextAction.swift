//
//  EventContextAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import UIKit

public protocol EventContextAction<Event> {
   associatedtype Event

   var title: String { get }
   var image: UIImage { get }

   func perform(_ event: Event) async throws
}

public protocol EventContextActionConfiguraion {
   associatedtype Event
   associatedtype EventAction: EventContextAction<Event>

   var actions: [EventAction] { get }
}

extension EventContextActionConfiguraion {

   public var actions: [EmptyEventContextAction<Event>] {
      []
   }
}

public struct EmptyEventContextAction<Event>: EventContextAction {
   public let title = String()
   public let image = UIImage()

   public func perform(_ event: Event) async throws {}
}
