//
//  SubsystemFilter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 26.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

public struct SubsystemFilter: Equatable {
   public var title: String
   public var isAll: Bool
   public var isApplied: Bool
}

extension SubsystemFilter {

   public init(subsystem: String, isApplied: Bool) {
      self.init(title: subsystem, isAll: false, isApplied: isApplied)
   }

   public static var clear: SubsystemFilter {
      SubsystemFilter(
         title: "Clear filters",
         isAll: true,
         isApplied: false)
   }
}
