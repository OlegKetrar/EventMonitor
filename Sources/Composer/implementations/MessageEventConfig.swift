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

   func configure(
      cell: MessageEventCell,
      event: MessageEvent
   ) -> MessageEventCell {

      return cell.with(text: event.message)
   }

   func buildDetailView(
      event: MonitorUI.MessageEvent,
      menuViewModel: MonitorUI.EventMenuViewModel
   ) -> UIViewController? {
      return nil
   }
}
