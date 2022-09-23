//
//  EventContextAction.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

public protocol EventContextAction {
   associatedtype Event
   func perform(_ event: Event) async throws
}

public protocol SessionAction {
   func perform(_ session: EventSession) async throws
}
