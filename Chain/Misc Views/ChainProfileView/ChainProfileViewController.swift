//
//  ChainProfileViewController.swift
//  Chain
//
//  Created by Christian Burke on 3/22/20.
//  Copyright © 2020 Christian Burke. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChainProfileViewController: UIViewController, PostChainDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var profileImageBackView: UIView!
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var ref:Query!
    let loader = BeautifulLoadScreen(lottieAnimation: .UglyChain)
    var lastUserChainDoc:DocumentSnapshot?
    var user:ChainUser = masterAuth.currUser
    var collViewIndexReference:[String:IndexPath] = [:]
    private var shouldShowBack = false
    
    static func initFromSB(user:ChainUser)->ChainProfileViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChainProfileViewController") as! ChainProfileViewController
        vc.user = user
        vc.shouldShowBack = true
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(shouldShowBack)
        backButton.isHidden = !shouldShowBack
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.loader)
        
        self.user.load { (error) in
            self.loader.fadeOut()
            if error != nil{
                self.showPopUp(_title: "Error Loading User", _message: "nothin to see here")
                return
            }
            self.setForUser()
            self.ref = masterFire.db.collection("users").document(self.user.phoneNumber).collection("currentChains").limit(to: 25)
            self.loadUserChains { (succ) in
                self.loader.fadeOut()
                self.collectionView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                for cell in self.collectionView.visibleCells{
                    if let castCell = cell as? ChainCollectionViewCell{
                        castCell.updateTimeLabel()
                    }
                }
            }
        }
    }
    
    func setForUser(){
        collectionView.reloadData()
        titleLabel.text = "@\(user.username)"
    }
    
    func loadUserChains(succ: @escaping (Bool)->()){
        var tempRef = ref
        if lastUserChainDoc != nil{
            tempRef = ref.start(atDocument: lastUserChainDoc!)
        }
        tempRef!.getDocuments { (snap, err) in
            succ(true)
            if err != nil{print(err!.localizedDescription); return}
            guard let docs = snap?.documents else{ return }
            for doc in docs{
                if let newChain = PostChain(dict: doc.data()){
                    newChain.addDelegate(delegateID: "ChainProfileViewController", delegate: self)
                    masterCache.addChainToCache(chain: newChain)
                    masterAuth.currUser.currentChains.append(newChain)
                }
            }
        }
    }
    
    //MARK: Chain Delegate -
    func chainGotNewPost(post: ChainImage) {}
    
    func chainDidLoad(chain: PostChain) {
        if let index = collViewIndexReference[chain.chainName]{
            collectionView.reloadItems(at: [index])
        }else{
            collectionView.reloadData()
        }
    }
    
    func chainDidDie(chain: PostChain) {
        if let index = collViewIndexReference[chain.chainName]{
            collectionView.reloadItems(at: [index])
        }else{
            collectionView.reloadData()
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        masterNav.popViewController(animated: true)
    }
}

class MainProfileView: UICollectionReusableView{
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var bioField: UITextView!
    @IBOutlet var followersButton: RoundButton!
    @IBOutlet var followingButton: RoundButton!
        
    var user:ChainUser!
    
    func setForUser(_user:ChainUser){
        self.user = _user
        if let url = URL(string: user.profile){
            profileImageView.kf.setImage(with: url)
        }
        //Set up profile image frame
        profileImageView.layer.borderWidth = 2.5
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.Chain.mainOrange.cgColor //Using global color
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        //Add circular shadow to profile image
        
        //
        bioField.text = user.bio
        followingButton.setTitle("Followers (\(user.friends.count))", for: .normal)
    }
    
    func chainDidDie(chain: PostChain) {
        
    }
}
