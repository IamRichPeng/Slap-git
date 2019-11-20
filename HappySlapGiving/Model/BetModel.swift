//
//  BetModel.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/6/3.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit

class Bet {
    //MARK: Properties
    
    var username1: String
    var username2: String
    var slaps: Int //加一个slap变量，加深对整个流程的理解。
    var winner: String
    var incident: String
     var photo: UIImage?
    var timestamp: Int
    
    //MARK: Initialization
    
    init?(username1: String, username2: String, slaps: Int, winner: String, incident: String, photo: UIImage?, timestamp: Int){
        
        // The name must not be empty
        guard !username1.isEmpty else {
            return nil
        }
        guard !username2.isEmpty else {
            return nil
        }
        
        self.username1 = username1
        self.username2 = username2
        self.slaps = slaps
        self.winner = winner
        self.incident = incident
        self.photo = photo
        self.timestamp = timestamp
    }
}
