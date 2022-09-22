//
//  AnyEvent.swift
//
//
//  Created by Oleg Ketrar on 19.09.2022.
//

public struct TypeRegistry {
   private static var dict: [String : any Codable.Type] = [:]

   static func get(_ id: String) -> (any Codable.Type)? {
      dict[id]
   }

   public static func register(id: String, value: any Codable.Type) {
      dict[id] = value
   }
}

struct ParsingError: Error {}

public struct AnyEvent: Codable {
   public var subsystem: String
   public var type: any Codable.Type
   public var payload: any Codable

   public init<T: Event>(_ event: T, subsystem: String) {
      self.subsystem = subsystem
      self.type = T.self
      self.payload = event
   }

   enum CodingKeys: String, CodingKey {
       case subsystem
       case type
       case payload
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
