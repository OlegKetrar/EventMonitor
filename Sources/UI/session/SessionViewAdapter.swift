//
//  SessionViewAdapter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

struct SessionViewAdapter: SessionViewConfiguration {

   let viewModel: SessionViewModel
   let config: EventViewConfig
   let navigation: UINavigationController?

   private var events: [AnyEvent] {
      viewModel.state.value.events
   }

   func configure(tableView: UITableView) {
      config.configure(tableView: tableView)
   }

   func getItemsCount() -> Int {
      events.count
   }

   func makeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
      let allEvents = events
      let index = indexPath.row

      guard allEvents.indices.contains(index) else {
         return UITableViewCell()
      }

      return config
         .makeCell(
            tableView: tableView,
            indexPath: indexPath,
            event: allEvents[index])
         ?? UITableViewCell()
   }

   func didSelectCell(at indexPath: IndexPath) {

      if let viewController = makeDetailViewController(for: indexPath) {
         navigation?.pushViewController(viewController, animated: true)
      }
   }

   func makeDetailViewController(for indexPath: IndexPath) -> UIViewController? {
      let allEvents = events
      let index = indexPath.row

      guard allEvents.indices.contains(index) else {
         return nil
      }

      return config.makeDetailViewController(event: allEvents[index])
   }
}
