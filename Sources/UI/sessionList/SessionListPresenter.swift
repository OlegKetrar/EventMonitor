//
//  SessionListPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

final class SessionListPresenter: SessionListVCPresenter {
   let viewModel: SessionListViewModel

   private var onSelectSessionCallback: (ActivitySession) -> Void = { _ in }
   private var onCloseButtonCallback: (() -> Void)? = nil

   init() {
//      self.sessions = sessions.map { $0.value }
//      self.observableSessions = sessions
//      monitor.getObservableActivitySessions()

      self.viewModel = SessionListViewModel(provider: { fatalError() }())
   }

   func onSelectSession(
      _ callback: @escaping (ActivitySession) -> Void
   ) -> Self {

      self.onSelectSessionCallback = callback
      return self
   }

   func withCloseButton(_ closure: @escaping () -> Void) -> Self {
      self.onCloseButtonCallback = closure
      return self
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      let listVC = SessionListVC(presenter: self)

      // Add close button when needed
      if onCloseButtonCallback != nil {
         listVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(actionDone))
      }

      nc.pushViewController(listVC, animated: animated)
   }

   func selectSession(at index: Int, completion: @escaping () -> Void) {
      // get session by id from viewModel
      // call delegate method
   }

   @objc private func actionDone() {
      onCloseButtonCallback?()
   }
}
