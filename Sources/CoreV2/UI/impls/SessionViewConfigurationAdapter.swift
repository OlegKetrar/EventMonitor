//
//  SessionViewConfigurationAdapter.swift
//
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation
import UIKit

struct SessionViewConfigurationAdapter: SessionViewConfiguration {

   let events: [AnyEvent]
   let factories: [AnyEventViewFactory]

   func configure(tableView: UITableView) {
      factories.forEach {
         $0.configureTableView(tableView)
      }
   }

   func getItemsCount() -> Int {
      events.count
   }

   func makeCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
      factories
         .lazy
         .compactMap {
            $0.makeCell(events, indexPath, tableView)
         }
         .first ?? UITableViewCell()
   }

   func makeDetailViewController(for indexPath: IndexPath) -> UIViewController? {
      guard events.indices.contains(indexPath.row) else { return nil }

      let event = events[indexPath.row]

      return factories
         .lazy
         .compactMap { $0.makeDetailViewController(event) }
         .first
   }
}

struct AnyEventViewFactory {
   let configureTableView: (UITableView) -> Void
   let makeCell: ([AnyEvent], IndexPath, UITableView) -> UITableViewCell?
   let makeDetailViewController: (AnyEvent) -> UIViewController?

   init<Factory>(_ factory: Factory)
   where
      Factory: EventViewConfiguration,
      Factory.EventCell: UITableViewCell
   {

      self.configureTableView = { tableView in
         tableView.register(
            Factory.EventCell.self,
            forCellReuseIdentifier: Factory.EventCell.reuseID)
      }

      self.makeCell = { allEvents, indexPath, tableView in

         let anyCell = tableView.dequeueReusableCell(
            withIdentifier: Factory.EventCell.reuseID,
            for: indexPath)

         guard
            allEvents.indices.contains(indexPath.row),
            let cell = anyCell as? Factory.EventCell,
            let event = allEvents[indexPath.row] as? Factory.Event
         else { return nil }

         return factory.configure(cell: cell, event: event)
      }

      self.makeDetailViewController = { anyEvent in
         if let event = anyEvent as? Factory.Event {
            return factory.buildDetailView(event)
         } else {
            return nil
         }
      }
   }
}
