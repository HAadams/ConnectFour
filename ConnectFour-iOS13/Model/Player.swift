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
    func playerTurnToPlay(at column: Int, player: inout Player) -> Bool
}

struct Player {
    
    var isBot: Bool = false
    var name: String?
    var turn: Bool = false
    var score: Int = 0
    var image: String?
    var delegate: PlayerDelegate?
    var playerID: Int = 0

    
    init(image: String, name: String, playerID: Int){
        self.image = image
        self.name = name
        self.playerID = playerID
    }
    
    mutating func turnToPlay(at column: Int){
        if let played = delegate?.playerTurnToPlay(at: column, player: &self) {
            if played {
                turn = false
            }
        }
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
