//
//  SessionListVC.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

final class SessionListVC: TrackableViewController {
   var presenter: SessionListPresenter!

   private lazy var tableView = UITableView(frame: .zero, style: .plain).with {
      $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      $0.rowHeight = UITableView.automaticDimension
      $0.estimatedRowHeight = 50
      $0.contentInset.top = 15
      $0.contentInset.bottom = 30
      $0.separatorColor = .grayLightSilver
      $0.separatorInset.left = 15
      $0.separatorInset.right = 10
      $0.backgroundColor = .clear
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.tableFooterView = UIView()
   }

   // MARK: - Overrides

   override func viewDidLoad() {
      super.viewDidLoad()

      title = "Sessions"
      view.backgroundColor = .grayBackground
      view.addSubview(tableView)

      if presenter.isPresented {
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(actionDone))
      }

      NSLayoutConstraint.activate([
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      tableView.dataSource = self
      tableView.delegate = self
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if let indexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: indexPath, animated: true)
      }
   }

   override var screen: Screen {
      return .sessionList
   }

   @objc private func actionDone() {
      presenter.dismiss()
   }
}

// MARK: - UITableViewDataSource

extension SessionListVC: UITableViewDataSource {

   func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {

      return presenter.sessions.count
   }

   func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(
         withIdentifier: "cell",
         for: indexPath)

      cell.textLabel?.text = {
         let session = presenter.sessions[indexPath.row]
         return session.isActive ? "\(session.title) (active)" : session.title
      }()

      cell.textLabel?.textColor = .grayPrimaryText
      cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
      cell.accessoryType = .disclosureIndicator
      cell.selectionStyle = .gray
      cell.backgroundColor = .clear
      cell.contentView.backgroundColor = .clear

      return cell
   }
}

// MARK: - UITableViewDelegate

extension SessionListVC: UITableViewDelegate {

   func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath) {

      presenter.selectSession(at: indexPath.row)
   }
}
