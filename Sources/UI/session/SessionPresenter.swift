//
//  SessionPresenter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorCore

// TODO: ask viewModel to show share button or not

final class SessionPresenter: SessionVCPresenter {
   let viewModel: SessionViewModel
   let configuration: SessionViewConfiguration

//   private let exportCapability: ExportCapability<SessionFormatting>

   private weak var navigationController: UINavigationController?

   init(
      session: Observable<EventSession>,
      configs: [AnyEventViewFactory],
      navigation: UINavigationController?
   ) {
      self.viewModel = SessionViewModel(session: session)
      self.navigationController = navigation

      let events = Observable(session.value.events)
      session.notify { newSession in
         events.mutate { $0 = newSession.events }
      }

      self.configuration = SessionViewConfigurationAdapter(
         events: events,
         factories: configs)

       // pass `exportCapabilities` to viewModel
       // viewState should contain `hasShareButton: Bool`
   }

   func shareSession(_ completion: @escaping () -> Void) {
//      exportCapability.exporter.prepareFile(
//         named: "\(viewModel.state.value.exportFileName).log",
//         content: {
//            viewModel.formatSession(with: $0)
//         },
//         completion: { [weak self] file in
//            FileSharingPresenter(filePath: file?.path).share(
//               over: self?.navigationController,
//               completion: {
//
//                  // let arc to remove file from disk
//                  _ = file
//
//                  completion()
//               })
//         })
   }

   func selectEvent(at indexPath: IndexPath, completion: @escaping () -> Void) {

      if let detailVC = configuration.makeDetailViewController(for: indexPath) {
         navigationController?.pushViewController(detailVC, animated: true)
      }

      completion()
   }
}
