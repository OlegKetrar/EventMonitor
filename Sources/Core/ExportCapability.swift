//
//  ExportCapability.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 27.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public protocol SessionFormatting {
   func format(_ session: EventSession) -> String
}

public protocol EventFormatting {
   func format(_ event: GroupedEvent) -> String
}

public struct ExportCapability<Formatter> {
   public var name: String
   public var exporter: FileExporter<Formatter>
}
