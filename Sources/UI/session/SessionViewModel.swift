//
//  SessionViewModel.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCore

struct SubsystemFilter {
   var title: String
   var isAll: Bool
   var isApplied: Bool
}

extension SubsystemFilter {

   init(subsystem: String, isApplied: Bool) {
      self.init(title: subsystem, isAll: false, isApplied: isApplied)
   }

   static var clear: SubsystemFilter {
      SubsystemFilter(
         title: "Clear filter",
         isAll: true,
         isApplied: false)
   }
}

// TODO: add State

final class SessionViewModel {
   private let originalSession: Observable<ActivitySession>
   private let filteredSession: Observable<ActivitySession>

   private var appliedSubsystemFilter: String?

   var session: Observable<ActivitySession> { filteredSession }

   init(session: Observable<ActivitySession>) {
      self.originalSession = session
      self.filteredSession = Observable(session.value)

      session.notify(observer: self, callback: { vm, value in
         vm.filteredSession.mutate {
            $0.groupedEvents = vm.filterEvents(value.groupedEvents)
         }
      })
   }

   func hasFilters() -> Bool {
      findAllSubsystemFilters() != nil
   }

   func findAllSubsystemFilters() -> [SubsystemFilter]? {

      let subsystems = originalSession.value.groupedEvents.map { $0.subsystem }

      var filters = Array(Set(subsystems)).map {
         SubsystemFilter(
            subsystem: $0,
            isApplied: $0 == appliedSubsystemFilter)
      }

      guard filters.count > 1 else {
         return nil
      }

      if appliedSubsystemFilter != nil {
         filters.append(.clear)
      }

      return filters
   }

   func filterEvents(by filter: SubsystemFilter) {

      if filter.isAll {
         self.appliedSubsystemFilter = nil
      } else {
         self.appliedSubsystemFilter = filter.title
      }

      filteredSession.mutate {
         $0.groupedEvents = filterEvents(originalSession.value.groupedEvents)
      }
   }

   private func filterEvents(_ original: [GroupedEvent]) -> [GroupedEvent] {
      if let subsystem = appliedSubsystemFilter {
         return original.filter { $0.subsystem == subsystem }
      } else {
         return original
      }
   }
}
