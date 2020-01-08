//
//  NewChainAnimators.swift
//  Chain
//
//  Created by Christian Burke on 1/6/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//
import UIKit
import Foundation
import Lottie

extension NewChainViewController{

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        //print(swipeHeightConstraint.constant)
        if swipeHeightConstraint.hasExceeded(verticalLimit: submitLimit){
            swipeableView.isUserInteractionEnabled = false
            animateSubmission()
            willPostChain()
            return
        }
        if (swipeHeightConstraint.hasExceeded(verticalLimit: verticalLimit)){
            totalTranslation -= yTranslation
            swipeHeightConstraint.constant = logConstraintValueForYPosition(yPosition: totalTranslation)
            if(sender.state == UIGestureRecognizer.State.ended ){
                animateViewBackToLimit()
            }
        }
        else if (swipeHeightConstraint.hasPreceeded(verticalLimit: verticalLimit - 1)){
            totalTranslation += yTranslation
            swipeHeightConstraint.constant = logConstraintValueForYPositionNeg(yPosition: totalTranslation)
            if(sender.state == UIGestureRecognizer.State.ended ){
                animateViewBackToLimit()
            }
        }else {
            swipeHeightConstraint.constant -= yTranslation
        }
        swipeDidMove(position: swipeHeightConstraint.constant - (verticalLimit - colorSensitivity))
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func logConstraintValueForYPosition(yPosition : CGFloat) -> CGFloat {
        return verticalLimit * (1 + log10(yPosition/verticalLimit))
    }
    
    func logConstraintValueForYPositionNeg(yPosition : CGFloat) -> CGFloat {
        let originalPos = logConstraintValueForYPosition(yPosition: yPosition)
        return  (originalPos * -1) + (2 * verticalLimit)
    }
    
    func animateViewBackToLimit() {
        self.swipeHeightConstraint.constant = constraintHeight
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = self.verticalLimit
            
            }, completion: nil)
    }
    
    func animateSubmission(){
        self.swipeHeightConstraint.constant = UIScreen.main.bounds.height * 1.1
                
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    func animateCancel(){
        self.swipeHeightConstraint.constant = verticalLimit
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 8, options: UIView.AnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.totalTranslation = self.verticalLimit
            
            }, completion: nil)
    }
    
    func swipeDidMove(position: CGFloat){
        let posPercent = abs((position) / colorSensitivity)
        let hueVal = h  * posPercent
        view.backgroundColor = UIColor(hue: hueVal, saturation: s, brightness: b, alpha: 1.0)
        bottomLabel.textColor = UIColor.darkGray.withAlphaComponent(posPercent)
    }
    
    func setupUI(){
        backgroundColor = view.backgroundColor!
        if backgroundColor.getHue(&h, saturation: &s, brightness: &b, alpha: nil) {
            
        } else {
            print("Failed with color space")
        }
        swipeableView.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 5)
        swipeableView.addObserver(self, forKeyPath:"frame", options:.new, context:nil)

        constraintHeight = swipeHeightConstraint.constant
        verticalLimit = constraintHeight
        totalTranslation = constraintHeight

        imageHolderView.addShadow()
        
        let panGestureRecognizer = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        swipeableView.addGestureRecognizer(panGestureRecognizer)
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainImageTapped(sender:))))
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        let topPadding = window?.safeAreaInsets.top ?? 0.0
        print(bottomPadding, topPadding)
        let btnSpace = view.frame.height - (verticalLimit + 180 + bottomPadding + topPadding)
        print(btnSpace)
        backButtonHeight.constant = btnSpace
    }
 
    //MARK: Lottie Animators (custom after effects animations) -
    @objc func animationCallback() {
      if animationView.isAnimationPlaying {
        //Can be used for something
      }
    }
    
    func setupAnimatorView(){
        let animation = Animation.named("uglyChain")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animatorHolder.addSubview(animationView)
        //view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: animatorHolder.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: animatorHolder.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        animatorHolder.backgroundColor = UIColor.clear

        displayLink = CADisplayLink(target: self, selector: #selector(animationCallback))
        displayLink?.add(to: .current, forMode: RunLoop.Mode.default)
    }
    
}



private extension NSLayoutConstraint {
    func hasExceeded(verticalLimit: CGFloat) -> Bool {
        return self.constant > verticalLimit
    }
    
    func hasPreceeded(verticalLimit: CGFloat) -> Bool {
        return self.constant < verticalLimit
    }
}
