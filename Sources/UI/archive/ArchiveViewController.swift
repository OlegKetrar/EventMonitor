//
//  ArchiveViewController.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

protocol SessionListVCPresenter {
   var viewModel: ArchiveViewModel { get }

   func selectSession(at index: Int, completion: @escaping () -> Void)
}

final class ArchiveViewController: UIViewController {
   private let presenter: SessionListVCPresenter
   private var viewState: ArchiveViewState { presenter.viewModel.state.value }

   // MARK: - Outlets

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
      $0.dataSource = self
      $0.delegate = self
   }

   // MARK: - Interface

   init(presenter: SessionListVCPresenter) {
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
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      if let indexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: indexPath, animated: true)
      }
   }
}

// MARK: - UITableViewDataSource

extension ArchiveViewController: UITableViewDataSource {

   func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
   ) -> Int {
      viewState.titles.count
   }

   func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
   ) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(
         withIdentifier: "cell",
         for: indexPath)

      cell.textLabel?.text = viewState.titles[indexPath.row]
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

extension ArchiveViewController: UITableViewDelegate {

   func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
   ) {

      // TODO: show activityIndicator

      presenter.selectSession(at: indexPath.row) {
         // TODO: hide activityIndicator
      }
   }
}

// MARK: - Private

private extension ArchiveViewController {

   func configureUI() {
      title = "Sessions"
      view.backgroundColor = .grayBackground
      view.addSubview(tableView)

      NSLayoutConstraint.activate([
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
   }
}
