//
//  NetworkEventDetailsVC.swift
//  EventMonitor
//
//  Created by Oleg Ketrar on 14.05.2019.
//  Copyright © 2019 Oleg Ketrar. All rights reserved.
//

import Foundation
import UIKit

public class NetworkEventDetailsVC: UIViewController, HavePreloaderButton {
   private let viewModel: NetworkEventViewModel
   private let menuConfiguration: MenuConfiguration?

   private var menuInteractionDelegate: MenuInteractionDelegate?

   public init(
      viewModel: NetworkEventViewModel,
      menuConfiguration: MenuConfiguration?
   ) {
      self.viewModel = viewModel
      self.menuConfiguration = menuConfiguration
      super.init(nibName: nil, bundle: nil)
   }

   required public init?(coder: NSCoder) {
      nil
   }

   // MARK: - Overrides

   override public func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      updateRightBarButton()
   }

   // MARK: - Action

   @objc func actionMenu() {

      switch menuConfiguration {

      case let .singleAction(_, action):
         navigationItem.rightBarButtonItem = configuredPreloaderBarButton()

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
         navigationItem.rightBarButtonItem = configuredPreloaderBarButton()
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

      let scrollView = UIScrollView(frame: .zero)
      scrollView.alwaysBounceVertical = true
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      let stackView = makeConfiguredStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false

      scrollView.addSubview(stackView)
      view.addSubview(scrollView)

      NSLayoutConstraint.activate([
         scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
         scrollView.topAnchor.constraint(equalTo: view.topAnchor),
         scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

         stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
         stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
         stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
      ])
   }

   func makeConfiguredStackView() -> UIStackView {

      let stackView = UIStackView(frame: .zero)
      stackView.spacing = 20
      stackView.axis = .vertical
      stackView.addArrangedSubview(makeInfoSection())

      if let paramsStr = viewModel.postParameters {
         stackView.addArrangedSubview(makeSection(
            title: "Parameters".uppercased(),
            content: paramsStr))
      }

      stackView.addArrangedSubview(makeSection(
         title: "Headers".uppercased(),
         content: viewModel.headers))

      stackView.addArrangedSubview(makeSection(
         title: "Response".uppercased(),
         content: viewModel.response,
         highlight: true))

      return stackView
   }

   func makeInfoSection() -> UIView {

      let sectionView = UIView(frame: .zero)
      sectionView.translatesAutoresizingMaskIntoConstraints = false

      let titleView = makeTitleView()

      let statusLabel = UILabel(frame: .zero)
      statusLabel.textColor = .grayPrimaryText
      statusLabel.font = .systemFont(ofSize: 18, weight: .semibold)
      statusLabel.text = viewModel.statusString
      statusLabel.numberOfLines = 0
      statusLabel.translatesAutoresizingMaskIntoConstraints = false

      sectionView.addSubview(titleView)
      sectionView.addSubview(statusLabel)

      NSLayoutConstraint.activate([
         titleView.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10),
         titleView.topAnchor.constraint(equalTo: sectionView.topAnchor),
         titleView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10),
         titleView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -20),

         statusLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10),
         statusLabel.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10),
         statusLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor)
      ])

      return sectionView
   }

   func makeTitleView() -> UIView {

      let containerView = UIView(frame: .zero)
      containerView.translatesAutoresizingMaskIntoConstraints = false

      let verbLabel = UILabel(frame: .zero)
      verbLabel.text = viewModel.requestVerb
      verbLabel.textColor = .white
      verbLabel.font = .systemFont(ofSize: 16, weight: .bold)
      verbLabel.translatesAutoresizingMaskIntoConstraints = false
      verbLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

      let verbContainer = UIView(frame: .zero)
      verbContainer.backgroundColor = viewModel.isFailed ? #colorLiteral(red: 0.9773717523, green: 0.2437902689, blue: 0.2448684871, alpha: 1) : #colorLiteral(red: 0.2871317863, green: 0.8010149598, blue: 0.5653145909, alpha: 1)
      verbContainer.layer.cornerRadius = 3
      verbContainer.layer.masksToBounds = true
      verbContainer.translatesAutoresizingMaskIntoConstraints = false

      let titleLabel = UILabel(frame: .zero)
      titleLabel.text = viewModel.titleString
      titleLabel.textColor = .grayPrimaryText
      titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
      titleLabel.lineBreakMode = .byWordWrapping
      titleLabel.numberOfLines = 0
      titleLabel.translatesAutoresizingMaskIntoConstraints = false

      verbContainer.addSubview(verbLabel)
      containerView.addSubview(verbContainer)
      containerView.addSubview(titleLabel)

      NSLayoutConstraint.activate([
         verbLabel.leftAnchor.constraint(equalTo: verbContainer.leftAnchor, constant: 10),
         verbLabel.topAnchor.constraint(equalTo: verbContainer.topAnchor, constant: 3),
         verbLabel.rightAnchor.constraint(equalTo: verbContainer.rightAnchor, constant: -10),
         verbLabel.bottomAnchor.constraint(equalTo: verbContainer.bottomAnchor, constant: -3),

         verbContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor),
         verbContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
         verbContainer.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10),
         verbContainer.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),

         titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
         titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
         titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
      ])

      return containerView
   }

   func makeSection(title: String, content: String, highlight: Bool = false) -> UIView {
      let sectionView = UIView(frame: .zero)

      let headerLabel = UILabel(frame: .zero)
      headerLabel.textColor = .grayPrimaryText
      headerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
      headerLabel.text = title
      headerLabel.numberOfLines = 0
      headerLabel.translatesAutoresizingMaskIntoConstraints = false

      let contentView = JsonCodeView(frame: .zero)
      contentView.setText(content, highlight: highlight)
      contentView.layer.cornerRadius = 5
      contentView.layer.masksToBounds = true

      contentView.translatesAutoresizingMaskIntoConstraints = false

      sectionView.addSubview(headerLabel)
      sectionView.addSubview(contentView)

      NSLayoutConstraint.activate([
         headerLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 30),
         headerLabel.topAnchor.constraint(equalTo: sectionView.topAnchor),
         headerLabel.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -20),
         headerLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -10),

         contentView.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10),
         contentView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10),
         contentView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor)
      ])

      return sectionView
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
