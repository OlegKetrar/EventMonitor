//
//  EventViewConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import UIKit
import MonitorCore

public protocol EventMenuItem {
   var title: String { get }
   var image: UIImage { get }

   func perform(_ ctx: UINavigationController?) async throws
}

public protocol EventMenuItemsProvider {
   var items: [any EventMenuItem] { get }
}

public protocol EventViewConfiguration<Event> {
   associatedtype Event
   associatedtype EventCell: UITableViewCell

   func configure(cell: EventCell, event: Event) -> EventCell

   func buildDetailView(
      event: Event,
      menuItems: [any EventMenuItem],
      navigation: UINavigationController?) -> UIViewController?
}
