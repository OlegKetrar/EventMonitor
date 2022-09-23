//
//  AnyEvent+Codable.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation

struct ParsingError: Error {}

extension AnyEvent: Codable {

   enum CodingKeys: String, CodingKey {
       case subsystem = "s"
       case type = "t"
       case payload = "p"
   }

   public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      self.subsystem = try container.decode(String.self, forKey: .subsystem)
      let typeID = try container.decode(String.self, forKey: .type)

      if let type = TypeRegistry.get(typeID) {
         self.type = type
         self.payload = try container.decode(type.self, forKey: .payload)

      } else {
         throw ParsingError()
      }
   }

   public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(subsystem, forKey: .subsystem)
      try container.encode(String(describing: type), forKey: .type)
      try container.encode(payload, forKey: .payload)
   }
}
