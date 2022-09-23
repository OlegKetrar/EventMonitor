//
//  SessionViewConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import class UIKit.UITableView
import class UIKit.UITableViewCell
import class MonitorCore.SessionViewModel

public protocol SessionViewConfiguration {
   var viewModel: SessionViewModel { get }

   func configure(tableView: UITableView)
   func getItemsCount() -> Int
   func makeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
   func didSelectCell(at indexPath: IndexPath)
}
