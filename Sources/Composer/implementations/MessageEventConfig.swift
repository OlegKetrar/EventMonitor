//
//  MessageEventConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI
import MonitorCore

extension MessageEvent: Event {}

struct MessageEventConfig: EventConfiguration {
   typealias Event = MonitorUI.MessageEvent

   func configure(
      cell: MessageEventCell,
      event: MonitorUI.MessageEvent
   ) -> MessageEventCell {

      return cell.with(text: event.message)
   }

   func buildDetailView(
      event: MonitorUI.MessageEvent,
      menuItems: [any MonitorUI.EventMenuItem],
      navigation: UINavigationController?
   ) -> UIViewController? {
      return nil
   }

   func format(event: MessageEvent) -> String {
      event.message
   }
}
