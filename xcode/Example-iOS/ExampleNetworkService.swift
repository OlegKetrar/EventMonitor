//
//  ExampleAppNetworkEvent.swift
//  Example-iOS
//
//  Created by Oleg Ketrar on 28.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

struct ExampleAppRequest: Codable {
   var url: String
   var method: String
   var headers: [String : String]
}

final class ExampleNetworkService {
   struct NetworkError: Error {}

   func execute(_ request: ExampleAppRequest) async throws {
      throw NetworkError()
   }
}
