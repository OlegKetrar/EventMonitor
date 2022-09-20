//
//  MonitorPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public struct MonitorPresenter {
   private let repository: EventProvider
//   private weak var navigationController: UINavigationController?

   public init(repository: EventProvider) {
      self.repository = repository
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
         .init(
            session: repository.fetchActiveSession(),
            exportCapability: repository.sessionExportCapability())
         .onSelectEvent {
            switch $0.event {
            case let .network(event):
               open(event: event, subsystem: $0.subsystem, into: nc)
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
         .init(repository: AnyEventProvider(provider: repository))
         .onSelectSession { sessionID, completion in

            repository.fetchEventSession(
               identifier: sessionID,
               completion: {
                  SessionPresenter
                     .init(
                        session: $0,
                        exportCapability: repository.sessionExportCapability())
                     .onSelectEvent {

                        switch $0.event {
                        case let .network(event):
                           open(
                              event: event,
                              subsystem: $0.subsystem,
                              into: navigation)
                        }
                     }
                     .push(into: navigation)

                  completion()
               })
         }
   }

   func open(
      event: NetworkEvent,
      subsystem: String,
      into navigation: UINavigationController
   ) {

      NetworkEventDetailsPresenter
         .init(
            event: event,
            subsystem: subsystem,
            exportCapabilities: repository.eventExportCapabilities())
         .push(into: navigation)
   }
}

private struct AnyEventProvider: SessionListRepository {
   let provider: EventProvider

   func fetchSessions() -> Observable<[SessionInfo]> {
      provider.fetchSessions()
   }
}
