//
//  SessionViewConfigurationAdapter.swift
//
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation
import UIKit
import MonitorCore

public struct SessionViewConfigurationAdapter: SessionViewConfiguration {

   let events: Observable<[AnyEvent]>
   let factories: [AnyEventViewFactory]

   public func configure(tableView: UITableView) {
      factories.forEach {
         $0.configureTableView(tableView)
      }
   }

   public func getItemsCount() -> Int {
      events.value.count
   }

   public func makeCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
      factories
         .lazy
         .compactMap {
            $0.makeCell(events.value, indexPath, tableView)
         }
         .first ?? UITableViewCell()
   }

   public func makeDetailViewController(for indexPath: IndexPath) -> UIViewController? {
      guard events.value.indices.contains(indexPath.row) else { return nil }

      let event = events.value[indexPath.row]

      return factories
         .lazy
         .compactMap { $0.makeDetailViewController(event) }
         .first
   }
}

public struct AnyEventViewFactory {
   public let configureTableView: (UITableView) -> Void
   public let makeCell: ([AnyEvent], IndexPath, UITableView) -> UITableViewCell?
   public let makeDetailViewController: (AnyEvent) -> UIViewController?

   public init<Factory>(_ factory: Factory)
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
            let event = allEvents[indexPath.row].payload as? Factory.Event
         else { return nil }

         return factory.configure(cell: cell, event: event)
      }

      self.makeDetailViewController = { anyEvent in
         if let event = anyEvent.payload as? Factory.Event {
            return factory.buildDetailView(event)
         } else {
            return nil
         }
      }
   }
}
