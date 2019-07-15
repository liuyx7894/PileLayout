//
//  ViewController.swift
//  PileLayout
//
//  Created by Louis Liu on 2019/2/26.
//  Copyright © 2019 Louis Liu. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initPileLayout()
    }
    
    func initPileLayout(){
        
        let layout = PileLayout()
//        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        layout.minimumLineSpacing = 15
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "PileCell", bundle: nil), forCellWithReuseIdentifier: "PileCell")
        
        collectionView.snp.makeConstraints { (m) in
            m.top.equalTo(20)
            m.left.right.equalTo(0)
            m.height.equalTo(250)
        }
        collectionView.backgroundColor = .red
    }

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c =  collectionView.dequeueReusableCell(withReuseIdentifier: "PileCell", for: indexPath) as! PileCell
        c.count.text = "\(indexPath.row)"
        return c
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }
    
   
}
