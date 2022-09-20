//
//  SwiftUIView.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import SwiftUI
//import MonitorCoreV2

struct NetworkEvent {
   var request: String
   var isSuccess: Bool
}

//struct MessageEventListConfig: TableViewConfiguration {
//
//}

//@available(iOS 13.0, *)
//struct NetworkEventListConfig: TableViewConfiguration {
//   typealias Cell = NetworkEventView
//
//   func itemsCount() -> Int {
//
//   }
//
//   func getCell(at index: Int) -> Cell? {
//      NetworkEventView
//   }
//
//   func didSelectCell(at index: Int) {
//
//   }
//}

@available(iOS 13.0, *)
struct NetworkEventView: View {
   var request: String = ""

   var body: some View {
      HStack {
         Text("GET")
         Text("\(request)")
      }
   }
}

@available(iOS 13.0, *)
struct SwiftUIView: View {
   let event: NetworkEvent

   var body: some View {
      var view = NetworkEventView()
      view.request = event.request

      return view
   }
}

@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {

    static var previews: some View {
       SwiftUIView
          .init(event: NetworkEvent(request: "fff", isSuccess: false))
          .previewLayout(.sizeThatFits)
    }
}
