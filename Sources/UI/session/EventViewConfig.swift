//
//  EventViewConfig.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public protocol EventViewConfig {
   func configure(tableView: UITableView)

   func makeCell(
      tableView: UITableView,
      indexPath: IndexPath,
      event: AnyEvent) -> UITableViewCell?

   func makeDetailViewController(event: AnyEvent) -> UIViewController?
}
