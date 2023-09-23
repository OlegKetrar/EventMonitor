//
//  JsonSyntaxTests.swift
//  JsonSyntaxTests
//
//  Created by Oleg Ketrar on 04.11.2022.
//

import XCTest
import JsonSyntax

final class JsonSyntaxTests: XCTestCase {

   func test_parsingTopLevelObject_literals() throws {
      XCTAssertEqual(try makeSUT("true"), .literal(.len(4), .true))
      XCTAssertEqual(try makeSUT("false"), .literal(.len(5), .false))
      XCTAssertEqual(try makeSUT("null"), .literal(.len(4), .null))
   }

   func test_parsingTopLevelObject_numberInteger() throws {
      XCTAssertEqual(try makeSUT("1234567"), .number(.len(7)))
      XCTAssertEqual(try makeSUT("-4424325555"), .number(.len(11)))
   }

   func test_parsingTopLevelObject_numberDouble() throws {
      XCTAssertEqual(try makeSUT("3573444.66"), .number(.len(10)))
      XCTAssertEqual(try makeSUT("-3573444.66"), .number(.len(11)))

      XCTAssertEqual(try makeSUT("0.003573"), .number(.len(8)))
      XCTAssertEqual(try makeSUT("-0.003573"), .number(.len(9)))
   }
}

extension JsonSyntaxTests {

   func makeSUT(_ json: String) throws -> ParseTree {
      try JsonSyntax().parse(json.data(using: .utf8) ?? Data())
   }
}

extension Pos {

   static func len(_ len: Int) -> Pos {
      Pos(location: 0, length: len)
   }
}
