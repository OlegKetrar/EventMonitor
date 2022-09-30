//
//  SessionVC.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public class SessionViewController: UIViewController, HavePreloaderButton, HaveShareButton {
   private let config: SessionViewConfiguration
   private var viewState: SessionViewState { config.viewModel.state.value }

   private lazy var tableView = UITableView(frame: .zero, style: .plain).with {
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

   public init(configuration: SessionViewConfiguration) {
      self.config = configuration
      super.init(nibName: nil, bundle: nil)
   }

   required public init?(coder: NSCoder) {
      nil
   }

   // MARK: - Overrides

   override public func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      config.configure(tableView: tableView)
      updateTitle()

      config.viewModel.state.notify(
         observer: self,
         on: .main,
         callback: { vc, _ in
            vc.updateTitle()
            vc.tableView.reloadData()
         })
   }

   override public func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if let indexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: indexPath, animated: true)
      }
   }

   // MARK: - Actions

   @objc func actionShare() {
      navigationItem.rightBarButtonItem = makePreloaderBarButton()

      Task { [self] in
         await config.shareLog(navigation: navigationController)
         navigationItem.rightBarButtonItem = configuredShareButton()
      }
   }
}

// MARK: - UITableViewDataSource

extension SessionViewController: UITableViewDataSource {

   public func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
   ) -> Int {
      config.getItemsCount()
   }

   public func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
   ) -> UITableViewCell {
      config.makeCell(tableView: tableView, indexPath: indexPath)
   }
}

// MARK: - UITableViewDelegate

extension SessionViewController: UITableViewDelegate {

   public func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
   ) {
      config.didSelectCell(at: indexPath)
   }
}

// MARK: - UIContextMenuInteractionDelegate

extension SessionViewController: UIContextMenuInteractionDelegate {

   public func contextMenuInteraction(
      _ interaction: UIContextMenuInteraction,
      configurationForMenuAtLocation location: CGPoint
   ) -> UIContextMenuConfiguration? {

      UIContextMenuConfiguration(
         identifier: nil,
         previewProvider: nil,
         actionProvider: { [weak self] _ in
            self?.makeFiltersMenu()
         })
   }
}

// MARK: - Private

private extension SessionViewController {
   
   func updateTitle() {
      if viewState.hasFilters {
         navigationItem.titleView = makeTitleView(title: viewState.title)
      } else {
         navigationItem.title = viewState.title
      }
   }

   func configureUI() {
      navigationItem.rightBarButtonItem = configuredShareButton()
      view.backgroundColor = .grayBackground
      view.addSubview(tableView)
      disableBackButtonContextMenu()

      NSLayoutConstraint.activate([
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])

      tableView.dataSource = self
      tableView.delegate = self
   }

   func makeTitleView(title: String) -> UIView {
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
      button.contentEdgeInsets.left = 10
      button.contentEdgeInsets.right = 10
      button.contentEdgeInsets.top = 5
      button.contentEdgeInsets.bottom = 5
      button.imageEdgeInsets.top = 2.5
      button.imageEdgeInsets.bottom = 2.5
      button.semanticContentAttribute = .forceRightToLeft
      button.backgroundColor = .grayLightSilver
      button.layer.cornerRadius = 7

      if #available(iOS 14, *) {
         button.menu = makeFiltersMenu()
         button.showsMenuAsPrimaryAction = true
      } else {
         button.addInteraction(UIContextMenuInteraction(delegate: self))
      }

      return button
   }

   func makeFiltersMenu() -> UIMenu {
      UIMenu(
         title: "Filter by subsystem:",
         children: viewState.filters.map { filter in
            UIAction(
               title: filter.title,
               attributes: filter.isAll ? [.destructive] : [],
               state: filter.isApplied ? .on : .off,
               handler: { [weak self] _ in
                  self?.config.viewModel.applyFilter(filter)
               })
         })
   }
}
