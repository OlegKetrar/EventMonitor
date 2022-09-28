//
//  ShareAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 28.09.2022.
//

import Foundation
import MonitorCore
import class UIKit.UINavigationController
import class UIKit.UIImage

public struct ShareAction<Event>: EventContextAction {
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
      let exporter = FileExporter(formatter: config.format(event:))

      let file = await exporter.prepareFile(
         named: config.makeFileName(event: event),
         content: { $0(event) })

      await MainActor.run {
         FileSharingPresenter(filePath: file?.path)
            .share(over: navigation, completion: {
                // let arc to remove file from disk
               _ = file
            })
      }
   }
}
