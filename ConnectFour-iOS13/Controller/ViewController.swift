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
        setupGridView()
        setupPlayers()
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
        
        phone!.turn = false
        human!.turn = true
        
        // Start a play at a random position if its phone's turn
        // This line is here to acommodate making it possible for phone to go first
        play(at: -1)
    }

    func setupGridView() {
        // Setup the ImageView to take hte size of its parent UIView
        imageViewGrid = GridImageView(frame: CGRect(origin: gridView.bounds.origin, size: gridView.bounds.size))
        imageViewGrid!.image = #imageLiteral(resourceName: "Grid")
        imageViewGrid!.initGrid(columns: gridColumns, rows: gridRows)

        // If user taps on grid then call the gridTapped function
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(gridTapped))
        imageViewGrid!.addGestureRecognizer(recognizer)
        imageViewGrid!.isUserInteractionEnabled = true
        
        gridView.addSubview(imageViewGrid!)
    }

    @objc func gridTapped(recognizer: UIGestureRecognizer){
        guard !stopGame else {return}
        // listen for user taps on the grid and translate x,y coordinates to locaion (row, column) on the grid then place token if conditions are met

        if let grid = recognizer.view as? GridImageView {
            if let gridPosition = imageViewGrid?.getGridPositionFromPoint(point: recognizer.location(in: grid)){
                // Attempt to place token at the column user tapped
                play(at: gridPosition.1)
            }
        }
    }
    
    func play(at column: Int) {
        // Function used to start a *play* and then swap turns
        // column parameter can be any value if player.isBot == true

        if human!.turn && column >= 0 && column < gridModel!.columns{
            human!.turnToPlay(at: column)
            //Phone's turn to play
            phone!.turn = !(human!.turn)
        }
        if phone!.turn {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {timer in
                self.phone!.turnToPlay(at: -1)
                // TODO? at this point the token is still moving down to its position
                // TODO? CONT'd should we make this blocking?
                self.human!.turn = !(self.phone!.turn)
                timer.invalidate()
            }
        }
    }
    
    func addTokenToGridModel(at column: Int, for player: inout Player) -> Bool{
        guard player.turn else {return false}
        // Update grid 2D array and return which row the token was placed
        return gridModel!.addToken(to:column, with:&player)
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        // If reset stats button is pressed clear out scores
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
    func playerTurnToPlay(at column: Int, player: inout Player) -> Bool {
        // This function is called from Player when its the specified player's turn to play
        var tokenColumn = column
        if player.isBot {
            tokenColumn = gridModel!.getRandomNonFullColumn()
        }
        if !stopGame && addTokenToGridModel(at: tokenColumn, for: &player){
            return true
        }else{
            return false
        }
    }
    

    func playerScoreChanged(player: Player){
        // This function is called from Player when specified player wins to update their score
        if player.isBot {
            phoneScoreLabel.text = String(player.score)
            phoneScoreLabel.alpha = CGFloat(1.0)
        }else {
            humanScoreLabel.text = String(player.score)
            humanScoreLabel.alpha = CGFloat(1.0)
        }
    }
    
    func valueAddedToGrid(row: Int, column: Int, player: inout Player) {
        // This function is called from GridController when a player places a token in the grid and notifies the ViewController to update the UI as well
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
        // This function is called from GridController when grid is full and no pattern was found
        notificationLabel.text = "It's a tie!"
        notificationLabel.alpha = CGFloat(1.0)
    }

}
