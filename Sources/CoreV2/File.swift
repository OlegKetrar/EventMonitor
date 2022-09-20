//
//  EventProvider.swift
//
//
//  Created by Oleg Ketrar on 21.09.2022.
//

import Foundation

public protocol EventProvider {
   func getSessions() -> [Session]
   func getActiveSession() -> ActiveSession
   func getEventsForSession(_ session: Session) -> [AnyEvent]
   func getActionsForEvent(_ event: AnyEvent) -> [String]
}
