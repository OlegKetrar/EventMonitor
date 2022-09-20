//
//  MonitorPresenter.swift
//  
//
//  Created by Oleg Ketrar on 19.09.2022.
//

import Foundation
import UIKit
import SwiftUI

protocol ViewFactory {
   associatedtype View

   func makeView() -> View
}

struct MonitorPresenter<Factory: ViewFactory> {
   let viewFactory: Factory
}

extension MonitorPresenter where Factory.View == UIViewController {

   func push(into nc: UINavigationController) {

   }

   func present(over vc: UIViewController) {

   }
}

@available(iOS 13.0, *)
struct SwiftUIViewFactory: ViewFactory {

   func makeView() -> ContentView {
      ContentView(navigation: .constant(.session))
   }
}

@available(iOS 13.0, *)
struct ContentView: View {

   enum Navigation {
      case sessionList
      case session
      case eventDetails
   }

   @Binding<Navigation> var navigation: Navigation

   var body: some View {
      ZStack {
         switch navigation {
         case .sessionList:
            Text("session list")
               .background(Color.yellow)

         case .session:
            Text("session screen")
               .background(Color.red)

         case .eventDetails:
            Text("event details screen")
               .background(Color.green)
         }
      }
   }
}

@available(iOS 13.0, *)
extension MonitorPresenter where Factory.View: SwiftUI.View {

   func makeView() -> some View {
      viewFactory.makeView()
   }
}
