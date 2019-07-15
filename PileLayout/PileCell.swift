//
//  PileCell.swift
//  PileLayout
//
//  Created by Louis Liu on 2019/2/26.
//  Copyright © 2019 Louis Liu. All rights reserved.
//

import UIKit

class PileCell: UICollectionViewCell {

    @IBOutlet weak var count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        backgroundColor = .white
    }

}
