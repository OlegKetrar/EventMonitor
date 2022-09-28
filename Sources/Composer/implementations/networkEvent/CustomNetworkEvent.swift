//
//  CustomNetworkEvent.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 28.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import MonitorCore

public protocol CustomNetworkEvent: Event {
   var networkData: NetworkEvent { get }
}
