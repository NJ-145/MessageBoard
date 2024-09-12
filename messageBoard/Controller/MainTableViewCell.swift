//
//  MainTableViewCell.swift
//  messageBoard
//
//  Created by imac-2626 on 2024/9/12.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var lbName: UILabel!
    
    static let identifier = "MainTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
