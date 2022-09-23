//
//  NetworkEventCell.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI

public class NetworkEventCell: UITableViewCell {

   private struct K {
      static let successPrimaryColor = #colorLiteral(red: 0.2871317863, green: 0.8010149598, blue: 0.5653145909, alpha: 1)
      static let successSecondaryColor = #colorLiteral(red: 0.929186523, green: 0.9811120629, blue: 0.9562771916, alpha: 1)
      static let failurePrimaryColor = #colorLiteral(red: 0.9773717523, green: 0.2437902689, blue: 0.2448684871, alpha: 1)
      static let failureSecondaryColor = #colorLiteral(red: 0.9961538911, green: 0.9251114726, blue: 0.928586185, alpha: 1)
   }

   private let verbLabel = UILabel(frame: .zero).with {
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      $0.translatesAutoresizingMaskIntoConstraints = false
   }

   private let verbContainer = UIView(frame: .zero).with {
      $0.layer.cornerRadius = 3
      $0.layer.masksToBounds = true
      $0.translatesAutoresizingMaskIntoConstraints = false
   }

   private let titleLabel = UILabel(frame: .zero).with {
      $0.textColor = UIColor.grayPrimaryText
      $0.font = .systemFont(ofSize: 16, weight: .semibold)
      $0.lineBreakMode = .byWordWrapping
      $0.numberOfLines = 0
      $0.translatesAutoresizingMaskIntoConstraints = false
   }

   // MARK: - Interface

   override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      configureUI()
   }

   required public init?(coder aDecoder: NSCoder) {
      nil
   }

   @discardableResult
   public func with(verb: String) -> Self {
      verbLabel.text = verb
      return self
   }

   @discardableResult
   public func with(request: String) -> Self {
      titleLabel.text = request
      return self
   }

   @discardableResult
   public func with(success: Bool) -> Self {
      verbContainer.backgroundColor = success ? K.successPrimaryColor : K.failurePrimaryColor
      backgroundColor = success ? K.successSecondaryColor : K.failureSecondaryColor

      return self
   }
}

// MARK: - Private

private extension NetworkEventCell {

   func configureUI() {
      selectionStyle = .none
      accessoryType = .disclosureIndicator
      contentView.backgroundColor = .clear

      verbContainer.addSubview(verbLabel)
      contentView.addSubview(verbContainer)
      contentView.addSubview(titleLabel)

      verbLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

      NSLayoutConstraint.activate([
         verbLabel.leftAnchor.constraint(equalTo: verbContainer.leftAnchor, constant: 10),
         verbLabel.topAnchor.constraint(equalTo: verbContainer.topAnchor, constant: 3),
         verbLabel.rightAnchor.constraint(equalTo: verbContainer.rightAnchor, constant: -10),
         verbLabel.bottomAnchor.constraint(equalTo: verbContainer.bottomAnchor, constant: -3),

         verbContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
         verbContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
         verbContainer.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -13),
         verbContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

         titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
         titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
         titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
      ])
   }
}

protocol HasWith: AnyObject {}

extension HasWith {

   func with(_ closure: (Self) throws -> Void) rethrows -> Self {
      try closure(self)
      return self
   }
}

extension UIView: HasWith {}
