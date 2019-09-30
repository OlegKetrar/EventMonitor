//
//  SessionPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

final class SessionPresenter: Presenter, FileSharingTrait {
   var session: Observable<ActivitySession>

   init(session: Observable<ActivitySession>) {
      self.session = session
   }

   func selectEvent(at index: Int) {
      guard session.value.events.indices.contains(index) else { return }

      let vc = EventDetailsVC()
      vc.presenter = EventDetailsPresenter
         .init(event: session.value.events[index])
         .with(navigationController: navigationController)

      navigationController?.pushViewController(vc, animated: true)
   }

   func share(_ completion: @escaping () -> Void) {
      let sessionToShare = session.value

      shareFile(
         name: "\(sessionToShare.title).log",
         content: {
            let formatter = PlainTextFormatter()

            return sessionToShare.events
               .map { "--> \( formatter.format(event: $0) )" }
               .joined(separator: "\n\n")
         },
         completion: { [weak self] shareAlert in
            guard let strongSelf = self else { return }
            completion()

            strongSelf.navigationController?.present(
               shareAlert ?? strongSelf.makeErrorAlert(),
               animated: true)
         })
   }

   private func makeErrorAlert() -> UIAlertController {

      let alert = UIAlertController(
         title: "Can't share log file",
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: nil)
      })

      alert.addAction(ok)

      return alert
   }
}
