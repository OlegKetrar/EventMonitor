//
//  Example.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation

/*
class UIKitImage {}
class UIKitTableViewCell {}
class UIKitViewController {}

class SwiftUIView {}
class SwiftUIEventView {}

class TestMonitor {
   func configure() {

      let processor = EventProcessor<EventMonitorViewConfig>()

      processor.register(
         event: NetworkEvent.self,
         configuration: NetworkEventConfiguration(),
         contextActions: [
            NetworkEventContextAction(
               title: "Share log",
               image: UIKitImage(),
               perform: {
                  print("-- share event -> request: \($0.request)")
               }),

            NetworkEventContextAction(
               title: "Share cURL",
               image: UIKitImage(),
               perform: {
                  print("-- share cURL -> request: \($0.request)")
               }),

            NetworkEventContextAction(
               title: "Test",
               image: UIKitImage(),
               perform: {
                  print("-- test -> request: \($0.request)")
               }),
         ])
   }
}

// MARK: -

struct NetworkEvent {
   var request: String
   var isSuccess: Bool
}

extension NetworkEvent: Event {}

// MARK: -

private struct EventMonitorViewConfig: ViewFramework {
   typealias EventView = UIKitTableViewCell
   typealias EventDetailView = UIKitViewController
}

struct NetworkEventConfiguration: EventViewConfiguration {
   typealias EventView = UIKitTableViewCell
   typealias EventDetailView = UIKitViewController

   func buildElement(_ event: NetworkEvent) -> UIKitTableViewCell {
      fatalError()
   }

   func buildDetailScreen(_ event: NetworkEvent) -> UIKitViewController? {
      nil
   }
}

// MARK: --

private struct NetworkEventContextAction: EventContextAction {
   var title: String
   var image: UIKitImage
   var perform: (NetworkEvent) async throws -> Void

   func perform(_ event: NetworkEvent) async throws {
      try await perform(event)
   }
}

// MARK: -

private final class SessionViewController: UIKitViewController {
   let config: AnyTableViewConfiguration<UIKitTableViewCell>

   init(configuration: AnyTableViewConfiguration<UIKitTableViewCell>) {
      self.config = configuration
   }

   /*
    config.itemsCount()
    config.getCell(at: indexPath.row)
    config.didSelectCell(at: indexPath.row)
    */
}

private final class SessionView: SwiftUIView {
   private let config: AnyTableViewConfiguration<SwiftUIEventView>

   init(configuration: AnyTableViewConfiguration<SwiftUIEventView>) {
      self.config = configuration
   }
}
*/
