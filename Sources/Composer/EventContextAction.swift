//
//  EventContextAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import class UIKit.UIImage
import class UIKit.UINavigationController

/// Describes contextual action to perform with custom event.
public protocol EventContextAction<Event> {
   associatedtype Event

   var title: String { get }
   var image: UIImage { get }

   func perform(_ event: Event, navigation: UINavigationController?) async throws
}

public struct AnyEventContextAction<Event>: EventContextAction {
   let action: any EventContextAction<Event>

   public init(_ action: some EventContextAction<Event>) {
      self.action = action
   }

   public var title: String {
      action.title
   }

   public var image: UIImage {
      action.image
   }

   public func perform(_ event: Event, navigation: UINavigationController?) async throws {
      try await action.perform(event, navigation: navigation)
   }
}
