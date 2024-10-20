//
//  ExampleNetworkEvent.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 28.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import EventMonitor

struct ExampleNetworkEvent: CustomNetworkEvent {
   var networkData: NetworkEvent
   var cUrlRepresentation: String
   var request: ExampleAppRequest
}

struct CopyCurlContextAction: EventContextAction {

   var title: String {
      "Copy cURL"
   }

   var image: UIImage {
      UIImage(systemName: "play.circle") ?? UIImage()
   }

   func perform(_ event: ExampleNetworkEvent, navigation: UINavigationController?) async throws {
      UIPasteboard.general.string = event.cUrlRepresentation
   }
}

struct ShareCurlContextAction: EventContextAction {

   struct ShareActionConfig: SharingConfiguration {

      func format(event: ExampleNetworkEvent) -> String {
         event.cUrlRepresentation
      }

      func makeFileName(event: ExampleNetworkEvent) -> String {
         "curl_" + event.networkData.makeFileName()
      }
   }

   var title: String {
      "Share cURL"
   }

   var image: UIImage {
      UIImage(systemName: "play.circle") ?? UIImage()
   }

   func perform(_ event: ExampleNetworkEvent, navigation: UINavigationController?) async throws {
      try await ShareFileAction
         .init(configuration: ShareActionConfig())
         .perform(event, navigation: navigation)
   }
}

struct RetryEventContextAction: EventContextAction {
   let service: ExampleNetworkService

   var title: String {
      "Retry request"
   }

   var image: UIImage {
      UIImage(systemName: "play.circle") ?? UIImage()
   }

   func perform(_ event: ExampleNetworkEvent, navigation: UINavigationController?) async throws {
      try await service.execute(event.request)

      // TODO: how to update existing UI ?
   }
}

func configureEventMonitor(_ service: ExampleNetworkService) {
   MonitorComposer.shared.registerCustomNetwork(
      event: ExampleNetworkEvent.self,
      configuration: { config in
         config
            .addAction(CopyCurlContextAction())
            .addAction(ShareCurlContextAction())
            .addAction(RetryEventContextAction(service: service))
      })

   MonitorComposer.shared
      .setInitialSubsystems(["network"])
}
