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

struct GridToken {
    var value: Int?
    var token: UIImage?
    let dimensions: CGSize = CGSize(width:30.0, height:30.0)
}

protocol GridDelegate {
    func valueAddedToGrid(row: Int, column: Int, player: inout Player)
    func foundMatchingPattern(for player: inout Player, pattern locations: [(Int, Int)])
    func gridIsFull()
}

struct GridController {
    var columns: Int = 0
    var rows: Int = 0
    var grid: [[Int]] = []
    var columnSizes: [Int] = []
    var gridSize: Int = 0
    var patternCount: Int = 0
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
        guard let value = player.token?.value else {return false}
        guard !isColumnFull(column: column) else {return false}
        let rowIndex = rows - columnSizes[column] - 1
        grid[rowIndex][column] = value
        columnSizes[column] += 1
        gridSize += 1
        self.delegate?.valueAddedToGrid(row: rowIndex, column: column, player: &player)
        self.checkPattern(for: &player)
        if isGridFull() {
            delegate?.gridIsFull()
            return false
        }
        return true
    }
    
    func getRandomNonEmptyColumn() -> Int{
        var randomGridColumn = Int.random(in: 0 ..< columns)
        while isColumnFull(column: randomGridColumn){
            randomGridColumn = Int.random(in: 0 ..< columns)
        }
        return randomGridColumn
    }
    
    func checkPattern(for player: inout Player){
        let pattern: Int = (player.token?.value)!
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column] == player.token?.value {
                    if let data = checkRightPattern(row: row, column: column, pattern: pattern) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return
                    }else if let data = checkDownPattern(row: row, column: column, pattern: pattern) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return
                    }else if let data = checkDiagPattern(row: row, column: column, pattern: pattern, direction: 1) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return
                    }else if let data = checkDiagPattern(row: row, column: column, pattern: pattern, direction: -1) {
                        delegate?.foundMatchingPattern(for: &player, pattern: data)
                        return
                    }
                }
            }
        }
    }
        
    private func checkDiagPattern(row:Int, column:Int, pattern: Int, direction: Int) -> [(Int, Int)]? {
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
