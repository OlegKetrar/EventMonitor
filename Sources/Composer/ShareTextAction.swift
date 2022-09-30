//
//  ShareTextAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 28.09.2022.
//

import Foundation
import MonitorCore
import class UIKit.UINavigationController
import class UIKit.UIImage

public struct ShareTextAction<Event>: EventContextAction {
   let config: any SharingConfiguration<Event>

   public init<Config: SharingConfiguration>(configuration: Config) where Config.Event == Event {
      self.config = configuration
   }

   public var title: String {
      "Share .log"
   }

   public var image: UIImage {
      UIImage(systemName: "square.and.arrow.up") ?? UIImage()
   }

   public func perform(_ event: Event, navigation: UINavigationController?) async throws {
      let text = config.format(event: event)

      await MainActor.run {
         SharingPresenter(plainText: text).share(over: navigation)
      }
   }
}
