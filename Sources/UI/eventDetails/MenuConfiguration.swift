//
//  MenuConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//

import Foundation
import UIKit

public enum MenuConfiguration {
   public typealias ActivityIndicatorController = (Bool) -> Void

   case singleAction(icon: UIImage, action: () async throws -> Void)
   case menu((@escaping ActivityIndicatorController) -> UIMenu)
}
