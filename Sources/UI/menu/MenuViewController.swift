//
//  MenuViewController.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 24.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

final class MenuViewController: UIViewController {


}

final class MenuCell: UITableViewCell {

   private let titleLabel = UILabel().with { _ in

   }

   private let iconView = UIImageView().with { _ in

   }

   override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      configureUI()
   }

   required public init?(coder aDecoder: NSCoder) {
      nil
   }

   @discardableResult
   func with(title: String, icon: UIImage) -> Self {
      titleLabel.text = title
      iconView.image = icon
      return self
   }

   func setActivityIndicatorHidden(_ isHidden: Bool) {

   }

   private func configureUI() {
//      view

   }
}
