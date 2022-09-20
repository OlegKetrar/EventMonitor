//
//  UIKitFramework.swift
//
//
//  Created by Oleg Ketrar on 18.09.2022.
//

import Foundation
import UIKit

protocol UIKitFramework: ViewFramework where EventDetailView == UIKit.UIViewController {}

public struct UIKit_TableViewFramework: UIKitFramework {
   public typealias EventView = UITableViewCell
}

public struct UIKit_CollectionViewFramework: UIKitFramework {
   public typealias EventView = UICollectionViewCell
}
