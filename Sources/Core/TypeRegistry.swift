//
//  TypeRegistry.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct TypeRegistry {
   private static var dict: [String : any Codable.Type] = [:]

   static func get(_ id: String) -> (any Codable.Type)? {
      dict[id]
   }

   public static func register(id: String, value: any Codable.Type) {
      dict[id] = value
   }
}
