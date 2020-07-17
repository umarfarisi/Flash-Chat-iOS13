//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by muhammad.farisi on 16/07/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var labelV: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelContainer.layer.cornerRadius = labelContainer.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
