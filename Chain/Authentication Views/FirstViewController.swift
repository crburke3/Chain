//
//  FirstView.swift
//  Chain
//
//  Created by Christian Burke on 11/26/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth
import Pastel
import FirebaseFunctions


class FirstViewController : UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var expensiveView: UIView!
    @IBOutlet var signInButton: RoundButton!
    let phoneNumber = "+19802550653"
    let testVerificationCode = "123456"
    var hasShown = false
    var signUpCoverView:TriangleView!
    var triangleVert:NSLayoutConstraint!
    let animTime = 0.5
    let loader = BeautifulLoadScreen(lottieAnimation: .UglyChain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        loader.isHidden = true
        masterNav = self.navigationController! //Guessing you were trying to get the current Nav Controller
        masterStoryBoard = self.storyboard!
        addGradient()
        setUpSignUpView()
        guard let savedPhone = loadString(ident: .phoneNumber), let savedPass = loadString(ident: .password) else{ return}
        loader.fadeIn()
        ChainAuth.initFrom(phone: savedPhone, password: savedPass) { (auth) in
            self.loader.fadeOut()
            if auth != nil{
                masterAuth = auth!
                let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
                masterNav.pushViewController(mainVC, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if hasShown{
            for const in expensiveView.constraints{
                expensiveView.removeConstraint(const)
            }
            expensiveView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            expensiveView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            expensiveView.translatesAutoresizingMaskIntoConstraints = false
            let screenSize = UIScreen.main.bounds
            triangleVert.constant = screenSize.height
            UIView.animate(withDuration: animTime, delay: 0, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
                self.signInButton.setTitleColor(.white, for: .normal)
            }) { (succ) in
            }
        }

    }
    
    @IBAction func enterTapped(_ sender: Any) {
        currentUser.bio = "What's up guys!"
        currentUser.name = "Mike R"
        currentUser.username = "bigDawg"
        currentUser.blocked = []
        currentUser.invites = []
        currentUser.phoneNumber = "+19802550653"
        currentUser.profile = "https://firebasestorage.googleapis.com/v0/b/chain-3ad1e.appspot.com/o/Fitwork%20Images%2FD2F69E6E-47D8-4307-A91F-C4E1A737B3B1?alt=media&token=4fbfa3b6-c775-4935-b1de-ab12e98c940b"
        currentUser.topPosts = []
        let mainVC = masterStoryBoard.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
        masterNav.pushViewController(mainVC, animated: true)
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        for const in expensiveView.constraints{
            expensiveView.removeConstraint(const)
        }
        let screenBounds = UIScreen.main.bounds
        expensiveView.widthAnchor.constraint(equalToConstant: screenBounds.width * 1.5).isActive = true
        expensiveView.heightAnchor.constraint(equalToConstant: screenBounds.height * 1.5).isActive = true
        expensiveView.translatesAutoresizingMaskIntoConstraints = false
        UIView.animate(withDuration: animTime, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.signInButton.setTitleColor(UIColor.Chain.mainOrange, for: .normal)
        }) { (succ) in
            self.hasShown = true
            masterNav.pushViewController(SignInViewController(), animated: false)
        }
    }
    
    @IBAction func signUpTappe(_ sender: Any) {
        self.triangleVert.constant = -500
        hasShown = true
        UIView.animate(withDuration: animTime, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        }) { (succ) in
            masterNav.pushViewController(SignUpViewController(), animated: false)
        }
    }

    
    func setUpSignUpView(){
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width * 3
        let height = screenSize.height * 2
        let niceSize = CGRect(x: 0, y: 0, width: width, height: height)
        signUpCoverView = TriangleView(frame: niceSize)
        view.addSubview(signUpCoverView)
        signUpCoverView.translatesAutoresizingMaskIntoConstraints = false
        signUpCoverView.widthAnchor.constraint(equalToConstant: width).isActive = true
        signUpCoverView.heightAnchor.constraint(equalToConstant: height).isActive = true
        signUpCoverView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        triangleVert = signUpCoverView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height)
        triangleVert.isActive = true
        signUpCoverView.backgroundColor = .clear
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .restricted: break
        case .denied:
            NSLog("do some error handling")
            break
        default:
            masterLocator.startUpdatingLocation()
        }
    }
    
    func addGradient(){
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 3.0
        pastelView.setColors([UIColor.Chain.mainBlue,
                              UIColor.Chain.mainOrange])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
}



class TriangleView : UIView {
    
    var mainColor:CGColor = UIColor.white.cgColor{
        didSet{
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.setFillColor(self.mainColor)
            self.backgroundColor = .green
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()

        context.setFillColor(UIColor.Chain.lightTan.cgColor)
        //self.backgroundColor = nil
        context.fillPath()
    }
    
}
