//
//  SessionVC.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore
import Dispatch

protocol SessionVCPresenter {
   var viewModel: SessionViewModel { get }

   func selectEvent(at index: Int, completion: @escaping () -> Void)
   func shareSession(_ completion: @escaping () -> Void)
}

final class SessionVC: UIViewController, HavePreloaderButton, HaveShareButton {
   private let presenter: SessionVCPresenter
   private var viewState: SessionViewState { presenter.viewModel.state.value }

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

   init(presenter: SessionVCPresenter) {
      self.presenter = presenter
      super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   // MARK: - Overrides

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      updateTitle()

      presenter.viewModel.state.notify(
         observer: self,
         on: .main,
         callback: { vc, _ in
            vc.updateTitle()
            vc.tableView.reloadData()
         })
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if let indexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: indexPath, animated: true)
      }
   }

   // MARK: - Actions

   @objc func actionShare() {
      navigationItem.rightBarButtonItem = configuredPreloaderBarButton()

      presenter.shareSession { [weak self] in
         self?.navigationItem.rightBarButtonItem = self?.configuredShareButton()
      }
   }
}

// MARK: - UITableViewDataSource

extension SessionVC: UITableViewDataSource {

   func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
   ) -> Int {
      viewState.events.count
   }

   func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
   ) -> UITableViewCell {

      switch viewState.events[indexPath.row] {
      case let .message(msgEvent):
         // FIXME:

         return tableView
            .dequeue(cell: EventCell.self, for: indexPath)
            .with(verb: "lol")
            .with(request: msgEvent)
            .with(success: false)

      case let .network(networkEvent):
         return tableView
            .dequeue(cell: EventCell.self, for: indexPath)
            .with(verb: networkEvent.verb)
            .with(request: networkEvent.method)
            .with(success: networkEvent.isSuccess)
      }
   }
}

// MARK: - UITableViewDelegate

extension SessionVC: UITableViewDelegate {

   func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
   ) {

      // TODO: show activity

      presenter.selectEvent(at: indexPath.row) {
         // TODO: hide activity
      }
   }
}

// MARK: - UIContextMenuInteractionDelegate

@available(iOS 13.0, *)
extension SessionVC: UIContextMenuInteractionDelegate {

   func contextMenuInteraction(
      _ interaction: UIContextMenuInteraction,
      configurationForMenuAtLocation location: CGPoint
   ) -> UIContextMenuConfiguration? {

      UIContextMenuConfiguration(
         identifier: nil,
         previewProvider: nil,
         actionProvider: { [weak self] _ in
            (self?.viewState.filters).map {
               UIMenu(
                  title: "Filter by subsystem:",
                  children: $0.map { filter in
                     UIAction(
                        title: filter.title,
                        attributes: filter.isAll ? [.destructive] : [],
                        state: filter.isApplied ? .on : .off,
                        handler: { _ in
                           self?.presenter.viewModel.filterEvents(by: filter)
                        })
                  })
            }
         })
   }
}

// MARK: - Private

private extension SessionVC {

   func updateTitle() {
      if #available(iOS 13.0, *), viewState.hasFilters {
         navigationItem.titleView = makeTitleView(title: viewState.title)
      } else {
         navigationItem.title = viewState.title
      }
   }

   func configureUI() {
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

   @available(iOS 13.0, *)
   func makeTitleView(title: String) -> UIView {
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
      button.addInteraction(UIContextMenuInteraction(delegate: self))
      button.contentEdgeInsets.left = 10
      button.contentEdgeInsets.right = 10
      button.contentEdgeInsets.top = 5
      button.contentEdgeInsets.bottom = 5
      button.imageEdgeInsets.top = 2.5
      button.imageEdgeInsets.bottom = 2.5
      button.semanticContentAttribute = .forceRightToLeft

      button.backgroundColor = .grayLightSilver
      button.layer.cornerRadius = 7

      return button
   }
}
