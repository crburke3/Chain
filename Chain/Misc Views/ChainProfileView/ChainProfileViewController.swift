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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var ref:Query!
    let loader = BeautifulLoadScreen(lottieAnimation: .UglyChain)
    var lastUserChainDoc:DocumentSnapshot?
    var user:ChainUser = masterAuth.currUser
    var collViewIndexReference:[String:IndexPath] = [:]

    convenience init(user:ChainUser) {
        self.init()
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = masterFire.db.collection("users").document(user.phoneNumber).collection("currentChains").limit(to: 25)
        view.addSubview(loader)
        collectionView.delegate = self
        collectionView.dataSource = self
        loadUserChains { (succ) in
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
    
}

class MainProfileView: UICollectionReusableView{
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var bioField: UITextView!
    @IBOutlet var followersButton: RoundButton!
    @IBOutlet var followingButton: RoundButton!
        
    var user:ChainUser!
    
    func setForUser(_user:ChainUser){
        self.user = _user
        profileImageView.kf.setImage(with: URL(string: user.profile))
        bioField.text = user.bio
        followingButton.setTitle("Followers (\(user.friends.count))", for: .normal)
    }
    
    func chainDidDie(chain: PostChain) {
        
    }
}
