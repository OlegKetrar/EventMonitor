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
   let provider: EventProvider
   let config: EventViewConfig

   public init(provider: EventProvider, config: EventViewConfig) {
      self.provider = provider
      self.config = config
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
      nc.overrideUserInterfaceStyle = .light

      let archiveVC = makeArchiveViewController(nc: nc)
      nc.setViewControllers([archiveVC], animated: false)

      vc?.present(nc, animated: true)
   }

   public func presentActiveSession(over vc: UIViewController?) {
      let nc = UINavigationController()
      nc.overrideUserInterfaceStyle = .light

      let archiveVC = makeArchiveViewController(nc: nc)
      let activeSession = provider.fetchActiveSession()

      let adapter = SessionViewAdapter(
         viewModel: SessionViewModel(session: activeSession),
         config: config,
         navigation: nc)

      let activeSessionVC = SessionViewController(configuration: adapter)

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

                  let adapter = SessionViewAdapter(
                     viewModel: SessionViewModel(session: session),
                     config: config,
                     navigation: nc)

                  nc?.pushViewController(
                     SessionViewController(configuration: adapter),
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
