//
//  MenuPopoverBuilder.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public struct MenuPopoverBuilder {
   let viewModel: EventMenuViewModel

   public init(viewModel: EventMenuViewModel) {
      self.viewModel = viewModel
   }

   public func makeConfiguration() -> MenuConfiguration? {

      if viewModel.items.count > 1 {
         return .menu(popover: {
            // TODO: implement UIPopoverController

            return MenuViewController()
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
}
