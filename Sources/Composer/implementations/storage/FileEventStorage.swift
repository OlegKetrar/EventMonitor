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
   private var activeSessionID: SessionIdentifier?

   init(directoryPath path: String) {
      self.archiver = LogArchiver(directoryPath: path)
   }

   func readStoredSessions(
      _ completion: @escaping ([SessionIdentifier]) -> Void
   ) {

      completion(archiver
         .readSessionPaths()
         .compactMap {
            SessionIdentifier(filename: $0.ns.lastPathComponent)
         }
         .filter {

            // remove activeSession from list
            if let activeSessionID = activeSessionID {
               return $0 != activeSessionID
            } else {
               return true
            }
         }
         .sorted(by: >))
   }

   func readEvents(
      sessionIdentifier: SessionIdentifier,
      completion: @escaping ([AnyEvent]) -> Void
   ) {

      let filename = sessionIdentifier.makeFilename()
      let filePath = archiver.directoryPath.ns.appendingPathComponent(filename)
      let events: [AnyEvent] = archiver.readItemsFromFile(at: filePath)

      completion(events)
   }

   func startSession(identifier: SessionIdentifier) {
      archiver.createSessionFile(name: identifier.makeFilename())
      activeSessionID = identifier
   }

   func write(event: AnyEvent) {
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
      queue.async { [self] in
         let filePath = (directoryPath as NSString).appendingPathComponent(name)

         FileManager.default.createFile(
            atPath: filePath,
            contents: Data(),
            attributes: nil)

         sessionFileHandle = FileHandle(forUpdatingAtPath: filePath)
      }
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

private extension SessionIdentifier {

   init?(filename: String) {
      guard let integer = Int(filename.removingSuffix(".log")) else {
         return nil
      }

      self.init(Double(integer))
   }

   func makeFilename() -> String {
      "\(Int(timestamp)).log"
   }
}
