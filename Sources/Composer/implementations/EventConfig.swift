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

      self.makeDetailViewController = { anyEvent in
         guard let event = anyEvent.payload as? Factory.Event else {
            return nil
         }

         return factory.buildDetailView(
            event: event,
            menuViewModel: EventContextMenu(items: []))
      }
   }
}

extension UITableViewCell {
   static var reuseID: String { String(describing: self) }
}

struct EventMenuItem: EventMenuUIItem {
   let title: String
   let image: UIImage
   let select: () async throws -> Void

   init<Event>(event: Event, action: any EventContextAction<Event>) {
      self.title = action.title
      self.image = action.image
      self.select = { try await action.perform(event) }
   }
}

class EventContextMenu: EventMenuViewModel {
   var _items: [EventMenuItem]

   var items: [EventMenuUIItem] {
      _items
   }

   init(items: [EventMenuItem]) {
      self._items = items
   }

   func selectItem(at index: Int) async throws {
      if _items.indices.contains(index) {
         try await _items[index].select()
      }
   }
}
