//
//  FilterModelTests.swift
//  CoreTests
//
//  Created by Oleg Ketrar on 30.09.2022.
//

import XCTest
import MonitorCore

final class FilterModelTests: XCTestCase {

   func test_init_savesProvidedFilters() {
      let sut = makeSUT(["1"])

      XCTAssertEqual(sut.applied, ["1"])
   }

   func test_toggleExistingFilter_removesFilterFromApplied() {
      let sut = makeSUT(["1", "2"])
      sut.toggle("1")

      XCTAssertEqual(sut.applied, ["2"])
   }

   func test_toggleNewFilter_addsFilterToApplied() {
      let sut = makeSUT(["1", "2"])
      sut.toggle("3")

      XCTAssertEqual(sut.applied, ["1", "2", "3"])
   }

   private func makeSUT(_ filters: [String]) -> FilterModel<String> {
      FilterModel<String>(applied: filters)
   }
}
