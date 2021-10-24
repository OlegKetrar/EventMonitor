//
//  SwizzledUrlSession.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

final class SwizzledUrlSession {

   func doSmth() {
      let configuration = URLSessionConfiguration.default

      let session = URLSession(
         configuration: configuration,
         delegate: nil,
         delegateQueue: nil)
   }
}
