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
import DependencyContainer

public struct ExportOption {

}

public final class MonitorPresenter {
   private let repository: EventProvider
   private let exportOptions: [ExportOption]
   private weak var navigationController: UINavigationController?

   public init(
      repository: EventProvider,
      exportOptions: [ExportOption]
   ) {
      self.exportOptions = exportOptions
      self.repository = repository

      DI.register(as: SessionListRepository.self) { _ in
         AnyEventProvider(provider: repository)
      }
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

      let currentSession = SessionPresenter
         .init(session: repository.fetchActiveSession())
         .onSelectEvent {
            switch $0.event {
            case let .network(event):
               NetworkEventDetailsPresenter
                  .init(event: event, subsystem: $0.subsystem)
                  .push(into: nc)

            case .message:
               break
            }
         }

      sessionList.push(into: nc, animated: false)
      currentSession.push(into: nc, animated: false)

      vc.present(nc, animated: true)
   }
}

private extension MonitorPresenter {

   func makePresenter(
      navigation: UINavigationController
   ) -> SessionListPresenter {

      SessionListPresenter
         .init()
         .onSelectSession { sessionID, completion in

            self.repository.fetchEventSession(
               identifier: sessionID,
               completion: {
                  SessionPresenter
                     .init(session: $0)
                     .onSelectEvent {

                        switch $0.event {
                        case let .network(event):
                           NetworkEventDetailsPresenter
                              .init(event: event, subsystem: $0.subsystem)
                              .push(into: navigation)

                        case .message:
                           break
                        }
                     }
                     .push(into: navigation)

                  completion()
               })
         }
   }
}

private struct AnyEventProvider: SessionListRepository {
   let provider: EventProvider

   func fetchSessions() -> Observable<[SessionInfo]> {
      provider.fetchSessions()
   }
}
