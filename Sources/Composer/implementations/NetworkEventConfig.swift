//
//  NetworkEventConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI
import MonitorCore

extension MonitorUI.NetworkEvent: Event {}

struct NetworkEventConfig: EventConfiguration {
   typealias Event = MonitorUI.NetworkEvent

   enum NetworkEventAction: String, CaseIterable, EventContextAction {

      case shareLog = "Copy log"
      case cUrl = "Copy cURL"
      case tasteIt = "Test it"

      var title: String {
         rawValue
      }

      var image: UIImage {
         switch self {
         case .shareLog: return UIImage()
         case .cUrl: return UIImage()
         case .tasteIt: return UIImage()
         }
      }

      func perform(_ event: MonitorUI.NetworkEvent) async throws {
         switch self {
         case .shareLog: break
         case .cUrl: break
         case .tasteIt: break
         }
      }
   }

   func configure(cell: NetworkEventCell, event: MonitorUI.NetworkEvent) -> NetworkEventCell {
      cell.with(verb: event.request.verb.uppercased())
      cell.with(request: event.request.method)
      cell.with(success: event.response.failureReason == nil)

      return cell
   }

   func buildDetailView(
      event: MonitorUI.NetworkEvent,
      menuViewModel: EventMenuViewModel
   ) -> UIViewController? {

      let menuConfig = MenuPopoverBuilder
         .init(viewModel: menuViewModel)
         .makeConfiguration()

      return NetworkEventDetailsVC(
         viewModel: NetworkEventViewModel(event),
         menuConfiguration: menuConfig)
   }

   var actions = NetworkEventAction.allCases
}
