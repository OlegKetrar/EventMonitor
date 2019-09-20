//
//  SessionListPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

class Presenter {
   weak var navigationController: UINavigationController?

   final func with(navigationController: UINavigationController?) -> Self {
      self.navigationController = navigationController
      return self
   }
}

final class SessionListPresenter: Presenter {
   let sessions: [ActivitySession]
   private let observableSessions: [Observable<ActivitySession>]

   init(sessions: [Observable<ActivitySession>]) {
      self.sessions = sessions.map { $0.value }
      self.observableSessions = sessions
   }

   func selectSession(at index: Int) {
      guard observableSessions.indices.contains(index) else { return }

      let vc = SessionVC()
      vc.presenter = SessionPresenter
         .init(session: observableSessions[index])
         .with(navigationController: navigationController)

      navigationController?.pushViewController(vc, animated: true)
   }
}
