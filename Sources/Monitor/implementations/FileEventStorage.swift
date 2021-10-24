//
//  FileEventStorage.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch
import MonitorCore

/// Simple EventStorage that stores data as json files.
final class FileEventStorage: EventStorage {
   private let archiver: LogArchiver
   private var activeSessionName: String?

   init(directoryPath path: String) {
      self.archiver = LogArchiver(directoryPath: path)
   }

   func readStoredSessions(
      _ completion: @escaping ([StoredEventSession]) -> Void
   ) {

      var allPaths = archiver.readSessionPaths()

      // remove active session from `allPaths`
      if let activeSessionName = activeSessionName {
         allPaths.removeAll(where: {
            ($0 as NSString).lastPathComponent == activeSessionName
         })
      }

      let sessions: [StoredEventSession] = allPaths
         .compactMap {
            getDateFromFilename(($0 as NSString).lastPathComponent)
         }
         .map {
            StoredEventSession(createdAt: $0)
         }
         .sorted(by: {
            $0.createdAt > $1.createdAt
         })

      completion(sessions)
   }

   func readEvents(
      session: StoredEventSession,
      completion: @escaping ([GroupedEvent]) -> Void
   ) {

      let filename = getFilenameFromDate(session.createdAt)
      let filePath = archiver.directoryPath.ns.appendingPathComponent(filename)
      let events: [GroupedEvent] = archiver.readItemsFromFile(at: filePath)

      completion(events)
   }

   func startSession(createdAt: Date) {
      archiver.createSessionFile(name: getFilenameFromDate(createdAt))
   }

   func write(event: GroupedEvent) {
      archiver.write(item: event)
   }
}

private final class LogArchiver {
   let directoryPath: String

   private let queue = DispatchQueue(label: "stored-logging-queue", qos: .background)
   private var sessionFileHandle: FileHandle?

   init(directoryPath: String) {
      self.directoryPath = directoryPath
      FileManager.default.createDirectoryIfNotExist(at: directoryPath)
   }

   func createSessionFile(name: String) {
      let filePath = (directoryPath as NSString).appendingPathComponent(name)

      FileManager.default.createFile(
         atPath: filePath,
         contents: Data(),
         attributes: nil)

      sessionFileHandle = FileHandle(forUpdatingAtPath: filePath)
   }

   func write<T: Encodable>(item: T) {
      guard let fileHandle = sessionFileHandle else { return }

      queue.async {
         guard
            let itemData = try? JSONEncoder().encode(item),
            let newlineData = "\n".data(using: .utf8)
         else { return }

         fileHandle.write(itemData)
         fileHandle.write(newlineData)
      }
   }

   func readSessionPaths() -> [String] {
      return (try? FileManager.default
         .contentsOfDirectory(atPath: directoryPath))?
         .map { (directoryPath as NSString).appendingPathComponent($0) }
         ?? []
   }

   func readItemsFromFile<T: Decodable>(at path: String) -> [T] {
      guard
         let data = FileManager.default.contents(atPath: path),
         let dataStr = String(data: data, encoding: .utf8)
      else {
         return []
      }

      return dataStr.components(separatedBy: .newlines).compactMap {
         $0.data(using: .utf8).flatMap {
            try? JSONDecoder().decode(T.self, from: $0)
         }
      }
   }
}

private func getDateFromFilename(_ filename: String) -> Date? {
   Int(filename.removingSuffix(".log"))
      .map(TimeInterval.init)
      .map(Date.init(timeIntervalSince1970:))
}

private func getFilenameFromDate(_ date: Date) -> String {
   "\( Int(date.timeIntervalSince1970) ).log"
}
