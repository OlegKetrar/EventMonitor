//
//  SessionPresenter.swift
//  NetworkMonitor
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
   private let exportCapability: ExportCapability<SessionFormatting>

   private weak var navigationController: UINavigationController?
   private var onSelectEventCallback: (GroupedEvent) -> Void = { _ in }

   init(
      session: Observable<EventSession>,
      exportCapability: ExportCapability<SessionFormatting>
   ) {
      self.viewModel = SessionViewModel(session: session)
      self.exportCapability = exportCapability

       // pass `exportCapabilities` to viewModel
       // viewState should contain `hasShareButton: Bool`
   }

   func onSelectEvent(_ callback: @escaping (GroupedEvent) -> Void) -> Self {
      self.onSelectEventCallback = callback
      return self
   }

   func push(into nc: UINavigationController, animated: Bool = true) {
      navigationController = nc
      nc.pushViewController(SessionVC(presenter: self), animated: animated)
   }

   func shareSession(_ completion: @escaping () -> Void) {
      exportCapability.exporter.prepareFile(
         named: "\(viewModel.state.value.exportFileName).log",
         content: {
            viewModel.formatSession(with: $0)
         },
         completion: { [weak self] in
            FileSharingPresenter().share(
               file: $0,
               presentOver: self?.navigationController)

            completion()
         })
   }

   func selectEvent(at index: Int, completion: @escaping () -> Void) {
      if let event = viewModel.getSessionEvent(at: index) {
         onSelectEventCallback(event)
      }

      completion()
   }
}
