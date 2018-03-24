//
//  PlaceTableViewCell.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var vicinity: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageViewAspectRatioLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingControlView: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateAspectRatioConstraint(_ ratio: CGFloat) {
        self.imageViewAspectRatioLayoutConstraint.constant = ratio
    }
    
}

