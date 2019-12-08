//
//  GridController.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import Foundation
import UIKit

enum GridEnum: Int {
    case PlayerOne = 0
    case PlayerTwo = 1
}

protocol GridDelegate {
    func valueAddedToGrid(row: Int, column: Int, player: inout Player)
    func foundMatchingPattern(for player: inout Player, pattern locations: [(Int, Int)])
    func gridIsFull()
}

struct GridController {
    var columns: Int = 0
    var rows: Int = 0
    var grid: [[Int]] = []      // 2D array of Ints to keep track of current play
    var columnSizes: [Int] = [] // keeps track of how many elemts in each column
    var gridSize: Int = 0   // Number of elements in the grid
    var patternCount: Int = 0  // Number of tokens matching in a row to win
    var delegate: GridDelegate?
    
    init(columns: Int, rows: Int, patternCount: Int) {
        self.columns = columns
        self.rows = rows
        self.patternCount = patternCount        
        initGrid()
    }
    
    mutating func initGrid(){
        for _ in 0..<rows {
            var col: [Int] = []
            for _ in 0..<columns {
                col.append(-1)
            }
            grid.append(col)
        }
        for _ in 0..<columns {
            columnSizes.append(0)
        }
    }
    
    func getSize(of column: Int) -> Int{
        return columnSizes[column]
    }
    
    func isGridFull() -> Bool {
        return gridSize == rows * columns
    }
    
    func isColumnFull(column: Int) -> Bool{
        return rows == columnSizes[column]
    }
    
    mutating func clearGrid() {
        gridSize = 0
        grid.removeAll()
        columnSizes.removeAll()
        initGrid()
    }
    
    mutating func addToken(to column: Int, with player: inout Player) -> Bool{
        guard !isColumnFull(column: column) else {return false}
        let rowIndex = rows - columnSizes[column] - 1
        grid[rowIndex][column] = player.playerID
        columnSizes[column] += 1
        gridSize += 1
        self.delegate?.valueAddedToGrid(row: rowIndex, column: column, player: &player)
        // Edge case: Should not return tie if grid is full and last token forms a pattern
        if !self.checkPattern(for: &player) && isGridFull(){
            delegate?.gridIsFull()
        }
        return true
    }
    
    func getRandomNonFullColumn() -> Int{
        var randomGridColumn = Int.random(in: 0 ..< columns)
        while isColumnFull(column: randomGridColumn){
            randomGridColumn = Int.random(in: 0 ..< columns)
        }
        return randomGridColumn
    }
    
    func checkPattern(for player: inout Player) -> Bool{
        // This method checks if a pattern formed (four consecutive connected tokens)
        // horizontally, vertically and diagnoally and calls a function to notify the view controller
        
        // TODO: Can be optimized to O(K) instead of O(rows*columns) where K = patternCount (i.e. number of connected tokens to win)
        let pattern: Int = player.playerID
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column] == pattern {
                    if let data = checkRightPattern(row: row, column: column, pattern: pattern) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return true
                    }else if let data = checkDownPattern(row: row, column: column, pattern: pattern) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return true
                    }else if let data = checkDiagPattern(row: row, column: column, pattern: pattern, direction: 1) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return true
                    }else if let data = checkDiagPattern(row: row, column: column, pattern: pattern, direction: -1) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return true
                    }
                }
            }
        }
        return false
    }
        
    private func checkDiagPattern(row:Int, column:Int, pattern: Int, direction: Int) -> [(Int, Int)]? {
        // Helper method to check for pattern in the diagnoal direction
        var data: [(Int, Int)] = []
        var j = column
        for i in row..<grid.count {
            if j >= columns || j < 0 {
                return nil
            }
            if grid[i][j] == pattern {
                data.append((i, j))
            }else {
                return nil
            }
            if data.count == patternCount {
                return data
            }
            j += direction
        }
        
        return nil
    }
    
    private func checkDownPattern(row:Int, column:Int, pattern: Int) -> [(Int, Int)]? {
        // helper function to check for pattern in the vertical dirction
        var data: [(Int, Int)] = []
        for i in row..<grid.count {
            if grid[i][column] == pattern {
                data.append((i, column))
            }else {
                return nil
            }
            if data.count == patternCount {
                return data
            }
        }
        
        return nil
    }
    
    private func checkRightPattern(row:Int, column:Int, pattern: Int) -> [(Int, Int)]? {
        // helper function to check if there is a pattern in the horizontal direction
        var data: [(Int, Int)] = []
        for i in column..<grid[0].count {
            if grid[row][i] == pattern {
                data.append((row, i))
            }else {
                return nil
            }
            if data.count == patternCount {
                return data
            }
        }
        
        return nil
    }

        
}
