//
//  ViewController.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 29.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import UIKit
import NetworkMonitor

/*
 Monitor.presenter.show(over: self)
 Monitor.presenter.push(into: navigationController)
 Monitor.presenter.enableShakeToShow(rootViewController: self)
 Monitor.presenter.disableShakeToShow()

 Monitor.exporter.options = [
    SessionExportOption(title: "cURL", formatter: cURLFormatter()),
    EventExportOption(title: "cURL", formatter: cURLFormatter()),
    ...
 ]

 let netLogger = Monitor.makeLogger(subsystem: "network")
 let kmtxLogger = Monitor.makeLogger(subsystem: "kmtx")
 let genesysLogger = Mmonitor.makeLogger(subsystem: "genesys")
 let debugLogger = Mmonitor.makeLogger(subsystem: "debug-info")

 netLogger.log(networkEvent)
 debugLogger.log("blablabla")
 */

final class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()

      Monitor.presenter.enableShakeToShow(rootViewController: self)
   }
}

private extension ViewController {

   func configureUI() {
      navigationItem.title = "Example"

      let addDefaultEventButton = UIButton(type: .system)
      addDefaultEventButton.setTitle("Add event", for: .normal)
      addDefaultEventButton.addTarget(self, action: #selector(actionAddDefaultEvent), for: .touchUpInside)

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

      stackView.addArrangedSubview(addDefaultEventButton)
      stackView.addArrangedSubview(addSystemEvent)
      stackView.addArrangedSubview(addCustomEvent)
      stackView.addArrangedSubview(showMonitorButton)
      stackView.addArrangedSubview(pushMonitorButton)

      view.addSubview(stackView)

      NSLayoutConstraint.activate([
         addDefaultEventButton.heightAnchor.constraint(equalToConstant: 40),
         addSystemEvent.heightAnchor.constraint(equalToConstant: 40),
         addCustomEvent.heightAnchor.constraint(equalToConstant: 40),
         showMonitorButton.heightAnchor.constraint(equalToConstant: 40),
         pushMonitorButton.heightAnchor.constraint(equalToConstant: 40),

         stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
         stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
   }

   @objc func actionAddDefaultEvent() {

   }

   @objc func actionAddSystemEvent() {
      Monitor
         .makeLogger(subsystem: "system")
         .log(event: .message(MessageEvent(message: "log")))
   }

   @objc func actionAddCustomEvent() {
      Monitor.makeLogger(subsystem: "custom").log(event: .network(.makeMock()))
   }

   @objc func actionShowMonitor() {
      navigationController.map { Monitor.presenter.show(over: $0) }
   }

   @objc func actionPushMonitor() {
      navigationController.map { Monitor.presenter.push(into: $0) }
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
            jsonString: #"""
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
            """#,
            failureReason: nil))
   }
}
