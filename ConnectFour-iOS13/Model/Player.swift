//
//  Player.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import Foundation

struct Player {
    
    var isBot: Bool = false
    var name: String?
    var turn: Bool = true
    var score: Int = 0
    var token: GridToken?
    
    
    init(token: GridToken, name: String){
        self.token = token
        self.name = name
    }
}
