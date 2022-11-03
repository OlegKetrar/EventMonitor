//
//  NetworkEvent.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 18.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation

public struct NetworkEvent: Codable {

   public struct Request: Codable {
      public var verb: String
      public var method: String
      public var basepoint: String
      public var getParams: String
      public var postParams: [String : String]
      public var headers: [String : String]

      /// - Parameters:
      ///   - verb: GET/POST/DELETE etc.
      ///   - method: API method, like `/users`.
      ///   - hasBody: Pass `true` for request if it contains HTTP body.
      ///   If request has only query parameters pass `false`.
      public init(
         verb: String,
         method: String,
         basepoint: String,
         hasBody: Bool,
         parameters: [String : Any],
         headers: [AnyHashable : Any]) {

         self.verb = verb
         self.method = method
         self.basepoint = basepoint

         let formattedParams = parameters.mapValues { "\($0)" }

         if hasBody {
            self.getParams = ""
            self.postParams = formattedParams

         } else {
            self.getParams = formattedParams.queryString
            self.postParams = [:]
         }

         self.headers = Dictionary(uniqueKeysWithValues: headers
            .map { ("\($0)", "\($1)") })
      }
   }

   public struct Response: Codable {
      public var statusCode: Int?
      public var data: Data?
      public var failureReason: String?

      /// - Parameters:
      ///   - statusCode: HTTP Status code.
      ///   - jsonString: Response as JSON string.
      ///   - failureReason: String representation of event failure.
      ///   It is valid to pass here error of response validation.
      ///   Pass `nil`for succeeded events.
      public init(statusCode: Int?, data: Data?, failureReason: String?) {
         self.statusCode = statusCode
         self.data = data
         self.failureReason = failureReason
      }
   }

   public let request: Request
   public let response: Response

   public init(request: Request, response: Response) {
      self.request = request
      self.response = response
   }
}

extension NetworkEvent.Response {

    @available(*, deprecated, message: "Use `data`")
    public var jsonString: String? { nil }
}

// MARK: - Convenience

private extension Dictionary where Key == String, Value == String {

   var queryString: String {

      let paramStr = self
         .map { "\($0)=\($1)" }
         .joined(separator: "&")

      return isEmpty ? "" : "?\(paramStr)"
   }
}
