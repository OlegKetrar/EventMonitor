//
//  UIKitMonitorView.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public struct UIKitMonitorView {
   public typealias ConfigurationFactory = (Observable<EventSession>, UINavigationController?) -> SessionViewConfiguration

   let provider: EventProvider
   let makeConfig: ConfigurationFactory

   public init(provider: EventProvider, config: @escaping ConfigurationFactory) {
      self.provider = provider
      self.makeConfig = config
   }
}

extension UIKitMonitorView: MonitorView {

   public func push(into nc: UINavigationController?) {
      nc?.pushViewController(
         makeArchiveViewController(nc: nc, onClose: nil),
         animated: true)
   }

   public func present(over vc: UIViewController?) {
      let nc = UINavigationController()
      nc.overrideUserInterfaceStyle = .light

      let archiveVC = makeArchiveViewController(nc: nc, onClose: { [weak nc] in
         nc?.dismiss(animated: true)
      })

      nc.setViewControllers([archiveVC], animated: false)

      vc?.present(nc, animated: true)
   }

   public func presentActiveSession(over vc: UIViewController?) {
      let nc = UINavigationController()
      nc.overrideUserInterfaceStyle = .light

      let archiveVC = makeArchiveViewController(nc: nc, onClose: { [weak nc] in
         nc?.dismiss(animated: true)
      })

      let activeSession = provider.fetchActiveSession()
      let config = makeConfig(activeSession, nc)
      let activeSessionVC = SessionViewController(configuration: config)

      nc.setViewControllers([archiveVC, activeSessionVC], animated: false)

      vc?.present(nc, animated: true)
   }
}

extension UIKitMonitorView {

   func makeArchiveViewController(
      nc: UINavigationController?,
      onClose: (() -> Void)?
   ) -> UIViewController {

      let repository = AnyEventProvider(provider: provider)

      let presenter = ArchivePresenter(repository: repository)
         .onSelectSession { selectedSession, completion in

            provider.fetchEventSession(
               identifier: selectedSession,
               completion: { session in

                  let config = makeConfig(session, nc)

                  nc?.pushViewController(
                     SessionViewController(configuration: config),
                     animated: true)

                  completion()
               })
         }

      let viewController = ArchiveViewController(presenter: presenter)

      if let onClose {
         presenter.setCloseButtonCallback(onClose)

         // Add close button when needed
         viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: presenter,
            action: #selector(ArchivePresenter.actionClose))
      }

      return viewController
   }
}

struct AnyEventProvider: ArchiveRepository {
   let provider: EventProvider

   func fetchSessions() -> Observable<[SessionInfo]> {
      provider.fetchSessions()
   }
}
