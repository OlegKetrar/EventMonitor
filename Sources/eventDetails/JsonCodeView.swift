//
//  JsonCodeView.swift
//  NetworkMonitor
//
//  Created by Oleg Ketrar on 15.09.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

final class JsonCodeView: UIView {

    private let contentLabel = UITextView(frame: .zero).with {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.isSelectable = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultConfiguring()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultConfiguring()
    }

    func setTextColor(_ color: UIColor) {
        contentLabel.textColor = color
    }

    func setText(_ text: String, highlight: Bool = false) {
        contentLabel.attributedText = highlightJson(text, highlight: highlight)
    }
}

// MARK: - Private

private extension JsonCodeView {

    func highlightJson(
        _ json: String,
        highlight: Bool) -> NSAttributedString {

        let attributed = NSMutableAttributedString(string: json, attributes: [
            .foregroundColor : #colorLiteral(red: 0.6499369144, green: 0.8942017555, blue: 0, alpha: 1),
            .font : UIFont(name: "Menlo-Regular", size: 14) as Any,
            .kern : NSNumber.init(value: 0.1)
        ])

        guard highlight else { return attributed }

        // square & curly brackets
        attributed.stylize(pattern: "[{}]+", with: [
            .font : UIFont(name: "Menlo-Bold", size: 15) as Any
        ])

        return attributed
    }

    func defaultConfiguring() {

        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .clear
        scrollView.indicatorStyle = .white
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentLabel)
        addSubview(scrollView)
        backgroundColor = #colorLiteral(red: 0.1568444967, green: 0.1568739712, blue: 0.156840831, alpha: 1)

        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}

// MARK: - Convenience

private extension NSMutableAttributedString {

    func stylize(
        pattern: String,
        with attributes: [NSAttributedString.Key : Any]) {

        guard let regex = try? NSRegularExpression(
            pattern: pattern,
            options: .caseInsensitive) else { return }

        let matches = regex.matches(
            in: self.string,
            options: [],
            range: NSRange(
                location: 0,
                length: (self.string as NSString).length))

        for match in matches {
            self.addAttributes(attributes, range: match.range)
        }
    }
}
