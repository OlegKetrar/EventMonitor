//
//  JsonCodeViewTheme.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 30.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

struct JsonCodeViewTheme {
   var backgroundColor: UIColor
   var font: UIFont
   var textColor: UIColor
   var keyColor: UIColor
   var stringColor: UIColor
   var numberColor: UIColor
   var literalColor: UIColor
   var bracesColor: UIColor
   var delimiterColor: UIColor

   init(
      backgroundColor: UIColor,
      font: UIFont,
      textColor: UIColor,
      keyColor: UIColor? = nil,
      stringColor: UIColor? = nil,
      numberColor: UIColor? = nil,
      literalColor: UIColor? = nil,
      bracesColor: UIColor? = nil,
      delimiterColor: UIColor? = nil) {

      self.backgroundColor = backgroundColor
      self.font = font
      self.textColor = textColor
      self.keyColor = keyColor ?? textColor
      self.stringColor = stringColor ?? textColor
      self.numberColor = numberColor ?? textColor
      self.literalColor = literalColor ?? textColor
      self.bracesColor = bracesColor ?? textColor
      self.delimiterColor = delimiterColor ?? textColor
   }
}

extension JsonCodeViewTheme {

   static var postman: JsonCodeViewTheme {
      JsonCodeViewTheme(
         backgroundColor: #colorLiteral(red: 0.1568444967, green: 0.1568739712, blue: 0.156840831, alpha: 1),
         font: UIFont(name: "Menlo-Regular", size: 14)!,
         textColor: .white,
         keyColor: #colorLiteral(red: 0.6499369144, green: 0.8942017555, blue: 0, alpha: 1),
         stringColor: #colorLiteral(red: 0.9018524885, green: 0.8639326096, blue: 0.4221951067, alpha: 1),
         numberColor: #colorLiteral(red: 0.682919085, green: 0.4891806841, blue: 1, alpha: 1),
         literalColor: #colorLiteral(red: 0.682919085, green: 0.4891806841, blue: 1, alpha: 1))
   }
}
