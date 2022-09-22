//
//  Observable.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Dispatch

public final class Observable<Value> {
   public private(set) var value: Value
   private var observers: [(Value) -> Void] = []

   public init(_ value: Value) {
      self.value = value
   }

   public func mutate(_ mutation: (inout Value) -> Void) {
      mutation(&value)
      observers.forEach { $0(value) }
   }

   @discardableResult
   public func notify(
      on queue: DispatchQueue? = nil,
      _ callback: @escaping (Value) -> Void) -> Self {

      if let queue = queue {
         observers.append({ value in
            queue.async { callback(value) }
         })
      } else {
         observers.append(callback)
      }

      return self
   }

   @discardableResult
   public func notify<Observer: AnyObject>(
      observer: Observer,
      on queue: DispatchQueue? = nil,
      callback: @escaping (Observer, Value) -> Void) -> Self {

      let wrappedCallback: (Value) -> Void = { [weak observer] newValue in
         if let strongObserver = observer {
            callback(strongObserver, newValue)
         }
      }

      if let queue = queue {
         observers.append({ value in
            queue.async { wrappedCallback(value) }
         })
      } else {
         observers.append(wrappedCallback)
      }

      return self
   }
}
