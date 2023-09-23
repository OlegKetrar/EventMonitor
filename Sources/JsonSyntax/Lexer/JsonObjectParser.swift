//
//  JsonObjectParser.swift
//  JsonSyntax
//
//  Created by Oleg Ketrar on 04.11.2022.
//

import Foundation

struct JsonObjectParser {

   func parse(_ object: Any) throws -> ParseTree {

      // int
      // double
      // bool
      // string
      // array -> [Any]
      // dictionary -> [String : Any]
      // null

      switch object {
      case let string as String:
         return .string(.from(0, literal: string))

      case true as Bool:
         return .literal(.from(0, 4), .true)

      case false as Bool:
         return .literal(.from(0, 5), .false)

      case _ as NSNull:
         return .literal(.from(0, 4), .null)

//      case let number as Int:
//         return .number(.from(<#T##start: Int##Int#>, literal: <#T##String#>))
//
//      case let double as Double:
//         fatalError()

      default:
         fatalError()
      }
   }
}
