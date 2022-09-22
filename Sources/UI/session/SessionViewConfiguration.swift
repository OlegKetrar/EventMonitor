//
//  SessionViewConfiguration.swift
//
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import UIKit

public protocol SessionViewConfiguration {
   func configure(tableView: UITableView)

   func getItemsCount() -> Int
   func makeCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
   func makeDetailViewController(for indexPath: IndexPath) -> UIViewController?

   // TODO: add filtering
}
