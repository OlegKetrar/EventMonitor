//
//  MonitorView.swift
//  
//
//  Created by Oleg Ketrar on 20.09.2022.
//

import Foundation
import UIKit

public protocol MonitorView {
   func push(into nc: UINavigationController?)
   func present(over vc: UIViewController?)
   func presentActiveSession(over vc: UIViewController?)
}
