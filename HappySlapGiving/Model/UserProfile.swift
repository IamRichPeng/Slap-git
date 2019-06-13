//
//  UserProfile.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/6/12.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    
    init(uid:String, username:String,photoURL:URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
