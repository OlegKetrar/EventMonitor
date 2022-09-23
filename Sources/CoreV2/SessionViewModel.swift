//
//  SessionViewModel.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct SessionViewState {

   public var title: String
   public var exportFileName: String
   public var filters: [SubsystemFilter]
   public var events: [AnyEvent]

   public var hasFilters: Bool {
      filters.isEmpty == false
   }
}

public final class SessionViewModel {
   private let session: Observable<EventSession>
   private var appliedFilters: [String]

   public let state: Observable<SessionViewState>

   public init(session: Observable<EventSession>) {

      let formatter = DateFormatter()
      formatter.timeStyle = .medium
      formatter.dateStyle = .medium

      func formatTitle(_ session: EventSession) -> String {
         if session.isActive {
            return "active"
         } else {
            return formatter.string(from: session.identifier.createdAt)
         }
      }

      self.session = session
      self.appliedFilters = []

      self.state = Observable(SessionViewState(
         title: formatTitle(session.value),
         exportFileName: formatter.string(from: session.value.identifier.createdAt),
         filters: findFilters(in: session.value, applied: []),
         events: formatEvents(in: session.value, filters: [])
      ))

      session.notify(observer: self, on: .main, callback: { vm, newSession in
         vm.state.mutate {
            $0.title = formatTitle(newSession)
            $0.filters = findFilters(in: newSession, applied: vm.appliedFilters)
            $0.events = formatEvents(in: newSession, filters: vm.appliedFilters)
         }
      })
   }

   public func filterEvents(by filter: SubsystemFilter) {

      if filter.isAll {
         self.appliedFilters = []
      } else {
         self.appliedFilters = [filter.title]
      }

      state.mutate {
         $0.filters = findFilters(in: session.value, applied: appliedFilters)
         $0.events = formatEvents(in: session.value, filters: appliedFilters)
      }
   }

//   func formatSession(with formatter: SessionFormatting) -> String {
//      formatter.format(session.value)
//   }
}

private func findFilters(
   in session: EventSession,
   applied appliedFilters: [String]
) -> [SubsystemFilter] {

   let subsystems = session.events.map { $0.subsystem }

   var filters = Array(Set(subsystems)).map {
      SubsystemFilter(
         subsystem: $0,
         isApplied: appliedFilters.contains($0))
   }

   guard filters.count > 1 else {
      return []
   }

   if appliedFilters.isEmpty == false {
      filters.append(.clear)
   }

   return filters
}

private func formatEvents(
   in session: EventSession,
   filters: [String]
) -> [AnyEvent] {

   session.events.filter {
      if filters.isEmpty {
         return true
      } else {
         return filters.contains($0.subsystem)
      }
   }
}
