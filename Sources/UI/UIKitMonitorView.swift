//
//  File.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import UIKit
import MonitorCore

public struct UIKitMonitorView {
   let provider: EventProvider
   let configs: [AnyEventViewFactory]

   public init(provider: EventProvider, configs: [AnyEventViewFactory]) {
      self.provider = provider
      self.configs = configs
   }
}

extension UIKitMonitorView: MonitorView {

   public func push(into nc: UINavigationController?) {
      nc?.pushViewController(
         makeArchiveViewController(nc: nc),
         animated: true)
   }

   public func present(over vc: UIViewController?) {
      let nc = UINavigationController()

      let archiveVC = makeArchiveViewController(nc: nc)
      nc.setViewControllers([archiveVC], animated: false)

      vc?.present(nc, animated: true)
   }

   public func presentActiveSession(over vc: UIViewController?) {
      let nc = UINavigationController()

      let archiveVC = makeArchiveViewController(nc: nc)
      let activeSession = provider.fetchActiveSession()

      let presenter = SessionPresenter(
         session: activeSession,
         configs: configs,
         navigation: nc)

      let activeSessionVC = SessionViewController(presenter: presenter)

      nc.setViewControllers([archiveVC, activeSessionVC], animated: false)

      vc?.present(nc, animated: true)
   }
}

extension UIKitMonitorView {

   func makeArchiveViewController(nc: UINavigationController?) -> UIViewController {

      let repository = AnyEventProvider(provider: provider)

      let presenter = ArchivePresenter(repository: repository)
         .onSelectSession { selectedSession, completion in

            provider.fetchEventSession(
               identifier: selectedSession,
               completion: { session in

                  let presenter = SessionPresenter(
                     session: session,
                     configs: configs,
                     navigation: nc)

                  nc?.pushViewController(
                     SessionViewController(presenter: presenter),
                     animated: true)

                  completion()
               })
         }

      return ArchiveViewController(presenter: presenter)
   }
}

struct AnyEventProvider: ArchiveRepository {
   let provider: EventProvider

   func fetchSessions() -> Observable<[SessionInfo]> {
      provider.fetchSessions()
   }
}
