//
//  JsonMutator.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 19.10.2024.
//

import Foundation
import JsonSyntax

public protocol NetworkResponseMutator {
   func process(_ response: String?) -> String?
}

final class JsonMutator: NetworkResponseMutator {
   var modifications: [JsonModification] = []

   func process(_ response: String?) -> String? {
      return response
   }
}

struct JsonModification {
    var path: JsonPath
    var replacement: String
}
