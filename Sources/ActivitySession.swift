//
//  ActivitySession.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

struct ActivitySession {
   var title: String
   var createdAt: Date = Date()
   var events: [ActivityEvent]
   var isActive: Bool = false
}
