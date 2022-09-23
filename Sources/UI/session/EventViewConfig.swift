//
//  EventViewConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation
import UIKit
import MonitorCore

public struct EventViewConfig {
   var factories: [AnyEventViewFactory] = []

   public init() {}

   public mutating func add<ConcreteEvent: Event>(
      _ factory: any EventViewConfiguration<ConcreteEvent>
   ) {

      factories.append(AnyEventViewFactory(factory))
   }
}

extension EventViewConfig {

   public func configure(tableView: UITableView) {
      factories.forEach {
         $0.configureTableView(tableView)
      }
   }

   public func makeCell(
      tableView: UITableView,
      indexPath: IndexPath,
      event: AnyEvent
   ) -> UITableViewCell? {

      factories
         .lazy
         .compactMap {
            $0.makeCell(tableView, indexPath, event)
         }
         .first
   }

   public func makeDetailViewController(event: AnyEvent) -> UIViewController? {
      factories
         .lazy
         .compactMap { $0.makeDetailViewController(event) }
         .first
   }
}

struct AnyEventViewFactory {
   let configureTableView: (UITableView) -> Void
   let makeCell: (UITableView, IndexPath, AnyEvent) -> UITableViewCell?
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

      self.makeCell = { tableView, indexPath, anyEvent in

         let anyCell = tableView.dequeueReusableCell(
            withIdentifier: Factory.EventCell.reuseID,
            for: indexPath)

         guard
            let cell = anyCell as? Factory.EventCell,
            let event = anyEvent.payload as? Factory.Event
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
