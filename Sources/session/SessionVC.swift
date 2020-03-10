//
//  SessionVC.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

final class SessionVC: TrackableViewController, HavePreloaderButton, HaveShareButton {
   var presenter: SessionPresenter!
   private var session: ActivitySession!

   private lazy var tableView = UITableView(frame: .zero, style: .plain).with {
      $0.register(cell: EventCell.self)
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

      session = presenter.session.value
      defaultConfiguring()

      presenter.session.notify(
         observer: self,
         on: .main,
         callback: { vc, newSession in
            vc.session = newSession
            vc.tableView.reloadData()
      })
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if let indexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: indexPath, animated: true)
      }
   }

   override var screen: Screen {
      return .session
   }

   // MARK: - Actions

   @objc func actionShare() {
      navigationItem.rightBarButtonItem = configuredPreloaderBarButton()

      presenter.share { [weak self] in
         self?.navigationItem.rightBarButtonItem = self?.configuredShareButton()
      }
   }
}

// MARK: - UITableViewDataSource

extension SessionVC: UITableViewDataSource {

   func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {

      return session.events.count
   }

   func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let item = session.events[indexPath.row]

      return tableView
         .dequeue(cell: EventCell.self, for: indexPath)
         .with(verb: item.request.verb.uppercased())
         .with(request: item.request.method)
         .with(success: item.response.failureReason == nil)
   }
}

// MARK: - UITableViewDelegate

extension SessionVC: UITableViewDelegate {

   func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath) {

      presenter.selectEvent(at: indexPath.row)
   }
}

// MARK: - Private

private extension SessionVC {

   func defaultConfiguring() {

      navigationItem.title = session.title
      navigationItem.rightBarButtonItem = configuredShareButton()
      view.backgroundColor = .grayBackground
      view.addSubview(tableView)

      NSLayoutConstraint.activate([
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      tableView.dataSource = self
      tableView.delegate = self
   }
}
