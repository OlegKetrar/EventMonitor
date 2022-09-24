//
//  EventViewConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import UIKit

public protocol EventViewConfiguration<Event> {
   associatedtype Event
   associatedtype EventCell: UITableViewCell

   func configure(cell: EventCell, event: Event) -> EventCell
   func buildDetailView(_ event: Event) -> UIViewController?
}
