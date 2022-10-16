//
//  InfoPresentationController.swift
//  AM-Exercise
//
//  Created by Руслан Сабиров on 16/10/2022.
//  Copyright © 2022 Michael Mavris. All rights reserved.
//

import UIKit
class InfoPresentationController: UIPresentationController {
    private let backgroundView = UIView()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    private lazy var swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismiss))

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        backgroundView.isUserInteractionEnabled = true
        swipeGestureRecognizer.direction = .down
        presentedView?.addGestureRecognizer(swipeGestureRecognizer)
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect{
        return CGRect(
            origin: CGPoint(x: 0, y: (containerView!.frame.height/2) + 90),
            size: CGSize(
                width: containerView!.frame.width,
                height: containerView!.frame.height/2
            )
        )
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0
        }, completion: { [weak self] _ in
            self?.backgroundView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(backgroundView)
        presentedViewController.transitionCoordinator?.animate  { [weak self] _ in
            self?.backgroundView.alpha = 1
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView!.bounds
    }
    
    @objc func dismiss(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
