//
//  RatingControl.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-17.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    var ratingButtons: [UIButton] = []
    var rating: Int = 0 {
        didSet{
            updateButtonStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateButtonStatus(){
        for i in 0..<rating {
            ratingButtons[i].isHighlighted = true
        }
    }
    
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let filledStar = #imageLiteral(resourceName: "StarFull")
        let emptyStar = #imageLiteral(resourceName: "StarEmpty")
        
        for _ in 0..<5 {
            let button = UIButton()
            //Set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
}
