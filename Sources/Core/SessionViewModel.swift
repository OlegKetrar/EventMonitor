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
   private var filtering: FilterModel<String>

   public let state: Observable<SessionViewState>

   public init(
      session: Observable<EventSession>,
      filtering: FilterModel<String>
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
      self.filtering = filtering

      self.state = Observable(SessionViewState(
         title: formatTitle(session.value),
         exportFileName: formatter.string(from: session.value.identifier.createdAt),
         filters: filtering.findFilters(in: session.value),
         events: filtering.filter(items: session.value.events, by: \.subsystem)
      ))

      session.notify(observer: self, on: .main, callback: { vm, newSession in
         vm.state.mutate {
            $0.title = formatTitle(newSession)
            $0.filters = vm.filtering.findFilters(in: newSession)
            $0.events = vm.filtering.filter(items: newSession.events, by: \.subsystem)
         }
      })
   }

   public func toggleFilter(_ filter: SubsystemFilter) {

      if filter.isAll {
         filtering.clearAll()
      } else {
         filtering.toggle(filter.title)
      }

      state.mutate {
         $0.filters = filtering.findFilters(in: session.value)
         $0.events = filtering.filter(items: session.value.events, by: \.subsystem)
      }
   }

   public func formatSession(formatter: SessionFormatting) -> String {
      var sessionToFormat = session.value

      // format only filtered events
      sessionToFormat.events = filtering.filter(
         items: session.value.events,
         by: \.subsystem)

      return formatter.formatSession(sessionToFormat)
   }
}

extension FilterModel where Parameter == String {

   func findFilters(in session: EventSession) -> [SubsystemFilter] {
      findOptions(
         in: session.events,
         by: \.subsystem,
         sortedBy: {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
         })
      .map {
         $0.makeSubsystemFilter()
      }
   }
}

extension FilterOption<String> {

   func makeSubsystemFilter() -> SubsystemFilter {
      switch self {
      case let .filter(parameter, isApplied):
         return SubsystemFilter(
            title: parameter,
            isAll: false,
            isApplied: isApplied)

      case .clearAll:
         return .clear
      }
   }
}
