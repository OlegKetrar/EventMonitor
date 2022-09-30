//
//  FilterModel.swift
//  Core
//
//  Created by Oleg Ketrar on 30.09.2022.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public final class FilterModel<Filter: Equatable> {
   public private(set) var applied: [Filter]

   public init(applied: [Filter]) {
      self.applied = applied
   }

   public func toggle(_ filter: Filter) {
      if applied.contains(filter) {
         applied.removeAll(where: { $0 == filter })
      } else {
         applied.append(filter)
      }
   }
}
