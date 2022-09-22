//
//  NetworkEventDetailsPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

public class NetworkEventDetailsPresenter: NetworkEventDetailsVCPresenter {

   public let viewModel: NetworkEventViewModel
   public let isOnlySharing: Bool

   private let event: NetworkEvent
   private let subsystem: String
//   private let exportCapabilities: [ExportCapability<EventFormatting>]
   private weak var detailsVC: UIViewController?

   public init(
      event: NetworkEvent,
      subsystem: String
//      exportCapabilities: [ExportCapability<EventFormatting>]
   ) {
      self.viewModel = NetworkEventViewModel(event)
      self.isOnlySharing = true
      self.event = event
      self.subsystem = subsystem
//      self.exportCapabilities = exportCapabilities
   }

   public func shareEvent(_ completion: @escaping () -> Void) {
/*
      guard let exporter = exportCapabilities.first?.exporter else {
         completion()
         return
      }

      exporter.prepareFile(
         named: event.makeFileName(),
         content: {
            $0.format(GroupedEvent(
               subsystem: subsystem,
               event: .network(event)))
         },
         completion: { [weak self] file in

            FileSharingPresenter(filePath: file?.path).share(
               over: self?.detailsVC,
               completion: {

                  // let arc to remove file from disk
                  _ = file

                  completion()
               })
         })
 */
   }

   public func makeMenuPopover() -> UIViewController {
      fatalError("unimplemented yet")
   }
}

private extension NetworkEvent {

   func makeFileName() -> String {
      "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
