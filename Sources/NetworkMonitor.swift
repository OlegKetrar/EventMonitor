//
//  NetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 13.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

final class NetworkMonitor {

   private let archiver: LogArchiver
   private let activeSession: Observable<ActivitySession>

   private let titleFromDate: DateFormatter = {
      let formatter = DateFormatter()
      formatter.timeStyle = .medium
      formatter.dateStyle = .medium

      return formatter
   }()

   private lazy var archivedSessions: [ActivitySession] = {

      var allPaths = archiver.readSessionPaths()
      allPaths.removeAll(where: {
         let sessionFilename = activeSession.value.getFilename()
         return ($0 as NSString).lastPathComponent == sessionFilename
      })

      return allPaths
         .compactMap {
            let filename = ($0 as NSString).lastPathComponent

            guard let createdAt = ActivitySession.getCreatedAt(from: filename) else {
               return nil
            }

            return ActivitySession(
               title: self.titleFromDate.string(from: createdAt),
               createdAt: createdAt,
               events: self.archiver.readItemsFromFile(at: $0))
      }
      .sorted(by: {
         $0.createdAt > $1.createdAt
      })
   }()

   init() {
      let sessionCreatedAt = Date()

      archiver = LogArchiver(directoryPath: {
         let tmpDir = NSTemporaryDirectory() as NSString
         return tmpDir.appendingPathComponent("network-monitor.session-logs")
      }())

      activeSession = Observable(ActivitySession(
         title: self.titleFromDate.string(from: sessionCreatedAt),
         createdAt: sessionCreatedAt,
         events: [],
         isActive: true))

      archiver.createSessionFile(name: activeSession.value.getFilename())
   }

   func log(event: ActivityEvent) {
      activeSession.mutate {
         $0.events.append(event)
      }

      archiver.write(item: event)
   }

   func getActivitySessions() -> [ActivitySession] {
      return [activeSession.value] + archivedSessions
   }

   func getObservableActivitySessions() -> [Observable<ActivitySession>] {
      return [activeSession] + archivedSessions.map { Observable($0) }
   }
}

// MARK: - Convenience

private extension ActivitySession {

   func getFilename() -> String {
      return "\( Int(createdAt.timeIntervalSince1970) ).log"
   }

   static func getCreatedAt(from filename: String) -> Date? {
      return Int( filename.removingSuffix(".log") )
         .map { Date(timeIntervalSince1970: TimeInterval($0)) }
   }
}
