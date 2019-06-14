//
//  BetDetailsController.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/6/4.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit

class BetDetailsController: UIViewController{
    
    @IBOutlet weak var username1: UILabel!
    @IBOutlet weak var username2: UILabel!
    @IBOutlet weak var incident: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    // This value ispassed by `MainTableViewController` in `prepare(for:sender:)`
    var bet: Bet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bet = bet{
            username1.text = bet.username1
            username2.text = bet.username2
            incident.text = bet.incident
            photo.image = bet.photo
        }

    }
}
