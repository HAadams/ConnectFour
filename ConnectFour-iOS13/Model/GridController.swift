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

struct GridController {
    var columns: Int = 0
    var rows: Int = 0
    var grid: [[Int]] = []
    var columnSizes: [Int] = []
    var gridSize: Int = 0
    var patternCount: Int = 0

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
        if isGridFull() {
            return false
        }
        return true
    }

}
