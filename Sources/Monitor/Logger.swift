//
//  Logger.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import MonitorCore

public protocol Logger {
   func log(event: Event)
}
