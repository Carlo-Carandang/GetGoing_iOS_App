//
//  FiltersViewController.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-24.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation
import UIKit

enum RankBy {
    case prominence
    case distance
    
    func description() -> String {
        switch self {
        case .prominence: return "Prominence"
        case .distance: return "Distance"
        }
    }
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var rankByLabel: UILabel!
    
    var rankByDictionary: [RankBy] = [.prominence , .distance]
    var rankSelected: RankBy = .prominence
    var radius: Float!
    var openNow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radius = radiusSlider.value
        pickerView.delegate = self
        rankByLabel.text = rankSelected.description()
        pickerView.isHidden = true
        
        let tapGestureRecognier = UITapGestureRecognizer(target: self, action: #selector(triggerPickerView))
        tapGestureRecognier.numberOfTapsRequired = 1
        rankByLabel.isUserInteractionEnabled = true
        rankByLabel.addGestureRecognizer(tapGestureRecognier)
    }
    
    @objc func triggerPickerView(){
        pickerView.isHidden = !pickerView.isHidden
    }
    
    @IBAction func sliderDragged(_ sender: UISlider) {
        print(sender.value)
    }
    
    @IBAction func openNowChanged(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //check the flight passes and compare highest passenger number and pick that
        return rankByDictionary.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rankByDictionary[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) -> Void {
        self.rankSelected = rankByDictionary[row]
        rankByLabel.text = rankSelected.description()
    }
}

