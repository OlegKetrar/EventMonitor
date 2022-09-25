//
//  File.swift
//  
//
//  Created by Oleg Ketrar on 24.09.2022.
//

import Foundation
import UIKit
import MonitorCore
import MonitorUI

public struct EventConfig {
   var factories: [AnyEventViewFactory] = []

   public init() {}

   public mutating func add<ConcreteEvent: Event>(
      _ factory: any EventConfiguration<ConcreteEvent>
   ) {

      factories.append(AnyEventViewFactory(factory))
   }
}

extension EventConfig: EventViewConfig {

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

   public func makeDetailViewController(
      event: AnyEvent,
      navigation: UINavigationController?
   ) -> UIViewController? {

      factories
         .lazy
         .compactMap { $0.makeDetailViewController(event, navigation) }
         .first
   }

   public func formatSession(_ session: EventSession) -> String {

      let formatter = SessionFormatter(
         header: { _ in nil },
         separator: "",
         terminator: "\n\n",
         eventFormatter: { anyEvent in
            factories
               .lazy
               .compactMap { $0.formatEvent(anyEvent) }
               .first
               ?? ""
         })

      return formatter.formatSession(session)
   }
}

struct AnyEventViewFactory {
   let configureTableView: (UITableView) -> Void
   let makeCell: (UITableView, IndexPath, AnyEvent) -> UITableViewCell?
   let makeDetailViewController: (AnyEvent, UINavigationController?) -> UIViewController?
   let formatEvent: (AnyEvent) -> String?

   init<Factory>(_ factory: Factory)
   where
      Factory: EventConfiguration,
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

      self.makeDetailViewController = { anyEvent, navigation in
         guard let event = anyEvent.payload as? Factory.Event else {
            return nil
         }

         let menuActions = factory.actions.map {
            AnyEventContextAction(event: event, action: $0)
         }

         return factory.buildDetailView(
            event: event,
            menuItems: menuActions,
            navigation: navigation)
      }

      self.formatEvent = { anyEvent in
         guard let event = anyEvent.payload as? Factory.Event else {
            return nil
         }

         return factory.format(event: event)
      }
   }
}

extension UITableViewCell {
   static var reuseID: String { String(describing: self) }
}
