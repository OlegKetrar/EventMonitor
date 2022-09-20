//
//  EventContextAction.swift
//  
//
//  Created by Oleg Ketrar on 18.09.2022.
//

protocol EventContextAction {
   associatedtype Event
   func perform(_ event: Event) async throws
}
