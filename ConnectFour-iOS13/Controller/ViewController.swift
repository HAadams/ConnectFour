//
//  ViewController.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var stopGame: Bool = false
    let gridRows = 6
    let gridColumns = 7
    let tokenMoveSpeed = 0.001  // 1 pixel per 0.001 seconds so 1000 pixels per second
    let numOfMatchingTokens = 4 // Number of tokens that need to match for a player to win
    let tokenFlashInterval = 0.3 // After scoring 4 tokens in a row they'll flash at 0.3s interval maxTokenFlashCount times
    let maxTokenFlashCount = 7  // Number of times winning tokens will flash (odd number so they are visible at the end)
    
    var human: Player?
    var phone: Player?
    var gridModel: GridController?
    var imageViewGrid: GridImageView?
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var humanScoreLabel: UILabel!
    @IBOutlet weak var phoneScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGridController()
        setupPlayers()
        setupGridView()
    }
    
    func setupGridController(){
        gridModel = GridController(columns: gridColumns, rows: gridRows, patternCount: numOfMatchingTokens)
        gridModel!.delegate = self
    }

    func setupPlayers(){        
        human = Player(image: "YellowToken", name: "You", playerID: GridEnum.PlayerOne.rawValue)
        human!.delegate = self
        phone = Player(image: "RedToken", name: "Phone", playerID: GridEnum.PlayerTwo.rawValue)
        phone!.delegate = self
        
        phone!.isBot = true
        human!.turn = true
        phone!.turn = false
    }

    func setupGridView() {
        imageViewGrid = GridImageView(frame: CGRect(origin: gridView.bounds.origin, size: gridView.bounds.size))
        imageViewGrid!.image = #imageLiteral(resourceName: "Grid")
        imageViewGrid!.initGrid(columns: gridModel!.columns, rows: gridModel!.rows)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(gridTapped))
        imageViewGrid!.addGestureRecognizer(recognizer)

        imageViewGrid!.isUserInteractionEnabled = true
        gridView.addSubview(imageViewGrid!)
    }

    @objc func gridTapped(recognizer: UIGestureRecognizer){
        guard !stopGame else {return}

        if let grid = recognizer.view as? GridImageView {
            if let gridPosition = imageViewGrid?.getGridPositionFromPoint(point: recognizer.location(in: grid)){
                
                // Human player tapped grid to play
                if !stopGame && addTokenToGridModel(at: gridPosition.1, for: &human!) {
                    swapTurns(player1: &human!, player2: &phone!)
                }else {
                    return
                }
                
                
                // Bot should play right after
                let randomColumn = self.gridModel!.getRandomNonEmptyColumn()
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {timer in
                    if !self.stopGame && self.addTokenToGridModel(at: randomColumn, for: &self.phone!){
                        self.swapTurns(player1: &self.human!, player2: &self.phone!)
                    }
                    timer.invalidate()
                }

            }
        }
    }
    
    func swapTurns(player1: inout Player, player2: inout Player) {
        let turn1 = player1.turn
        player1.turn = player2.turn
        player2.turn = turn1
    }
    
    func addTokenToGridModel(at column: Int, for player: inout Player) -> Bool{
        guard player.turn else {return false}
        // Update grid 2D array and return which row the token was placed
        return gridModel!.addToken(to:column, with:&player)
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 1 {
            human!.reset()
            phone!.reset()
        }
        human!.turn = true
        phone!.turn = false
        gridModel!.clearGrid()
        imageViewGrid!.clearViews()
        notificationLabel.alpha = 0.0
        stopGame = false

    }
    
}


extension ViewController: GridDelegate, PlayerDelegate {

    func playerScoreChanged(player: Player){
        if player.isBot {
            phoneScoreLabel.text = String(player.score)
            phoneScoreLabel.alpha = CGFloat(1.0)
        }else {
            humanScoreLabel.text = String(player.score)
            humanScoreLabel.alpha = CGFloat(1.0)
        }
    }
    
    func valueAddedToGrid(row: Int, column: Int, player: inout Player){
        let tokenView = UIImageView(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: CGFloat(0), height: CGFloat(0))))
        tokenView.image = UIImage(named: player.image!)
        self.imageViewGrid!.moveViewTo(row: row, column: column, view: tokenView)
    }
    
    func foundMatchingPattern(for player: inout Player, pattern locations: [(Int, Int)]) {
        // Global override to prevent players from playing until it is cleared (New Game started)
        stopGame = true
        
        // Flash the tokens that won the game to show user where they are
        var alpha = 0
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: tokenFlashInterval, repeats: true) {timer in
            alpha ^= 1
            counter += 1
            for tokenPosition in locations {
                self.imageViewGrid!.childViews[tokenPosition.0][tokenPosition.1]?.alpha = CGFloat(alpha)
            }
            if counter == self.maxTokenFlashCount {
                timer.invalidate()
            }
        }
        // Display message to indicate who won and increase player's score
        notificationLabel.text = "\(String(player.name!)) won!"
        notificationLabel.alpha = 1.0
        player.increaseScore()
    }
    
    func gridIsFull(){
        notificationLabel.text = "It's a tie!"
        notificationLabel.alpha = CGFloat(1.0)
    }

}
