//
//  Player.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import Foundation

protocol PlayerDelegate {
    func playerScoreChanged(player: Player)
}

struct Player {
    
    var isBot: Bool = false
    var name: String?
    var turn: Bool = true
    var score: Int = 0
    var token: GridToken?
    var delegate: PlayerDelegate?
    
    
    init(token: GridToken, name: String){
        self.token = token
        self.name = name
    }
    
    mutating func increaseScore(){
        self.score += 1
        self.delegate?.playerScoreChanged(player: self)
    }
    
    mutating func reset(){
        self.score = 0
        self.delegate?.playerScoreChanged(player: self)
    }
}
