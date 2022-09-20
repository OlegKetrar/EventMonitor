//
//  File.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import UIKit

struct UIKitMonitorView {
   let provider: EventProvider
   let configs: [AnyEventViewFactory]
}

extension UIKitMonitorView: MonitorView {

   func push(into nc: UINavigationController?) {

      let archiveVC = ArchiveViewController()
      archiveVC.sessions = provider.getSessions()
      archiveVC.onSelect = { [weak nc] selectedSession in

         let adapter = SessionViewConfigurationAdapter(
            events: provider.getEventsForSession(selectedSession),
            factories: configs)

         let sessionVC = SessionViewController(configuration: adapter)
         nc?.pushViewController(sessionVC, animated: true)
      }

      nc?.pushViewController(archiveVC, animated: true)
   }

   func present(over vc: UIViewController?) {
      let nc = UINavigationController()

      let archiveVC = ArchiveViewController()
      archiveVC.sessions = provider.getSessions()
      archiveVC.onSelect = { [weak nc] selectedSession in

         let adapter = SessionViewConfigurationAdapter(
            events: provider.getEventsForSession(selectedSession),
            factories: configs)

         let sessionVC = SessionViewController(configuration: adapter)
         nc?.pushViewController(sessionVC, animated: true)
      }

      nc.setViewControllers([archiveVC], animated: false)

      vc?.present(nc, animated: true)
   }

   func presentActiveSession(over vc: UIViewController?) {
      let nc = UINavigationController()

      let archiveVC = ArchiveViewController()
      archiveVC.sessions = provider.getSessions()
      archiveVC.onSelect = { [weak nc] selectedSession in

         let adapter = SessionViewConfigurationAdapter(
            events: provider.getEventsForSession(selectedSession),
            factories: configs)

         let sessionVC = SessionViewController(configuration: adapter)
         nc?.pushViewController(sessionVC, animated: true)
      }

      let activeSession = provider.getActiveSession()

      let adapter = SessionViewConfigurationAdapter(
         events: activeSession.events,
         factories: configs)

      let activeSessionVC = SessionViewController(configuration: adapter)

      nc.setViewControllers([archiveVC, activeSessionVC], animated: false)

      vc?.present(nc, animated: true)
   }
}
