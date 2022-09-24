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
   let items: [any EventMenuItem]

   public init(items: [any EventMenuItem]) {
      self.items = items
   }

   public func makeConfiguration(_ navigation: UINavigationController?) -> MenuConfiguration? {

      if items.count > 1 {
         return .menu({
            makeMenu(setLoadingVisible: $0, navigation: navigation)
         })

      } else if let item = items.first {
         return .singleAction(
            icon: item.image,
            action: {
               try await item.perform(navigation)
            })

      } else {
         return nil
      }
   }

   func makeMenu(
      setLoadingVisible: @escaping (Bool) -> Void,
      navigation: UINavigationController?
   ) -> UIMenu {

      UIMenu(
         title: "",
         children: items.map { item in
            UIAction(
               title: item.title,
               image: item.image,
               attributes: [],
               state: .off,
               handler: { _ in
                  setLoadingVisible(true)

                  Task {
                     try await item.perform(navigation)

                     await MainActor.run {
                        setLoadingVisible(false)
                     }
                  }
               })
         })
   }
}
