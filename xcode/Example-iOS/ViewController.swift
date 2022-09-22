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

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()

//      Monitor.presenter.enableShakeToShow(rootViewController: self)
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
      MonitorComposer.shared
         .makeLogger(subsystem: "system")
         .log(NetworkEvent.makeMock())
   }

   @objc func actionAddCustomEvent() {
      MonitorComposer.shared.log(MessageEvent("FFFFF"))
   }

   @objc func actionShowMonitor() {
      MonitorComposer.shared
         .makeView()
         .present(over: navigationController)
   }

   @objc func actionPushMonitor() {
      MonitorComposer.shared
         .makeView()
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
