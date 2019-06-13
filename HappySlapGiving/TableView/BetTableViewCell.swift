//
//  BetTableViewCell.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/5/31.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit

class BetTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var username1: UILabel!
    @IBOutlet weak var textowe: UILabel!
    @IBOutlet weak var username2: UILabel!
    
    @IBOutlet weak var slaps: UILabel!
    @IBOutlet weak var textslap: UILabel!
    
    @IBOutlet weak var incident: UILabel!
    
    @IBOutlet weak var profilephoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingcell(newbet: Bet){
        
        username1.text = newbet.username1
        username2.text = newbet.username2
        slaps.text = String(newbet.slaps)
        profilephoto.image = newbet.photo
        incident.text = newbet.incident
        
    }

}
