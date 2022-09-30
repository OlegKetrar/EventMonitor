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

   public let title: String
   public let image: UIImage

   public init<Config: SharingConfiguration>(
      title: String = "Share",
      image: UIImage? = UIImage(systemName: "square.and.arrow.up"),
      configuration: Config
   ) where Config.Event == Event {

      self.config = configuration
      self.title = title
      self.image = image ?? UIImage()
   }

   public func perform(_ event: Event, navigation: UINavigationController?) async throws {
      let text = config.format(event: event)

      await MainActor.run {
         SharingPresenter(plainText: text).share(over: navigation)
      }
   }
}
