//
//  EmptyTableView.swift
//  FlexForum
//
//  Created by Christian Burke on 4/22/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import UIKit

class ChristianEmptyTableView: UITableView{
    
    //let emptyView = UIView(frame: CGRect(x: 10, y: 10, width: 50, height: 100))
    let emptyView = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 100))
    private var loaded = false
    public var tableData:Any? = nil
    
    override func reloadData() {
        super.reloadData()
        if(self.tableData == nil){
            emptyView.isHidden = false
        }else{
            if let data = tableData as? [Any]{
                if data.count != 0{
                    emptyView.isHidden = true
                }
            }
        }
    }
    
    override func layoutSubviews() {
        if !loaded{
            setupMainView()
            loaded = true
        }
        sizeMainView()
        super.layoutSubviews()
    }
    
    func sizeMainView(){
        emptyView.center = self.center
        emptyView.frame = self.frame
    }
    
    //-----------------------------------------------------------------------
    
    private func setupMainView(){
        //let parent = self.superview
        emptyView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.backgroundView = emptyView
        //parent!.addSubview(emptyView)
        //parent!.bringSubviewToFront(emptyView)
        emptyView.text = emptyText
        emptyView.textAlignment = NSTextAlignment.center
        emptyView.textColor = UIColor.darkGray
    }
    
    @IBInspectable var emptyText: String = "There are no items here" {
        didSet{
            self.emptyView.text = self.emptyText
        }
    }

}
