//
//  Collection+elementAtIndex.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

extension Collection where Index == Int {

   func element(at index: Int) -> Element? {
      if self.indices.contains(index) {
         return self[index]
      } else {
         return nil
      }
   }
}
