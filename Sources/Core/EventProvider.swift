//
//  EventProvider.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public protocol EventProvider {

   func fetchSessions() -> Observable<[SessionInfo]>
   func fetchActiveSession() -> Observable<EventSession>

   func fetchEventSession(
      identifier: SessionIdentifier,
      completion: @escaping (Observable<EventSession>) -> Void)
}
