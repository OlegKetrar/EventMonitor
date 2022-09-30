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
      let sut = makeSUT([1])

      XCTAssertEqual(sut.applied, [1])
   }

   // MARK: -

   func test_toggleExistingFilter_removesFilterFromApplied() {
      let sut = makeSUT([1, 2])
      sut.toggle(1)

      XCTAssertEqual(sut.applied, [2])
   }

   func test_toggleNewFilter_addsFilterToApplied() {
      let sut = makeSUT([1, 2])
      sut.toggle(3)

      XCTAssertEqual(sut.applied, [1, 2, 3])
   }

   func test_clearAll_removesAllAppliedFilters() {
      let sut = makeSUT([1, 2, 3])
      sut.clearAll()

      XCTAssertEqual(sut.applied, [])
   }

   // MARK: -

   func test_filterEmptyItems_noFilters_returnsEmpty() {
      let sut = makeSUT([])
      let new = sut.filter(items: [], by: \.self)

      XCTAssertEqual(new, [])
   }

   func test_filterItems_noFilters_returnsSameItems() {
      let sut = makeSUT([])
      let new = sut.filter(items: [1, 1, 2], by: \.self)

      XCTAssertEqual(new, [1, 1, 2])
   }

   func test_filterItems_oneFilters_returnsFiltered() {
      let sut = makeSUT([1])
      let new = sut.filter(items: [1, 1, 2], by: \.self)

      XCTAssertEqual(new, [1, 1])
   }

   func test_filterItems_twoFilters_returnsFiltered() {
      let sut = makeSUT([1, 3])
      let new = sut.filter(items: [1, 2, 3, 2], by: \.self)

      XCTAssertEqual(new, [1, 3])
   }

   // MARK: -

   func test_findOptions_inEmptyItems_returnsEmpty() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [], by: \.self, sortedBy: >)

      XCTAssertEqual(options, [])
   }

   func test_findOptions_noFilters_returnsAllUnapplied() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [1, 2, 3], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [
         .filter(parameter: 1, isApplied: false),
         .filter(parameter: 2, isApplied: false),
         .filter(parameter: 3, isApplied: false),
      ])
   }

   func test_findOptions_allFiltersApplied_returnsAllAppliedAndClearAllOption() {
      let sut = makeSUT([1, 2, 3])
      let options = sut.findOptions(in: [1, 2, 3, 3], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [
         .filter(parameter: 1, isApplied: true),
         .filter(parameter: 2, isApplied: true),
         .filter(parameter: 3, isApplied: true),
         .clearAll
      ])
   }

   func test_findOptions_calculatesAppliedFiltersAndAddsClearAll() {
      let sut = makeSUT([1])
      let options = sut.findOptions(in: [1, 2, 3], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [
         .filter(parameter: 1, isApplied: true),
         .filter(parameter: 2, isApplied: false),
         .filter(parameter: 3, isApplied: false),
         .clearAll
      ])
   }

   func test_findOptions_onePossibleOptions_returnsEmpty() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [1, 1, 1], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [])
   }

   func test_findOptions_removesDuplicates() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [1, 2, 2, 2], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [
         .filter(parameter: 1, isApplied: false),
         .filter(parameter: 2, isApplied: false),
      ])
   }

   func test_findOptions_sortsAscending() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [1, 2, 3], by: \.self, sortedBy: <)

      XCTAssertEqual(options, [
         .filter(parameter: 1, isApplied: false),
         .filter(parameter: 2, isApplied: false),
         .filter(parameter: 3, isApplied: false),
      ])
   }

   func test_findOptions_sortsDescending() {
      let sut = makeSUT([])
      let options = sut.findOptions(in: [1, 2, 3], by: \.self, sortedBy: >)

      XCTAssertEqual(options, [
         .filter(parameter: 3, isApplied: false),
         .filter(parameter: 2, isApplied: false),
         .filter(parameter: 1, isApplied: false),
      ])
   }

   // MARK: -

   private func makeSUT(_ filters: [Int]) -> FilterModel<Int> {
      FilterModel<Int>(applied: filters)
   }
}
