//
//  MonitorTests.swift
//  NetworkMonitorTests
//
//  Created by Oleg Ketrar on 24.10.2021.
//

import XCTest
import NetworkMonitor

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

         let messageEvent = Event.message(MessageEvent(message: "test"))

         let logger: Logger = Monitor
            .makeLogger(subsystem: "network")

         logger.log(event: networkEvent)
         logger.log(event: messageEvent)

         Monitor.presenter.push(into: UINavigationController())
         Monitor.presenter.show(over: UIViewController())
         Monitor.presenter.enableShakeToShow(rootViewController: UIViewController())
         Monitor.presenter.disableShakeToShow()

         Monitor.exportOptions = [

         ]
      }
   }
}
