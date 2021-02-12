//
//  SessionPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

struct SubsystemFilter {
   var title: String
   var isAll: Bool
   var isApplied: Bool
}

extension SubsystemFilter {

   init(subsystem: String, isApplied: Bool) {
      self.title = subsystem
      self.isAll = false
      self.isApplied = isApplied
   }

   static var clear: SubsystemFilter {
      return SubsystemFilter(
         title: "Clear filter",
         isAll: true,
         isApplied: false)
   }
}

final class SessionPresenter: Presenter, FileSharingTrait {
   private let originalSession: Observable<ActivitySession>
   private let filteredSession: Observable<ActivitySession>

   private var appliedSubsystemFilter: String?

   init(session: Observable<ActivitySession>) {
      self.originalSession = session
      self.filteredSession = Observable(session.value)
      super.init()

      session.notify(observer: self, callback: { presenter, value in
         presenter.filteredSession.mutate {
            $0.groupedEvents = presenter.filterEvents(value.groupedEvents)
         }
      })
   }

   var session: Observable<ActivitySession> {
      return filteredSession
   }

   func hasFilters() -> Bool {
      return findAllSubsystemFilters() != nil
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

   func selectEvent(at index: Int) {
      guard session.value.events.indices.contains(index) else { return }

      let vc = EventDetailsVC()
      vc.presenter = EventDetailsPresenter
         .init(event: session.value.events[index])
         .with(navigationController: navigationController)

      navigationController?.pushViewController(vc, animated: true)
   }

   func share(_ completion: @escaping () -> Void) {
      let sessionToShare = session.value

      shareFile(
         name: "\(sessionToShare.title).log",
         content: {
            let formatter = PlainTextFormatter()

            return sessionToShare.events
               .map { "--> \( formatter.format(event: $0) )" }
               .joined(separator: "\n\n")
         },
         completion: { [weak self] shareAlert in
            guard let strongSelf = self else { return }
            completion()

            strongSelf.navigationController?.present(
               shareAlert ?? strongSelf.makeErrorAlert(),
               animated: true)
         })
   }

   private func makeErrorAlert() -> UIAlertController {

      let alert = UIAlertController(
         title: "Can't share log file",
         message: nil,
         preferredStyle: .alert)

      let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
         alert.dismiss(animated: true, completion: nil)
      })

      alert.addAction(ok)

      return alert
   }

   private func filterEvents(
      _ original: [GroupedActivityEvent]) -> [GroupedActivityEvent] {

      if let subsystem = appliedSubsystemFilter {
         return original.filter { $0.subsystem == subsystem }
      } else {
         return original
      }
   }
}
