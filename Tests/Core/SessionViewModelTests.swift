//
//  SessionViewModelTests.swift
//  
//
//  Created by Oleg Ketrar on 30.09.2022.
//

import XCTest
@testable import MonitorCore

final class SessionViewModelTests: XCTestCase {

   func test_toggleFilter_whenAppliedEmpty_addsFilter() {
      let sut = makeSUT(applied: [], events: ["1", "2"])
      sut.toggleFilter("1")

      XCTAssertEqual(sut.events, ["1"])
      XCTAssertEqual(sut.filters.count, 3)

      XCTAssertEqual(
         sut.filters[0],
         SubsystemFilter(subsystem: "1", isApplied: true))

      XCTAssertEqual(
         sut.filters[1],
         SubsystemFilter(subsystem: "2", isApplied: false))

      XCTAssertEqual(sut.filters[2], .clear)
   }

   func test_toggleAppliedFilter_removesFilter() {
      let sut = makeSUT(applied: ["1"], events: ["1", "2"])
      sut.toggleFilter("1")

      XCTAssertEqual(sut.events, ["1", "2"])
      XCTAssertEqual(sut.filters.count, 2)

      XCTAssertEqual(
         sut.filters[0],
         SubsystemFilter(subsystem: "1", isApplied: false))

      XCTAssertEqual(
         sut.filters[1],
         SubsystemFilter(subsystem: "2", isApplied: false))
   }

   func test_toggleIsAllFitler_whenAppliedNonEmpty_removesAllFiltersAndIsAllOption() {
      let sut = makeSUT(applied: ["1"], events: ["1", "2"])
      sut.clearFilters()

      XCTAssertEqual(sut.events, ["1", "2"])
      XCTAssertEqual(sut.filters.count, 2)

      XCTAssertEqual(
         sut.filters[0],
         SubsystemFilter(subsystem: "1", isApplied: false))

      XCTAssertEqual(
         sut.filters[1],
         SubsystemFilter(subsystem: "2", isApplied: false))
   }

   private func makeSUT(applied: [String], events: [String]) -> SessionViewModel {

      let session = EventSession(
         identifier: SessionIdentifier(),
         isActive: false,
         events: events.map {
            AnyEvent(TestEvent(), subsystem: $0)
         })

      let sut = SessionViewModel(
         session: Observable(session),
         filtering: FilterModel(applied: applied))

      return sut
   }
}

private extension SessionViewModel {

   var filters: [SubsystemFilter] {
      state.value.filters
   }

   var events: [String] {
      state.value.events.map(\.subsystem)
   }

   func toggleFilter(_ subsystem: String) {
      toggleFilter(SubsystemFilter(subsystem: subsystem, isApplied: false))
   }

   func clearFilters() {
      toggleFilter(SubsystemFilter(title: "", isAll: true, isApplied: false))
   }
}

private struct TestEvent: Codable, Event {}
