//
//  File.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation

/*
 sessionList
 session
 details
*/

//struct MessageEvent: Event {}
//
//enum MessageEventAction: EventContextAction {
//   case share
//   case copy
//
//   func perform(_ event: MessageEvent) async throws {
//      switch self {
//      case .copy:
//         break
//
//      case .share:
//         break
//      }
//   }
//}
//
//enum NetworkEventAction: EventContextAction {
//   case copy
//   case cUrl
//   case tasteIt
//
//   func perform(_ event: NetworkEvent) async throws {
//      switch self {
//      case .copy:
//         break
//
//      case .cUrl:
//         break
//
//      case .tasteIt:
//         break
//      }
//   }
//}

//struct Processor {
//
////   var
//
//   func register<T: Event, Action: EventContextAction>(
//      event: T.Type,
//      actions: [Action]
//
//   ) where Action.Event == T {
//
//
//
//   }
//
//   static func test() {
//      let processor = Processor()
//
//      processor.register(event: NetworkEvent.self, actions: [
//         NetworkEventAction.copy,
//         NetworkEventAction.cUrl,
//         NetworkEventAction.tasteIt,
//      ])
//
//      processor.register(event: MessageEvent.self, actions: [
//         MessageEventAction.copy,
//         MessageEventAction.share,
//      ])
//   }
//}
