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
      configs.append(AnyEventConfiguration(config))
   }
}

// MARK: - EventViewConfig

extension EventConfig: EventViewConfig {

   private static let df: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateStyle = .medium
      formatter.timeStyle = .long

      return formatter
   }()

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
         header: {
            """
            Created at: \($0.identifier.timestamp)
                        \(Self.df.string(from: $0.identifier.createdAt))
            """
         },
         separator: "--> ",
         terminator: "\n\n",
         eventFormatter: { anyEvent in
            configs
               .lazy
               .compactMap { $0.formatEvent(anyEvent) }
               .first
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

   init<Configuration: EventConfiguration>(_ config: Configuration) {

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
            let event = anyEvent.payload as? Configuration.Event
         else { return nil }

         return config.formatForSessionExport(event: event)
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

// MARK: reuseID

private extension UITableViewCell {
   static var reuseID: String { String(describing: self) }
}
