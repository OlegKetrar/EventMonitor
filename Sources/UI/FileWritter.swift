//
//  FileWritter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

struct FileWritter {

   func writeFile(
      name: String,
      content: @escaping () -> String,
      completion: @escaping (String?) -> Void
   ) {

      DispatchQueue.global().async {

         let exportDir = NSTemporaryDirectory()
            .ns
            .appendingPathComponent("network-monitor.exporting-logs")

         let filePath = exportDir.ns.appendingPathComponent(name)

         FileManager.default.createDirectoryIfNotExist(at: exportDir)

         let writedSuccessfully = FileManager.default.createFile(
            atPath: filePath,
            contents: content().data(using: .utf8))

         if writedSuccessfully {
            DispatchQueue.main.async { completion(filePath) }

         } else {
            removeFile(at: filePath)
            DispatchQueue.main.async { completion(nil) }
         }
      }
   }

   func removeFile(at path: String) {
      try? FileManager.default.removeItem(atPath: path)
   }
}
