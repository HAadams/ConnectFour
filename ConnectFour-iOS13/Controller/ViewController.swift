//
//  ViewController.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let gridRows = 6
    let gridColumns = 7
    let numOfMatchingTokens = 4 // Number of tokens that need to match for a player to win
    let tokenMoveSpeed = 0.001  // 1 pixel per 0.001 seconds so 1000 pixels per second

    var human: Player?
    var phone: Player?
    var gridModel: GridController?

    @IBOutlet weak var gridView: UIView!
    var imageViewGrid: GridImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGridController()
        setupGridView()
        setupPlayers()
    }

    func setupPlayers(){
        let yellowToken = GridToken(value: GridEnum.PlayerOne.rawValue, token: UIImage(named: "YellowToken"))
        let redToken = GridToken(value: GridEnum.PlayerTwo.rawValue, token: UIImage(named: "RedToken"))
        
        human = Player(token: yellowToken, name: "You")
        phone = Player(token: redToken, name: "Phone")
        phone!.isBot = true
    }
    
    func setupGridController(){
        gridModel = GridController(columns: gridColumns, rows: gridRows, patternCount: numOfMatchingTokens)
        gridModel!.delegate = self
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
        if let grid = recognizer.view as? GridImageView {
            if let gridPosition = imageViewGrid?.getGridPositionFromPoint(point: recognizer.location(in: grid)){
                addTokenToGridModel(at: gridPosition.1, for: &human!)
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
    }
    
}

extension ViewController: GridDelegate {
    func valueAddedToGrid(row: Int, column: Int, player: inout Player) {
        // Token drop down animation start position at first row
        var startPoint = imageViewGrid!.getPointFromRowColumn(row: 0, column: column)
        // Get row and column of where this token should be placed after animation
        let endPoint = imageViewGrid!.getPointFromRowColumn(row: row, column: column)

        // Token should start its animation above the grid
        startPoint.y -= 100
        let tokenView = UIImageView(frame: CGRect(origin: startPoint, size: (player.token?.dimensions)!))
        tokenView.image = player.token?.token
        // Place the token in the GridView and display it
        imageViewGrid!.addSubview(tokenView)

        imageViewGrid!.addView(row: row, column: column, view: tokenView)
        // Start animation to move token down
        var counter = 1
        let loopUntil = Int(endPoint.y) - Int(startPoint.y)
        Timer.scheduledTimer(withTimeInterval: tokenMoveSpeed, repeats: true) {timer in
            tokenView.frame.origin.y = CGFloat(CGFloat(counter)+CGFloat(startPoint.y))
            if counter == loopUntil {
                timer.invalidate()
            }
            counter += 1
        }

    }
    
    func foundMatchingPattern(for player: inout Player, pattern locations: [(Int, Int)]) {
        print("matched!")
    }
    
    func gridIsFull() {
        print("I am full!")
    }
    
    
}
