//
//  EventConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//

import Foundation
import UIKit
import MonitorCore
import MonitorUI

struct EventConfig {
   private var configs: [AnyEventConfiguration] = []

   mutating func add<ConcreteEvent>(
      _ config: some EventConfiguration<ConcreteEvent>
   ) {

      configs.append(AnyEventConfiguration(
         config: config,
         sharing: Optional<NullConfiguration<ConcreteEvent>>.none))
   }

   mutating func add<ConcreteEvent>(
      _ config: some EventConfiguration<ConcreteEvent> & SharingConfiguration<ConcreteEvent>
   ) {

      configs.append(AnyEventConfiguration(config: config, sharing: config))
   }
}

// MARK: - EventViewConfig

extension EventConfig: EventViewConfig {

   func configure(tableView: UITableView) {
      configs.forEach {
         $0.configureTableView(tableView)
      }
   }

   func makeCell(
      tableView: UITableView,
      indexPath: IndexPath,
      event: AnyEvent
   ) -> UITableViewCell? {

      configs
         .lazy
         .compactMap {
            $0.makeCell(tableView, indexPath, event)
         }
         .first
   }

   func makeDetailViewController(
      event: AnyEvent,
      navigation: UINavigationController?
   ) -> UIViewController? {

      configs
         .lazy
         .compactMap { $0.makeDetailViewController(event, navigation) }
         .first
   }

   func formatSession(_ session: EventSession) -> String {

      let formatter = SessionFormatter(
         header: { _ in nil },
         separator: "",
         terminator: "\n\n",
         eventFormatter: { anyEvent in
            configs
               .lazy
               .compactMap { $0.formatEvent(anyEvent) }
               .first
               ?? ""
         })

      return formatter.formatSession(session)
   }
}

// MARK: - Type erasure

struct AnyEventConfiguration {
   let configureTableView: (UITableView) -> Void
   let makeCell: (UITableView, IndexPath, AnyEvent) -> UITableViewCell?
   let makeDetailViewController: (AnyEvent, UINavigationController?) -> UIViewController?
   let formatEvent: (AnyEvent) -> String?

   init<Configuration, Sharing>(config: Configuration, sharing: Sharing?)
   where
      Configuration: EventConfiguration,
      Configuration.EventCell: UITableViewCell,
      Sharing: SharingConfiguration,
      Configuration.Event == Sharing.Event
   {

      self.configureTableView = { tableView in
         tableView.register(
            Configuration.EventCell.self,
            forCellReuseIdentifier: Configuration.EventCell.reuseID)
      }

      self.makeCell = { tableView, indexPath, anyEvent in

         let anyCell = tableView.dequeueReusableCell(
            withIdentifier: Configuration.EventCell.reuseID,
            for: indexPath)

         guard
            let cell = anyCell as? Configuration.EventCell,
            let event = anyEvent.payload as? Configuration.Event
         else { return nil }

         return config.configure(cell: cell, event: event)
      }

      self.makeDetailViewController = { anyEvent, navigation in
         guard let event = anyEvent.payload as? Configuration.Event else {
            return nil
         }

         let menuActions = config.actions.map {
            AnyEventMenuItem(event: event, action: $0)
         }

         return config.buildDetailView(
            event: event,
            menuItems: menuActions,
            navigation: navigation)
      }

      self.formatEvent = { anyEvent in
         guard
            let event = anyEvent.payload as? Sharing.Event,
            let sharing = sharing
         else { return nil }

         return sharing.format(event: event)
      }
   }
}

struct AnyEventMenuItem: EventMenuItem {
   let title: String
   let image: UIImage
   private let performFunction: (UINavigationController?) async throws -> Void

   init<Event>(event: Event, action: any EventContextAction<Event>) {
      self.title = action.title
      self.image = action.image

      self.performFunction = {
         try await action.perform(event, navigation: $0)
      }
   }

   func perform(_ ctx: UINavigationController?) async throws {
      try await performFunction(ctx)
   }
}

private struct NullConfiguration<Event>: SharingConfiguration {
   func format(event: Event) -> String { "" }
   func makeFileName(event: Event) -> String { "" }
}

// MARK: reuseID

private extension UITableViewCell {
   static var reuseID: String { String(describing: self) }
}
