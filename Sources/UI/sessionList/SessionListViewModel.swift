//
//  SessionListViewModel.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

final class SessionListViewModel {
   let state: Observable<[ActivitySession]>

   init(provider: EventProvider) {
      self.state = Observable([])
   }

   //   let sessions: [ActivitySession]
   //   private let observableSessions: [Observable<ActivitySession>]
}


//return session.isActive ? "\(session.title) (active)" : session.title
