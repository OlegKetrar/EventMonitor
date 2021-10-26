//
//  NetworkEventDetailsPresenter.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

final class NetworkEventDetailsPresenter: NetworkEventDetailsVCPresenter {
   let viewModel: NetworkEventDetailsViewModel

   private weak var navigationController: UINavigationController?

   init(event: NetworkEvent, subsystem: String) {
      viewModel = NetworkEventDetailsViewModel(event: event, subsystem: subsystem)
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      navigationController = nc
      nc.pushViewController(NetworkEventDetailsVC(presenter: self), animated: animated)
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
