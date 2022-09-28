//
//  ArchiveViewModel.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch
import MonitorCore

struct ArchiveViewState {
   var titles: [String] = []
}

final class ArchiveViewModel {
   private let allSessions: Observable<[SessionInfo]>

   let state: Observable<ArchiveViewState>

   init(repository: ArchiveRepository) {
      let formatter = DateFormatter()
      formatter.timeStyle = .medium
      formatter.dateStyle = .medium

      func convertSession(_ session: SessionInfo) -> String {
         let title = formatter.string(from: session.identifier.createdAt)

         if session.isActive {
            return "\(title) (active)"
         } else {
            return title
         }
      }

      self.allSessions = repository.fetchSessions()
      self.state = Observable(ArchiveViewState(
         titles: self.allSessions.value.map(convertSession(_:))))

      self.allSessions.notify(
         observer: self,
         on: .main,
         callback: { vm, newSessions in
            vm.state.mutate {
               $0.titles = newSessions.map(convertSession(_:))
            }
         })
   }

   func getSessionIdentifier(at index: Int) -> SessionIdentifier? {
      let sessions = allSessions.value

      if sessions.indices.contains(index) {
         return sessions[index].identifier
      } else {
         return nil
      }
   }
}
