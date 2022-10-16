//
//  InfoPresentationController.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 16/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import UIKit
final class InfoPresentationController: UIPresentationController {
    private let backgroundView = UIView()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    
    private lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismiss))
        gesture.direction = .down
        return gesture
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView?.bounds ?? .zero
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(backgroundView)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        backgroundView.removeFromSuperview()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(
            origin: CGPoint(x: 0, y: containerView!.frame.height/2 + 90),
            size: CGSize(
                width: containerView!.frame.width,
                height: containerView!.frame.height/2 + 20)
        )
    }
    
    @objc func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
