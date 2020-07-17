//
//  OtherMessageCell.swift
//  Flash Chat iOS13
//
//  Created by muhammad.farisi on 17/07/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class OtherMessageCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var labelV: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelContainer.layer.cornerRadius = labelContainer.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(_ name: String) {
        labelV.text = name
    }
    
}
