//
//  MenuBuilder.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public struct MenuBuilder {
   let viewModel: EventMenuViewModel

   public init(viewModel: EventMenuViewModel) {
      self.viewModel = viewModel
   }

   public func makeConfiguration() -> MenuConfiguration? {

      if viewModel.items.count > 1 {
         return .menu({
            makeMenu(setLoadingVisible: $0)
         })

      } else if let item = viewModel.items.first {
         return .singleAction(
            icon: item.image,
            action: {
               try await viewModel.selectItem(at: 0)
            })

      } else {
         return nil
      }
   }

   func makeMenu(setLoadingVisible: @escaping (Bool) -> Void) -> UIMenu {
      UIMenu(
         title: "",
         children: viewModel.items.enumerated().map { index, item in
            UIAction(
               title: item.title,
               image: item.image,
               attributes: [],
               state: .off,
               handler: { _ in
                  setLoadingVisible(true)

                  Task {
                     try await viewModel.selectItem(at: index)

                     await MainActor.run {
                        setLoadingVisible(false)
                     }
                  }
               })
         })
   }
}
