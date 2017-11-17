//
//  ViewController.swift
//  Test
//
//  Created by Leonardo Armero Barbosa on 11/15/17.
//  Copyright © 2017 Exsis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        dPicker.minimumDate = formatter.date(from: "01/10/2017")
        dPicker.maximumDate = formatter.date(from: "01/12/2017")
        dPicker.datePickerMode = .date
        dPicker.
    }
}

