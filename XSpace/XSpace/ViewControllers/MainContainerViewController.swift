//
//  MainContainerViewController.swift
//  XSpace
//
//  Created by Igor Malasevschi on 20.06.2025.
//  Copyright © 2025 XSpace. All rights reserved.

import UIKit

class MainContainerViewController: UIViewController {

    private let mainViewController: UIViewController
    private let menuViewController = LeftMenuViewController() // renamed
    private let dimmingView = UIView()
    private var isMenuVisible = false

    private let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.6

    init(mainViewController: UIViewController) {
        self.mainViewController = mainViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Main content
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)

        // Dimming overlay
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0
        dimmingView.frame = view.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        dimmingView.addGestureRecognizer(tap)
        view.addSubview(dimmingView)

        // Left menu setup
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)

        menuViewController.view.frame = CGRect(
            x: -menuWidth,
            y: 0,
            width: menuWidth,
            height: view.bounds.height
        )
    }

    @objc func toggleMenu() {
        let targetX = isMenuVisible ? -menuWidth : 0
        let dimmingAlpha: CGFloat = isMenuVisible ? 0 : 1

        UIView.animate(withDuration: 0.3, animations: {
            self.menuViewController.view.frame.origin.x = targetX
            self.dimmingView.alpha = dimmingAlpha
        })

        isMenuVisible.toggle()
    }
}
