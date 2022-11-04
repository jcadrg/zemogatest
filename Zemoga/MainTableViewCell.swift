//
//  MainTableViewCell.swift
//  Zemoga
//
//  Created by Juanca on 2022-11-01.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var isFavorite: UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
