//
//  MonitorPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public struct ExportOption {

}

public final class MonitorPresenter {
   private let exportOptions: [ExportOption]
   private weak var navigationController: UINavigationController?

   public init(
      repository: EventProvider,
      exportOptions: [ExportOption]
   ) {
      self.exportOptions = exportOptions
   }

   public func push(into nc: UINavigationController) {
      makePresenter(navigation: nc).push(into: nc, animated: true)
   }

   public func present(over vc: UIViewController) {
      let nc = UINavigationController()

      makePresenter(navigation: nc)
         .withCloseButton { nc.dismiss(animated: true) }
         .push(into: nc, animated: false)

      vc.present(nc, animated: true)
   }

   public func presentCurrentSession(over vc: UIViewController) {
      let nc = UINavigationController()

      let sessionList = makePresenter(navigation: nc)
         .withCloseButton {
            nc.dismiss(animated: true)
         }

      if let activeSession: ActivitySession = Optional({ fatalError() }()) {

         let currentSession = SessionPresenter
            .init() // pass activeSession
            .onSelectEvent { event in
               EventDetailsPresenter
                  .init(event: event)
                  .push(into: nc)
            }

         sessionList.push(into: nc, animated: false)
         currentSession.push(into: nc, animated: false)

      } else {
         sessionList.push(into: nc, animated: false)
      }

      vc.present(nc, animated: true)
   }
}

private extension MonitorPresenter {

   func makePresenter(navigation: UINavigationController) -> SessionListPresenter {
      SessionListPresenter
         .init() // ..
         .onSelectSession { session in
            SessionPresenter
               .init() // ..
               .onSelectEvent { event in
                  EventDetailsPresenter
                     .init(event: event)  // ..
                     .push(into: navigation)
               }
               .push(into: navigation)
         }
   }
}
