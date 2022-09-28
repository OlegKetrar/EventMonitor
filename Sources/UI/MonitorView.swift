//
//  MonitorView.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 20.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public protocol MonitorView {
   func push(into nc: UINavigationController?)
   func present(over vc: UIViewController?)
   func presentActiveSession(over vc: UIViewController?)
}
