//
//  FilterModel.swift
//  Core
//
//  Created by Oleg Ketrar on 30.09.2022.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public enum FilterOption<Parameter> {
   case clearAll
   case filter(parameter: Parameter, isApplied: Bool)
}

extension FilterOption: Equatable where Parameter: Equatable {}

public final class FilterModel<Parameter: Equatable> {
   public private(set) var applied: [Parameter]

   public init(applied: [Parameter]) {
      self.applied = applied
   }

   public func toggle(_ filter: Parameter) {
      if applied.contains(filter) {
         applied.removeAll(where: { $0 == filter })
      } else {
         applied.append(filter)
      }
   }

   public func clearAll() {
      applied = []
   }

   public func filter<Item>(
      items: [Item],
      by keyPath: KeyPath<Item, Parameter>
   ) -> [Item] {

      if applied.isEmpty {
         return items

      } else {
         return items.filter {
            let parameter = $0[keyPath: keyPath]

            return applied.contains(parameter)
         }
      }
   }
}

extension FilterModel where Parameter: Hashable {

   public func findOptions<Item>(
      in items: [Item],
      by keyPath: KeyPath<Item, Parameter>,
      sortedBy: (Parameter, Parameter) -> Bool
   ) -> [FilterOption<Parameter>] {

      let allParameters = items.map { $0[keyPath: keyPath] }
      let uniqueParameters = Array(Set(allParameters)).sorted(by: sortedBy)

      var options = uniqueParameters.map {
         FilterOption.filter(
            parameter: $0,
            isApplied: applied.contains($0))
      }

      guard options.count > 1 else {
         return []
      }

      if applied.isEmpty == false {
         options.append(.clearAll)
      }

      return options
   }
}
