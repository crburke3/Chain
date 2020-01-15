//
//  ChainBreakLoader.swift
//  Chain
//
//  Created by Christian Burke on 1/14/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import Foundation
import CRRefresh
import Lottie


class ChainBreakLoader: CRRefreshProtocol{

    
    var view: UIView
    var insets: UIEdgeInsets
    var trigger: CGFloat
    var execute: CGFloat
    var endDelay: CGFloat
    var hold: CGFloat
    
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var animatorView = AnimationView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    let label = UILabel()
    
    init() {
        mainView.backgroundColor = UIColor.clear
        animatorView.backgroundColor = UIColor.clear
        if let animation = Animation.named("ChainBreak"){
            mainView.addSubview(animatorView)
            mainView.addSubview(label)
            
            animatorView.animation = animation
            animatorView.contentMode = .scaleAspectFit
            animatorView.translatesAutoresizingMaskIntoConstraints = false
            animatorView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            animatorView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            animatorView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            animatorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            label.textAlignment = .center
            label.textColor = .lightGray
            label.text = "break chain to refresh"
            label.font = .systemFont(ofSize: 10)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -4).isActive = true
            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 200).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }else{
            print("Couldnt find animation")
        }
        
        view = mainView
        insets = .zero
        trigger = 70.0 //When it starts the refresh
        execute = 70.0  //When it starts to animate?
        endDelay = 0.0 //keeps animation running for a certain amt of time
        hold = 60  //space at the top of the tableview
    }
    
    func refreshBegin(view: CRRefreshComponent) {
        print("refresh begin")
        animatorView.play(fromProgress: 0.0, toProgress: 0.9, loopMode: LottieLoopMode.autoReverse)
    }
    
    func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        //print("refresh end")
        //animatorView.play(fromProgress: animatorView.currentProgress, toProgress: 0)
    }
    
    func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        var prog = (progress - 0.7) //Will start at 0.7, and extends the swipe needed to start
        if prog > 1{prog = 1}
        if prog < 0{prog = 0}
        //print("prog: \(prog), progress: \(progress)")
        animatorView.currentProgress = prog
    }
    
    func refreshWillEnd(view: CRRefreshComponent) {
        //print("refresh will end")
    }
    
    func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state{
        case .pulling:
            label.text = "release to refresh"
        case .idle:
            label.text = "break chain to refresh"
        case .refreshing:
            label.text = "here it comes!"
        default:
            break
        }
    }
}
