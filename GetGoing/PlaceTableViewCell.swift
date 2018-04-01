//
//  PlaceTableViewCell.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var aspectRatioLayoutConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func upDateAspectRatioConstraint(aspectRatio: CGFloat){
        aspectRatioLayoutConstraint.constant = aspectRatio
    }
}


