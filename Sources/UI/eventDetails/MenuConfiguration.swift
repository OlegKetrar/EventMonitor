//
//  MenuConfiguration.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//

import Foundation
import UIKit

public enum MenuConfiguration {
   case singleAction(icon: UIImage, action: () async throws -> Void)
   case menu(popover: () -> UIViewController)
}
