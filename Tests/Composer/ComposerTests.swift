//
//  ComposerTests.swift
//  EventMonitorTests
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import XCTest
import EventMonitor

final class ComposerTests: XCTestCase {

   /// We only want to test visibility of certain API here.
   /// So wrapping in a closure let the compiler to type check it, but prevent from actual running.
   func testImportVisibility() {
      _ = {
         let networkEvent = NetworkEvent(
            request: NetworkEvent.Request(
               verb: "GET",
               method: "/articles",
               basepoint: "https://api.com",
               hasBody: false,
               parameters: [:],
               headers: [:]),
            response: NetworkEvent.Response(
               statusCode: 200,
               data: nil,
               failureReason: "failure"))

         let messageEvent = MessageEvent("message")

         let logger: EventLogger = MonitorComposer.shared
            .makeLogger(subsystem: "network")

         logger.log(networkEvent)
         logger.log(messageEvent)

         MonitorComposer.shared.presenter.push(into: UINavigationController())
         MonitorComposer.shared.presenter.show(over: UIViewController())
         MonitorComposer.shared.presenter.enableShakeToShow(rootViewController: UIViewController())
         MonitorComposer.shared.presenter.disableShakeToShow()
      }
   }
}
