//
//  EventViewConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import UIKit
import MonitorCore

public protocol EventMenuUIItem {
   var title: String { get }
   var image: UIImage { get }
}

public protocol EventMenuViewModel {
   var items: [any EventMenuUIItem] { get }

   func selectItem(at index: Int) async throws
}

public protocol EventViewConfiguration<Event> {
   associatedtype Event
   associatedtype EventCell: UITableViewCell

   func configure(cell: EventCell, event: Event) -> EventCell

   func buildDetailView(
      event: Event,
      menuViewModel: EventMenuViewModel) -> UIViewController?
}
