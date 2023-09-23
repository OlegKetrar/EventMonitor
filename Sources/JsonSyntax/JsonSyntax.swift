//
//  JsonSyntax.swift
//  JsonSyntax
//
//  Created by Oleg Ketrar on 20/05/2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct JsonSyntax {
   public init() {}

   public func parse(_ data: Data) throws -> ParseTree {
      let obj = try JSONSerialization.jsonObject(
         with: data,
         options: .fragmentsAllowed)

      return try JsonObjectParser().parse(obj)
   }
}
