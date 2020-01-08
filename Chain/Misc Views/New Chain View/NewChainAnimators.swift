//
//  NewChainAnimators.swift
//  Chain
//
//  Created by Christian Burke on 1/6/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//
import UIKit
import Foundation

extension NewChainViewController{

    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        //print(swipeHeightConstraint.constant)
        if swipeHeightConstraint.hasExceeded(verticalLimit: submitLimit){
            swipeableView.isUserInteractionEnabled = false
            animateSubmission()
            return
        }
        if (swipeHeightConstraint.hasExceeded(verticalLimit: verticalLimit)){
            totalTranslation -= yTranslation
            swipeHeightConstraint.constant = logConstraintValueForYPosition(yPosition: totalTranslation)
            isPullingUp(position: swipeHeightConstraint.constant)
            if(sender.state == UIGestureRecognizer.State.ended ){
                animateViewBackToLimit()
            }
        }
        else if (swipeHeightConstraint.hasPreceeded(verticalLimit: verticalLimit - 1)){
            totalTranslation += yTranslation
            swipeHeightConstraint.constant = logConstraintValueForYPositionNeg(yPosition: totalTranslation)
            isPullingUp(position: swipeHeightConstraint.constant)
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
        swipeableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func swipeDidMove(position: CGFloat){
        let posPercent = abs((position) / colorSensitivity) //will = 1 when its in the original position. will max out at 200 in both directions
        let hueVal = h  * posPercent
        view.backgroundColor = UIColor(hue: hueVal, saturation: s, brightness: b, alpha: 1.0)
    }
    
    func isPullingUp(position: CGFloat){

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
