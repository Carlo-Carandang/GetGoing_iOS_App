//
//  PhotoViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-24.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var photo: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = photo
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        if let photo = photo {
            UIImageWriteToSavedPhotosAlbum(photo,nil,nil,nil)
        }
    }
}
