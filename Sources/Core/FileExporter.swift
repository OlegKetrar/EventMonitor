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
   private var pathsToRemove: [String] = []

   init(formatter: Formatter) {
      self.formatter = formatter
   }

   public func prepareFile(
      named filename: String,
      content: (Formatter) -> String,
      completion: @escaping (String?) -> Void
   ) {

      let contentStr = content(formatter)

      FileWritter().writeFile(
         name: filename,
         content: { contentStr },
         completion: { [self] in
            if let filepath = $0 {
               pathsToRemove.append(filepath)
            }

            completion($0)
         })
   }

   deinit {
      pathsToRemove.forEach {
         try? FileManager.default.removeItem(atPath: $0)
      }
   }
}
