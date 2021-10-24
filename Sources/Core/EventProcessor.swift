//
//  EventProcessor.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public final class EventProcessor {
   private let storage: EventStorage

   public init(storage: EventStorage) {
      self.storage = storage
   }

   public func log(event: GroupedEvent) {

   }
}

extension EventProcessor: EventProvider {

}

//final class NetworkMonitor {
//
//   private let archiver: LogArchiver
//   private let activeSession: Observable<ActivitySession>
//
//   private let titleFromDate: DateFormatter = {
//      let formatter = DateFormatter()
//      formatter.timeStyle = .medium
//      formatter.dateStyle = .medium
//
//      return formatter
//   }()
//
//   private lazy var archivedSessions: [ActivitySession] = {
//      fatalError()
//   }()
//
//   init() {
//      let sessionCreatedAt = Date()
//
//      archiver = LogArchiver(directoryPath: {
//         let tmpDir = NSTemporaryDirectory() as NSString
//         return tmpDir.appendingPathComponent("network-monitor.session-logs")
//      }())
//
//      activeSession = Observable(ActivitySession(
//         title: self.titleFromDate.string(from: sessionCreatedAt),
//         createdAt: sessionCreatedAt,
//         groupedEvents: [],
//         isActive: true))
//
//      archiver.createSessionFile(name: activeSession.value.getFilename())
//   }
//
//   func log(event: ActivityEvent, domain: String) {
//      let groupedEvent = GroupedActivityEvent(subsystem: domain, event: event)
//
//      activeSession.mutate {
//         $0.groupedEvents.append(groupedEvent)
//      }
//
//      archiver.write(item: groupedEvent)
//   }
//
//   func getActivitySessions() -> [ActivitySession] {
//      return [activeSession.value] + archivedSessions
//   }
//
//   func getObservableActivitySessions() -> [Observable<ActivitySession>] {
//      return [activeSession] + archivedSessions.map { Observable($0) }
//   }
//}
