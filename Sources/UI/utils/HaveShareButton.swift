//
//  HaveShareButton.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 22.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

/// Provides share button as UIBarButtonItem.
@objc protocol HaveShareButton: AnyObject {
    @objc func actionShare()
}

extension HaveShareButton {

    func configuredShareButton() -> UIBarButtonItem {
       return UIBarButtonItem(
          barButtonSystemItem: .action,
          target: self,
          action: #selector(actionShare))
    }
}
