//
//  SessionPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

final class SessionPresenter: SessionVCPresenter {
   let viewModel: SessionViewModel

   private weak var navigationController: UINavigationController?
   private var onSelectEventCallback: (GroupedEvent) -> Void = { _ in }

   init() {
      viewModel = { fatalError() }()
   }

   func onSelectEvent(_ callback: @escaping (GroupedEvent) -> Void) -> Self {
      self.onSelectEventCallback = callback
      return self
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      navigationController = nc
      nc.pushViewController(SessionVC(presenter: self), animated: animated)
   }

   func shareSession(_ completion: @escaping () -> Void) {

      let sessionToShare: ActivitySession = {
//         session.value

         fatalError()
      }()

      FileSharingPresenter().shareFile(
         name: "\(sessionToShare.title).log",
         content: {
//            let formatter = PlainTextFormatter()
//
//            return sessionToShare.events
//               .map { "--> \( formatter.format(event: $0) )" }
//               .joined(separator: "\n\n")

            ""
         },
         completion: { [weak self] in
            self?.navigationController?.present($0, animated: true)
            completion()
         })
   }

   func selectEvent(at index: Int, completion: @escaping () -> Void) {
      // TODO:
   }
}
