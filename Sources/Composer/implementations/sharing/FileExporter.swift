//
//  FileExporter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public final class FileExporter<Formatter> {
   private let formatter: Formatter

   public init(formatter: Formatter) {
      self.formatter = formatter
   }

   public func prepareFile(
      named filename: String,
      content: (Formatter) -> String
   ) async -> LocalFileRef? {

      let contentStr = content(formatter)

      let exportDir = NSTemporaryDirectory()
         .ns
         .appendingPathComponent("network-monitor.exporting-logs")

      let filepath = exportDir.ns.appendingPathComponent(filename)

      FileManager.default.createDirectoryIfNotExist(at: exportDir)

      let writedSuccessfully = FileManager.default.createFile(
         atPath: filepath,
         contents: contentStr.data(using: .utf8))

      if writedSuccessfully {
         return LocalFileRef(path: filepath)
      } else {
         return nil
      }
   }
}

/// RAII abstraction to clean up file.
public final class LocalFileRef {
   public let path: String

   init(path: String) {
      self.path = path
   }

   deinit {
      try? FileManager.default.removeItem(atPath: path)
   }
}
