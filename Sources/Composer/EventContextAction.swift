//
//  EventContextAction.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import class UIKit.UIImage

/// Describes contextual action to perform with custom event.
public protocol EventContextAction<Event> {
   associatedtype Event

   var title: String { get }
   var image: UIImage { get }

   func perform(_ event: Event) async throws
}
