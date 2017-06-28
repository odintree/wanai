//
//  HomeTableViewCell.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 28/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var homeCellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
