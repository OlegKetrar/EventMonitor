//
//  NetworkEventDetailsVC.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit
import MonitorUI

final class NetworkEventDetailsVC: UIViewController, HavePreloaderButton {
   private let viewModel: NetworkEventViewModel
   private let menuConfiguration: MenuConfiguration?
   private var viewState: NetworkEventViewState { viewModel.viewState }

   private var menuInteractionDelegate: MenuInteractionDelegate?

   init(
      viewModel: NetworkEventViewModel,
      menuConfiguration: MenuConfiguration?
   ) {
      self.viewModel = viewModel
      self.menuConfiguration = menuConfiguration
      super.init(nibName: nil, bundle: nil)
   }

   required init?(coder: NSCoder) {
      nil
   }

   // MARK: - Overrides

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      updateRightBarButton()
   }

   // MARK: - Action

   @objc func actionMenu() {

      switch menuConfiguration {

      case let .singleAction(_, action):
         navigationItem.rightBarButtonItem = makePreloaderBarButton()

         Task { [weak self] in
            try await action()

            await MainActor.run {
               self?.updateRightBarButton()
            }
         }

      case .menu:
         break

      case .none:
         break
      }
   }
}

// MARK: - Private

private extension NetworkEventDetailsVC {

   func setRightBarButtonLoading(_ loading: Bool) {
      if loading {
         navigationItem.rightBarButtonItem = makePreloaderBarButton()
      } else {
         updateRightBarButton()
      }
   }

   func updateRightBarButton() {
      switch menuConfiguration {
      case let .singleAction(icon, _):
         navigationItem.rightBarButtonItem = makeActionBarButton(image: icon)

      case let .menu(makeMenu):
         navigationItem.rightBarButtonItem = makeMenuBarButton(make: makeMenu)

      case .none:
         navigationItem.rightBarButtonItem = nil
      }
   }

   func makeMenuBarButton(
      make: @escaping (@escaping MenuConfiguration.SetLoadingVisible) -> UIMenu
   ) -> UIBarButtonItem {

      let button = UIButton(type: .system)
      button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)

      let menuFactory = { [weak self] in
         make({ self?.setRightBarButtonLoading($0) })
      }

      if #available(iOS 14, *) {
         button.showsMenuAsPrimaryAction = true
         button.menu = menuFactory()

      } else {
         let interactionDelegate = MenuInteractionDelegate(menuFactory: menuFactory)
         menuInteractionDelegate = interactionDelegate

         button.addInteraction(UIContextMenuInteraction(delegate: interactionDelegate))

         // fixing darkMode artifacts
         button.tintColor = .systemBlue
         button.clipsToBounds = true
         button.layer.cornerRadius = 8
         button.backgroundColor = .white
      }

      return UIBarButtonItem(customView: button)
   }

   func makeActionBarButton(image: UIImage) -> UIBarButtonItem {
      UIBarButtonItem(
         image: image,
         style: .plain,
         target: self,
         action: #selector(actionMenu))
   }

   func configureUI() {
      view.backgroundColor = .grayBackground
      disableBackButtonContextMenu(self)

      let scrollView = UIScrollView()
      scrollView.alwaysBounceVertical = true

      let stackView = makeConfiguredStackView()

      scrollView.addSubview(stackView)
      view.addSubview(scrollView)

      stackView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
         scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
         scrollView.topAnchor.constraint(equalTo: view.topAnchor),
         scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

         stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10),
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
         stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10),
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
         stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
      ])
   }

   func makeConfiguredStackView() -> UIStackView {

      let stackView = UIStackView(frame: .zero)
      stackView.spacing = 20
      stackView.axis = .vertical
      stackView.addArrangedSubview(makeInfoSection())

      viewState.codeBlocks.forEach {
         stackView.addArrangedSubview(makeCodeSection($0))
      }

      return stackView
   }

   func makeInfoSection() -> UIView {
      UIStackView().with {
         $0.axis = .vertical
         $0.spacing = 20
         $0.addArrangedSubview(makeTitleView())

         if let failureMsg = viewState.failureReason {
            $0.addArrangedSubview(UILabel().with {
               $0.text = failureMsg
               $0.textColor = .grayPrimaryText
               $0.font = .systemFont(ofSize: 18, weight: .semibold)
               $0.numberOfLines = 0
            })
         }
      }
   }

   func makeTitleView() -> UIView {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = 10

      let verb = UILabel().with {
         $0.text = viewState.verb
         $0.textColor = .white
         $0.font = .systemFont(ofSize: 16, weight: .bold)
         $0.setContentCompressionResistancePriority(.required, for: .horizontal)
         $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      }

      let verbView = UIView().with {
         $0.backgroundColor = viewState.isFailed ? #colorLiteral(red: 0.9773717523, green: 0.2437902689, blue: 0.2448684871, alpha: 1) : #colorLiteral(red: 0.2871317863, green: 0.8010149598, blue: 0.5653145909, alpha: 1)
         $0.layer.cornerRadius = 3
         $0.layer.masksToBounds = true
      }

      verbView.addSubview(verb)
      verb.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
         verb.leftAnchor.constraint(equalTo: verbView.leftAnchor, constant: 10),
         verb.topAnchor.constraint(equalTo: verbView.topAnchor, constant: 3),
         verb.rightAnchor.constraint(equalTo: verbView.rightAnchor, constant: -10),
         verb.bottomAnchor.constraint(equalTo: verbView.bottomAnchor, constant: -3)
      ])

      stack.addArrangedSubview(UIStackView().with {
         $0.axis = .horizontal
         $0.spacing = 20
         $0.addArrangedSubview(verbView)

         $0.addArrangedSubview(UILabel().with {
            $0.text = viewState.method
            $0.textColor = .grayPrimaryText
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
         })
      })

      viewState.query.map { requestQuery in
         let query = UILabel().with {
            $0.attributedText = requestQuery
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping

            if #available(iOS 14.0, *) {
               $0.lineBreakStrategy = []
            }
         }

         stack.addArrangedSubview(UIView().with {
            $0.addSubview(query)
            query.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
               query.topAnchor.constraint(equalTo: $0.topAnchor),
               query.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: 20),
               query.rightAnchor.constraint(equalTo: $0.rightAnchor, constant: -20),
               query.bottomAnchor.constraint(equalTo: $0.bottomAnchor),
            ])
         })
      }

      stack.addArrangedSubview(beforeSpacing: 20, UIStackView().with {
         $0.axis = .horizontal
         $0.spacing = 20

         $0.addArrangedSubview(UILabel().with {
            $0.text = viewState.status
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.numberOfLines = 0
         })

         $0.addArrangedSubview(UILabel().with {
            $0.text = viewState.basepoint
            $0.textColor = .gray
            $0.textAlignment = .right
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.numberOfLines = 1
         })
      })

      return stack
   }

   func makeCodeSection(_ content: NetworkEventViewState.CodeContent) -> UIView {
      let sectionView = UIView()

      let headerLabel = UILabel()
      headerLabel.textColor = .grayPrimaryText
      headerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
      headerLabel.text = content.title
      headerLabel.numberOfLines = 0

      let contentView = CodeView()
      contentView.ctxMenuProvider = content.menuProvider
      contentView.setText(content.text)
      contentView.backgroundColor = content.backgroundColor
      contentView.layer.cornerRadius = 5
      contentView.layer.masksToBounds = true

      sectionView.addSubview(headerLabel)
      sectionView.addSubview(contentView)

      headerLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
         headerLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 20),
         headerLabel.topAnchor.constraint(equalTo: sectionView.topAnchor),
         headerLabel.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10),
         headerLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -10),

         contentView.leftAnchor.constraint(equalTo: sectionView.leftAnchor),
         contentView.rightAnchor.constraint(equalTo: sectionView.rightAnchor),
         contentView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor)
      ])

      return sectionView
   }
}

extension UIStackView {

   func addArrangedSubview(beforeSpacing: CGFloat, _ subview: UIView) {
      let lastSubview = arrangedSubviews.last

      addArrangedSubview(subview)

      if let lastSubview {
         setCustomSpacing(beforeSpacing, after: lastSubview)
      }
   }
}

private class MenuInteractionDelegate: NSObject, UIContextMenuInteractionDelegate {
   private let menuFactory: () -> UIMenu

   init(menuFactory: @escaping () -> UIMenu) {
      self.menuFactory = menuFactory
      super.init()
   }

   func contextMenuInteraction(
      _ interaction: UIContextMenuInteraction,
      configurationForMenuAtLocation location: CGPoint
   ) -> UIContextMenuConfiguration? {

      UIContextMenuConfiguration(
         identifier: nil,
         previewProvider: nil,
         actionProvider: { [weak self] _ in
            self?.menuFactory()
         })
   }
}
