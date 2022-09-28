//
//  HelloWorldAction.swift
//  
//
//  Created by Oleg Ketrar on 28.09.2022.
//

import Foundation
import MonitorCore
import class UIKit.UINavigationController
import class UIKit.UIImage

public struct HelloWorldAction<SomeEvent>: EventContextAction {

   public var title: String {
      "Hello world!!!"
   }

   public var image: UIImage {
      UIImage(systemName: "play.circle") ?? UIImage()
   }

   public func perform(_ event: SomeEvent, navigation: UINavigationController?) async throws {
      print("Hello worlds")
   }
}
