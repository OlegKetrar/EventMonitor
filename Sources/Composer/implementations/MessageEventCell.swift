//
//  MessageEventCell.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 23.09.2022.
//  Copyright © 2022 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI

final class MessageEventCell: UITableViewCell {

   private let titleLabel = UILabel().with {
      $0.font = .systemFont(ofSize: 14, weight: .regular)
      $0.textColor = .grayPrimaryText
      $0.numberOfLines = 0
   }

   override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      configureUI()
   }

   required public init?(coder aDecoder: NSCoder) {
      nil
   }

   @discardableResult
   public func with(text: String) -> Self {
      titleLabel.text = text
      return self
   }
}

// MARK: - Private

private extension MessageEventCell {

   func configureUI() {
      selectionStyle = .none
      accessoryType = .disclosureIndicator
      contentView.backgroundColor = .clear
      backgroundColor = .clear

      contentView.addSubview(titleLabel)
      titleLabel.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
         titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
         titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
         titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
         titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
      ])
   }
}
