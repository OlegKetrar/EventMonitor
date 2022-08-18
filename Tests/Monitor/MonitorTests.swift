//
//  MonitorTests.swift
//  EventMonitorTests
//
//  Created by Oleg Ketrar on 24.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import XCTest
import EventMonitor

final class MonitorTests: XCTestCase {

   /// We only want to test visibility of certain API here.
   /// So wrapping in a closure let the compiler to type check it, but prevent from actual running.
   func testImportVisibility() {
      _ = {
         let networkEvent = Event.network(NetworkEvent(
            request: NetworkEvent.Request(
               verb: "GET",
               method: "/articles",
               basepoint: "https://api.com",
               hasBody: false,
               parameters: [:],
               headers: [:]),
            response: NetworkEvent.Response(
               statusCode: 200,
               jsonString: nil,
               failureReason: "failure")))

         let logger: Logger = Monitor
            .makeLogger(subsystem: "network")

         logger.log(event: networkEvent)

         Monitor.presenter.push(into: UINavigationController())
         Monitor.presenter.show(over: UIViewController())
         Monitor.presenter.enableShakeToShow(rootViewController: UIViewController())
         Monitor.presenter.disableShakeToShow()
      }
   }
}
