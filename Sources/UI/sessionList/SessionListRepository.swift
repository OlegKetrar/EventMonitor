//
//  SessionListRepository.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 26.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import MonitorCore

// TODO: delete session
// TODO: start new session (stop current / restart)

protocol SessionListRepository {
   func fetchSessions() -> Observable<[SessionInfo]>
}
