//
//  AnyEventContextAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 25.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorUI
import MonitorCore
import class UIKit.UIImage
import class UIKit.UINavigationController

struct AnyEventContextAction: EventMenuItem {
   let title: String
   let image: UIImage
   private let performFunction: (UINavigationController?) async throws -> Void

   init<Event>(event: Event, action: any EventContextAction<Event>) {
      self.title = action.title
      self.image = action.image

      self.performFunction = {
         try await action.perform(event, navigation: $0)
      }
   }

   func perform(_ ctx: UINavigationController?) async throws {
      try await performFunction(ctx)
   }
}
