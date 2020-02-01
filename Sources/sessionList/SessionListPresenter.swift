//
//  SessionListPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

final class SessionListPresenter: Presenter {
   let sessions: [ActivitySession]
   let isPresented: Bool
   private let observableSessions: [Observable<ActivitySession>]

   /// - parameter isPresented: vc will be presented or pushed into UINavigationController.
   init(isPresented: Bool, sessions: [Observable<ActivitySession>]) {
      self.isPresented = isPresented
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

   func dismiss() {
      guard isPresented else { return }
      navigationController?.dismiss(animated: true, completion: nil)
   }
}
