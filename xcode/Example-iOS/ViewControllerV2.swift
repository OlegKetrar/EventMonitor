//
//  ViewControllerV2.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 20.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorCoreV2
import UIKit

final class ViewControllerV2: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()

//      Monitor.presenter.enableShakeToShow(rootViewController: self)
   }
}

private extension ViewControllerV2 {

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
//      Monitor
//         .makeLogger(subsystem: "system")
//         .log(event: .network(.makeMock()))
   }

   @objc func actionAddCustomEvent() {
//      Monitor.makeLogger(subsystem: "custom").log(event: .network(.makeMock()))
   }

   @objc func actionShowMonitor() {
//      navigationController.map { Monitor.presenter.show(over: $0) }

      MonitorComposer.shared
         .makeView()
         .present(over: navigationController)
   }

   @objc func actionPushMonitor() {
//      navigationController.map { Monitor.presenter.push(into: $0) }

      MonitorComposer.shared
         .makeView()
         .push(into: navigationController)
   }
}

//private extension NetworkEvent {
//
//   static func makeMock() -> NetworkEvent {
//      return NetworkEvent(
//         request: NetworkEvent.Request(
//            verb: "get",
//            method: "/products",
//            basepoint: "www.basepoint.com",
//            hasBody: false,
//            parameters: [
//               "intParam" : 10,
//               "strParam" : "stringValue",
//               "arrayParam" : ["one", "two"],
//               "boolParam" : false
//            ],
//            headers: [
//               "header-one" : "value1",
//               "header-two" : "value2"
//            ]),
//         response: NetworkEvent.Response(
//            statusCode: 200,
//            jsonString: #"""
//            {
//              "products" : [
//                {
//                  "name" : "MacBook Air",
//                  "year" : 2017,
//                  "price" : "1500.00",
//                  "available" : true
//                },
//                {
//                  "name" : "MacBook Pro",
//                  "year" : 2015,
//                  "price" : "2050.99",
//                  "available" : true
//                }
//              ]
//            }
//            """#,
//            failureReason: nil))
//   }
//}
