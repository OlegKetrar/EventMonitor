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

final class NetworkEventDetailsPresenter: NetworkEventDetailsVCPresenter {
   let viewModel: NetworkEventDetailsViewModel

   private weak var navigationController: UINavigationController?

   init(
      event: NetworkEvent,
      subsystem: String,
      exportCapabilities: [ExportCapability<EventFormatting>]
   ) {
      viewModel = NetworkEventDetailsViewModel(
         event: event,
         subsystem: subsystem,
         exportCapabilities: exportCapabilities)
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      navigationController = nc
      nc.pushViewController(NetworkEventDetailsVC(presenter: self), animated: animated)
   }

   func shareEvent(_ completion: @escaping () -> Void) {
      viewModel.makeExportableFile { [weak self] file in

         FileSharingPresenter().share(
            file: file,
            presentOver: self?.navigationController)

         completion()
      }
   }
}