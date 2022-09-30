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
   private let onApplyFiltersCallback: ([String]) -> Void

   public let state: Observable<SessionViewState>

   public init(
      session: Observable<EventSession>,
      appliedFilters: [String],
      onApplyFilters: @escaping ([String]) -> Void
   ) {

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
      self.appliedFilters = appliedFilters
      self.onApplyFiltersCallback = onApplyFilters

      self.state = Observable(SessionViewState(
         title: formatTitle(session.value),
         exportFileName: formatter.string(from: session.value.identifier.createdAt),
         filters: findFilters(in: session.value, applied: appliedFilters),
         events: filterEvents(in: session.value, filters: appliedFilters)
      ))

      session.notify(observer: self, on: .main, callback: { vm, newSession in
         vm.state.mutate {
            $0.title = formatTitle(newSession)
            $0.filters = findFilters(in: newSession, applied: vm.appliedFilters)
            $0.events = filterEvents(in: newSession, filters: vm.appliedFilters)
         }
      })
   }

   public func applyFilter(_ filter: SubsystemFilter) {

      if filter.isAll {
         appliedFilters = []
      } else {
         appliedFilters = [filter.title]
      }

      state.mutate {
         $0.filters = findFilters(in: session.value, applied: appliedFilters)
         $0.events = filterEvents(in: session.value, filters: appliedFilters)
      }

      onApplyFiltersCallback(appliedFilters)
   }

   public func formatSession(formatter: SessionFormatting) -> String {
      formatter.formatSession(session.value)
   }
}

private func findFilters(
   in session: EventSession,
   applied appliedFilters: [String]
) -> [SubsystemFilter] {

   let subsystems = Array(Set(session.events.map(\.subsystem)))
      .sorted(by: {
         $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
      })

   var filters = subsystems.map {
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

private func filterEvents(
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
