//
//  ViewController.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 29.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit
import EventMonitor

final class ViewController: UIViewController {
   private var viewEventLogger: (String) -> Void = { _ in }
   private var requestLogger: (ExampleNetworkEvent) -> Void = { _ in }
   private var analyticLogger: (String) -> Void = { _ in }

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()

      let networkService = ExampleNetworkService()
      configureEventMonitor(networkService)

      MonitorComposer.shared
         .presenter
         .enableShakeToShow(rootViewController: self)

      self.viewEventLogger = {
         MonitorComposer.shared
            .makeLogger(subsystem: "ViewController")
            .log($0)
      }

      self.requestLogger = MonitorComposer.shared
         .makeLogger(subsystem: "network")
         .log(_:)

      self.analyticLogger = {
         MonitorComposer.shared
            .makeLogger(subsystem: "analytics")
            .log($0)
      }
   }

   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      viewEventLogger("didAppear")
      analyticLogger("shown")
   }

   override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      viewEventLogger("didDisappear")
      analyticLogger("hidden")
   }
}

private extension ViewController {

   func configureUI() {
      navigationItem.title = "Example"

      let addSystemEvent = UIButton(type: .system)
      addSystemEvent.setTitle("Add system event", for: .normal)
      addSystemEvent.addTarget(self, action: #selector(actionAddSystemEvent), for: .touchUpInside)

      let addCustomEvent = UIButton(type: .system)
      addCustomEvent.setTitle("Add custom event", for: .normal)
      addCustomEvent.addTarget(self, action: #selector(actionAddCustomEvent), for: .touchUpInside)

      let showMonitorButton = UIButton(type: .system)
      showMonitorButton.setTitle("Present monitor", for: .normal)
      showMonitorButton.addTarget(self, action: #selector(actionShowMonitor), for: .touchUpInside)

      let pushMonitorButton = UIButton(type: .system)
      pushMonitorButton.setTitle("Push monitor", for: .normal)
      pushMonitorButton.addTarget(self, action: #selector(actionPushMonitor), for: .touchUpInside)

      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.spacing = 10

      stackView.addArrangedSubview(addSystemEvent)
      stackView.addArrangedSubview(addCustomEvent)
      stackView.addArrangedSubview(showMonitorButton)
      stackView.addArrangedSubview(pushMonitorButton)

      view.addSubview(stackView)

      NSLayoutConstraint.activate([
         addSystemEvent.heightAnchor.constraint(equalToConstant: 40),
         addCustomEvent.heightAnchor.constraint(equalToConstant: 40),
         showMonitorButton.heightAnchor.constraint(equalToConstant: 40),
         pushMonitorButton.heightAnchor.constraint(equalToConstant: 40),

         stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
         stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
   }

   @objc func actionAddSystemEvent() {
      requestLogger(ExampleNetworkEvent(
         networkData: .makeMock(),
         cUrlRepresentation: "curl request.url --header \"header:1\"",
         request: ExampleAppRequest(
            url: "request",
            method: "GET",
            headers: [:])))
   }

   @objc func actionAddCustomEvent() {
      MonitorComposer.shared
         .makeLogger(subsystem: "system_network")
         .log(NetworkEvent.makeMock())
   }

   @objc func actionShowMonitor() {
      MonitorComposer.shared
         .presenter
         .show(over: navigationController)
   }

   @objc func actionPushMonitor() {
      MonitorComposer.shared
         .presenter
         .push(into: navigationController)
   }
}

private extension NetworkEvent {

   static func makeMock() -> NetworkEvent {



      return NetworkEvent(
         request: NetworkEvent.Request(
            verb: "get",
            method: "/products",
            basepoint: "www.basepoint.com",
            hasBody: false,
            parameters: [
               "intParam" : 10,
               "strParam" : "stringValue",
               "arrayParam" : ["one", "two"],
               "boolParam" : false
            ],
            headers: [
               "header-one" : "value1",
               "header-two" : "value2"
            ]),
         response: NetworkEvent.Response(
            statusCode: 200,
            data: json.data(using: .utf8),
            failureReason: nil))
   }
}

private let json: String = #"""
{
  "products" : [
    {
      "name" : "MacBook Air",
      "year" : 2017,
      "price" : "1500.00",
      "available" : true
    },
    {
      "name" : "MacBook Pro",
      "year" : 2015,
      "price" : "2050.99",
      "available" : true
    }
  ]
}
"""#
