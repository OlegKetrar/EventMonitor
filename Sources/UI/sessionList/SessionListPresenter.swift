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

   typealias OnSessionSelectCallback = (
      SessionIdentifier,
      @escaping () -> Void
   ) -> Void

   private var onSelectSessionCallback: OnSessionSelectCallback = { _, _ in }
   private var onCloseButtonCallback: (() -> Void)? = nil

   init(repository: SessionListRepository) {
      viewModel = SessionListViewModel(repository: repository)
   }

   func onSelectSession(_ callback: @escaping OnSessionSelectCallback) -> Self {
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

      if let selectedSession = viewModel.getSessionIdentifier(at: index) {
         onSelectSessionCallback(selectedSession, completion)
      } else {
         completion()
      }
   }

   @objc private func actionDone() {
      onCloseButtonCallback?()
   }
}
