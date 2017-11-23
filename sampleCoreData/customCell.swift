//
//  customCell.swift
//  sampleCoreData
//
//  Created by Eriko Ichinohe on 2017/11/22.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    @IBOutlet weak var saveDateLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
