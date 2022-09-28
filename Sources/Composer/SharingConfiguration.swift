//
//  SharingConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 28.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

public protocol SharingConfiguration<Event> {
   associatedtype Event

   func format(event: Event) -> String
   func makeFileName(event: Event) -> String
}
