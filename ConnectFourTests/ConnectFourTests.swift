//
//  ConnectFourTests.swift
//  ConnectFourTests
//
//  Created by Hussein Adams on 12/7/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import XCTest
@testable import ConnectFour

class ConnectFourTests: XCTestCase {
    
    var gridController: GridController?
    var player1: Player?
    var player2: Player?
    let columns: Int = 7
    let rows: Int = 6
    let patternCount: Int = 4
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gridController = GridController(columns: columns, rows: rows, patternCount: patternCount)
        player1 = Player(image: "SomeToken", name: "Player1", playerID: GridEnum.PlayerOne.rawValue)
        player2 = Player(image: "SomeToken", name: "Player2", playerID: GridEnum.PlayerTwo.rawValue)

    }

    override func tearDown() {
        gridController?.clearGrid()
    }

    func testAddingTokens() {
        for i in 0..<columns {
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert((gridController?.addToken(to: i, with: &player1!))!)
            assert(!(gridController?.addToken(to: i, with: &player1!))!)
        }
    }
    func testCheckingForPatterns0() {
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert(!(gridController?.checkPattern(for: &player2!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
    }
    func testCheckingForPatterns1() {
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.checkPattern(for: &player2!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
    }
    func testCheckingForPatterns2() {
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.checkPattern(for: &player1!))!)
    }
    func testCheckingForPatterns3() {
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
        assert(!(gridController?.checkPattern(for: &player2!))!)
    }
    func testCheckingForPatterns4() {
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 1, with: &player1!))!)
        assert((gridController?.addToken(to: 2, with: &player1!))!)
        assert((gridController?.addToken(to: 3, with: &player1!))!)
        assert((gridController?.checkPattern(for: &player1!))!)
        assert(!(gridController?.checkPattern(for: &player2!))!)

    }
    func testCheckingForPatterns5() {
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 1, with: &player2!))!)
        assert((gridController?.addToken(to: 1, with: &player1!))!)
        assert((gridController?.addToken(to: 2, with: &player2!))!)
        assert((gridController?.addToken(to: 2, with: &player2!))!)
        assert((gridController?.addToken(to: 2, with: &player1!))!)
        assert((gridController?.addToken(to: 3, with: &player2!))!)
        assert((gridController?.addToken(to: 3, with: &player2!))!)
        assert((gridController?.addToken(to: 3, with: &player2!))!)
        assert((gridController?.addToken(to: 3, with: &player1!))!)
        assert((gridController?.checkPattern(for: &player1!))!)
        assert(!(gridController?.checkPattern(for: &player2!))!)
    }
    func testCheckingForPatterns6() {
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player1!))!)
        assert((gridController?.addToken(to: 0, with: &player2!))!)
        assert((gridController?.addToken(to: 1, with: &player1!))!)
        assert((gridController?.addToken(to: 1, with: &player1!))!)
        assert((gridController?.addToken(to: 1, with: &player2!))!)
        assert((gridController?.addToken(to: 2, with: &player1!))!)
        assert((gridController?.addToken(to: 2, with: &player2!))!)
        assert((gridController?.addToken(to: 3, with: &player2!))!)
        assert(!(gridController?.checkPattern(for: &player1!))!)
        assert((gridController?.checkPattern(for: &player2!))!)
    }

}
