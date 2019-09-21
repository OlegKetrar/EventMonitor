//
//  EventDetailsPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import Dispatch

final class EventDetailsPresenter: Presenter, FileSharingTrait {
   let event: ActivityEvent

   init(event: ActivityEvent) {
      self.event = event
   }

   func share(_ completion: @escaping () -> Void) {
      let eventToShare = event

      shareFile(
         name: eventToShare.fileName,
         content: { PlainTextFormatter().format(event: eventToShare) },
         completion: { [weak self] in
            guard let strongSelf = self else { return }
            completion()

            if let shareAlert = $0 {
               strongSelf.navigationController?.present(shareAlert, animated: true)
            }
      })
   }
}

private extension ActivityEvent {

   var fileName: String {
      return "\(request.verb)\(request.method).log"
         .replacingOccurrences(of: "/", with: "_")
         .lowercased()
   }
}
