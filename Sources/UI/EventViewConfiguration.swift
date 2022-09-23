//
//  EventViewConfiguration.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import UIKit

public protocol EventViewConfiguration<Event> {
   associatedtype Event
   associatedtype EventCell: UITableViewCell & HaveReuseIdentifier

   func configure(cell: EventCell, event: Event) -> EventCell
   func buildDetailView(_ event: Event) -> UIViewController?
}

public protocol HaveReuseIdentifier {
   static var reuseID: String { get }
}
