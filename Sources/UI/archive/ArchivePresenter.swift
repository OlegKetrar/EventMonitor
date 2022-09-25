//
//  ArchivePresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

final class ArchivePresenter: SessionListVCPresenter {
   let viewModel: ArchiveViewModel

   typealias OnSessionSelectCallback = (
      SessionIdentifier,
      @escaping () -> Void
   ) -> Void

   private var onSelectSessionCallback: OnSessionSelectCallback = { _, _ in }
   private var onCloseButtonCallback: (() -> Void)? = nil

   init(repository: ArchiveRepository) {
      viewModel = ArchiveViewModel(repository: repository)
   }

   func onSelectSession(_ callback: @escaping OnSessionSelectCallback) -> Self {
      self.onSelectSessionCallback = callback
      return self
   }

   func setCloseButtonCallback(_ closure: @escaping () -> Void) {
      self.onCloseButtonCallback = closure
   }

   func selectSession(at index: Int, completion: @escaping () -> Void) {

      if let selectedSession = viewModel.getSessionIdentifier(at: index) {
         onSelectSessionCallback(selectedSession, completion)
      } else {
         completion()
      }
   }

   @objc func actionClose() {
      onCloseButtonCallback?()
   }
}
