//
//  EventConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import MonitorUI
import MonitorCore

public protocol EventConfiguration<Event>: EventViewConfiguration, EventContextActionConfiguraion {}
