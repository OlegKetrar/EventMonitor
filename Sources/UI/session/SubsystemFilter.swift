//
//  SubsystemFilter.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 26.10.2021.
//  Copyright © 2021 Oleg Ketrar. All rights reserved.
//

struct SubsystemFilter {
   var title: String
   var isAll: Bool
   var isApplied: Bool
}

extension SubsystemFilter {

   init(subsystem: String, isApplied: Bool) {
      self.init(title: subsystem, isAll: false, isApplied: isApplied)
   }

   static var clear: SubsystemFilter {
      SubsystemFilter(
         title: "Clear filter",
         isAll: true,
         isApplied: false)
   }
}
