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
    }

    func setupGridView() {
        imageViewGrid = GridImageView(frame: CGRect(origin: gridView.bounds.origin, size: gridView.bounds.size))
        imageViewGrid!.image = #imageLiteral(resourceName: "Grid")
        imageViewGrid!.initGrid(columns: gridModel!.rows, rows: gridModel!.columns)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(gridTapped))
        imageViewGrid!.addGestureRecognizer(recognizer)

        imageViewGrid!.isUserInteractionEnabled = true
        gridView.addSubview(imageViewGrid!)
    }

    @objc func gridTapped(recognizer: UIGestureRecognizer){
        if let grid = recognizer.view as? GridImageView {
            if let gridPosition = imageViewGrid?.getGridPositionFromPoint(point: recognizer.location(in: grid)){
                let row = gridPosition.0
                let column = gridPosition.1
                // Token drop down animation start position at first row
                var startPoint = imageViewGrid!.getPointFromRowColumn(row: 0, column: column)
                // Get row and column of where this token should be placed after animation
                let endPoint = imageViewGrid!.getPointFromRowColumn(row: row, column: column)

                // Token should start its animation above the grid
                startPoint.y -= 100
                let tokenView = UIImageView(frame: CGRect(origin: startPoint, size: (human!.token?.dimensions)!))
                tokenView.image = human!.token?.token
                // Place the token in the GridView and display it
                imageViewGrid!.addSubview(tokenView)

                imageViewGrid!.addView(row: row, column: column, view: tokenView)
                // Start animation to move token down
                var counter = 1
                let loopUntil = Int(endPoint.y) - Int(startPoint.y)
                Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) {timer in
                    tokenView.frame.origin.y = CGFloat(CGFloat(counter)+CGFloat(startPoint.y))
                    if counter == loopUntil {
                        timer.invalidate()
                    }
                    counter += 1
                }
            }
        }
    }
    
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
    }
    
}

