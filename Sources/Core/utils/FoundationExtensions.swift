//
//  FoundationExtensions.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

extension FileManager {

   /// Will remove file with same name.
   public func createDirectoryIfNotExist(at path: String) {

      let isDirPtr = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
      isDirPtr[0]  = false

      let isExist = fileExists(atPath: path, isDirectory: isDirPtr)
      let isDir = isDirPtr[0].boolValue

      // remove file if not a directory
      if isExist {
         guard !isDir else { return }
         try? removeItem(atPath: path)
      }

      try? createDirectory(
         atPath: path,
         withIntermediateDirectories: true,
         attributes: nil)
   }
}

// MARK: -

extension String {

   public var ns: NSString {
      self as NSString
   }

   public func removingSuffix(_ suffix: String) -> String {
      guard !suffix.isEmpty, hasSuffix(suffix) else { return self }

      var copy = self
      for char in suffix.reversed() {
         guard copy.last == char else { break }
         copy.removeLast()
      }

      return copy
   }
}
