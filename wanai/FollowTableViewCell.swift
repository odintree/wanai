//
//  FollowTableViewCell.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 03/07/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit

protocol FollowTableViewCellDelegate: class {
    func followCellFollowButtonPressed(sender: FollowTableViewCell)
}

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    weak var delegate: FollowTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func followButtonClicked(_ sender: UIButton) {
        
        if let delegate = delegate {
            delegate.followCellFollowButtonPressed(sender: self)
        }
    }

}
