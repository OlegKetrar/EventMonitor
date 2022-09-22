//
//  MonitorComposer.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import MonitorCore
import MonitorUI
import class UIKit.UIViewController

extension NetworkEvent: Event {}
extension MessageEvent: Event {}

struct NetworkEventConfig: EventViewConfiguration {

   func configure(cell: NetworkEventCell, event: NetworkEvent) -> NetworkEventCell {
      cell.with(verb: event.request.verb.uppercased())
      cell.with(request: event.request.method)
      cell.with(success: event.response.failureReason == nil)

      return cell
   }

   func buildDetailView(_ event: NetworkEvent) -> UIViewController? {
      let presenter = NetworkEventDetailsPresenter(
         event: event,
         subsystem: "") // FIXME

      return NetworkEventDetailsVC(presenter: presenter)
   }
}

struct MessageEventConfig: EventViewConfiguration {
   typealias Event = MessageEvent
   typealias EventCell = NetworkEventCell

   func configure(cell: NetworkEventCell, event: MessageEvent) -> NetworkEventCell {
//      cell.with(verb: event.request.verb.uppercased())
//      cell.with(request: event.request.method)
//      cell.with(success: event.response.failureReason == nil)

      return cell
   }

   func buildDetailView(_ event: MessageEvent) -> UIViewController? {
      return nil
   }
}

extension NetworkEventCell: HaveReuseIdentifier {
   public static var reuseID: String { String(describing: self) }
}

public class MonitorComposer {
   public static let shared = MonitorComposer()

   private let processor: EventProcessor = {
      let tmpDir = NSTemporaryDirectory() as NSString
      let path = tmpDir.appendingPathComponent("network-monitor.session-logs")
      let store = FileEventStorage(directoryPath: path)
      let processor = EventProcessor(storage: store)

      return processor
   }()

   init() {
      self.register(
         event: NetworkEvent.self,
         configuration: NetworkEventConfig())

      self.register(
         event: MessageEvent.self,
         configuration: MessageEventConfig())
   }

   private var configs: [AnyEventViewFactory] = []

   public func register<SomeEvent, ViewConfiguration>(
      event: SomeEvent.Type,
      configuration: ViewConfiguration
   ) where
      SomeEvent: Event,
      ViewConfiguration: EventViewConfiguration,
      ViewConfiguration.Event == SomeEvent
   {

      TypeRegistry.register(
         id: String(describing: event),
         value: event)

      configs.append(AnyEventViewFactory(configuration))
   }

   public func log<SomeEvent: Event>(_ event: SomeEvent) {
      processor.log(event: event, subsystem: "default")
   }

   public func makeLogger(subsystem: String) -> EventLogger {
      EventLogger(
         subsystem: subsystem,
         impl: processor)
   }

   public func makeView() -> MonitorView {
      UIKitMonitorView(
         provider: processor,
         configs: configs)
   }
}

extension EventProcessor: LoggerImpl {}
