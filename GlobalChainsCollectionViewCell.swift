//
//  GlobalChainsCollectionViewCell.swift
//  
//
//  Created by Michael Rutkowski on 3/26/20.
//

import UIKit

class GlobalChainsCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let cellId = "GlobalChain"
    var chainArray = [PostChain]()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let appsCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            return collectionView
        }()

        func setupViews() {
            //backgroundColor = .clear
            addSubview(appsCollectionView)
            appsCollectionView.delegate = self
            appsCollectionView.dataSource = self
            appsCollectionView.backgroundColor = UIColor.clear
            appsCollectionView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/3)
            //appsCollectionView.register(ExplorePageCell.self, forCellWithReuseIdentifier: "GlobalChain")
            appsCollectionView.register(UINib(nibName: "SingleGlobalChainCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ChainCell")
            self.appsCollectionView.reloadData()
            //addConstrainstWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
            //addConstrainstWithFormat("V:|[v0]|", views: appsCollectionView)
        }
        
        func globalChainsLoaded() {
            self.appsCollectionView.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return chainArray.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = self.appsCollectionView.dequeueReusableCell(withReuseIdentifier: "ChainCell", for: indexPath) as! SingleGlobalChainCollectionViewCell
            cell.chain = chainArray[indexPath.row]
            cell.cellDidLoad()
            return cell
        }
        
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screen = UIScreen.main.bounds
            let screenWidth = screen.width
            let screenHeight = screen.height
            let width = (screen.width / 2) - 10
            let height = (screenHeight/screenWidth) * width
            return CGSize(width: screenWidth/4, height: screenWidth/4)
        }

}
