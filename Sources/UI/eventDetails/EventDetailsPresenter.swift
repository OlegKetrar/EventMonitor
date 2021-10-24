//
//  EventDetailsPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

final class EventDetailsPresenter: EventDetailsVCPresenter {
   let viewModel: EventDetailsViewModel

   private weak var navigationController: UINavigationController?

   init(event: GroupedEvent) {
      viewModel = EventDetailsViewModel()
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      navigationController = nc
      nc.pushViewController(EventDetailsVC(presenter: self), animated: animated)
   }

   func shareEvent(_ completion: @escaping () -> Void) {
//      let eventToShare = viewModel.formatEvent()

      FileSharingPresenter().shareFile(
         name: "", // eventToShare.fileName
         content: {
            self.viewModel.formatEvent()

//            PlainTextFormatter().format(event: eventToShare)
         },
         completion: { [weak self] in
            self?.navigationController?.present($0, animated: true)
            completion()
         })
   }
}
