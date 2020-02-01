//
//  LogArchiver.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch

final class LogArchiver {
   private let directoryPath: String
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
