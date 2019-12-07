//
//  UIGridImageView.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import UIKit

class GridImageView: UIImageView {
    
    var cellWidth:CGFloat = 0.0
    var cellHeight:CGFloat = 0.0
    var rows = 0
    var columns = 0
    
    var childViews: [[UIImageView?]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initGrid(columns: Int, rows: Int) {
        self.rows = rows
        self.columns = columns
        self.cellWidth = self.bounds.width/CGFloat(self.columns)
        self.cellHeight = self.bounds.height/CGFloat(self.rows)
        for _ in 0..<self.rows {
            var viewsRow:[UIImageView?] = []
            for _ in 0..<self.columns {
                viewsRow.append(nil)
            }
            childViews.append(viewsRow)
        }
    }
    
    func getGridPositionFromPoint(point: CGPoint) -> (Int, Int){
        // Assumes point is from the GridView UIImageView
        let column = Int(floor(point.x/cellWidth))
        let row = Int(floor(point.y/cellHeight))
        return (row, column)
    }
    
    func getPointFromRowColumn(row: Int, column: Int) -> CGPoint {
        // Returns the x,y coordinates of the specified cell
        // the values returned are the top left corner position of the specified cell
        
        // offset correction to put Token views in the middle of the grid cell
        let offset: CGFloat = 0.0
        let x:CGFloat = (CGFloat(column) * cellWidth) + offset
        let y:CGFloat = (CGFloat(row) * cellHeight) + offset
        return CGPoint(x:x, y:y)
    }

    func clearViews() {
        self.subviews.forEach({$0.removeFromSuperview()})
        childViews.removeAll()
        initGrid(columns: columns, rows: rows)
    }

    func addView(row: Int, column: Int, view: UIImageView) {
        childViews[row][column] = view
        self.addSubview(view)
    }
    
    func moveViewTo(row: Int, column: Int, view: UIImageView){
        // Token drop down animation start position at first row of chosen column
        var startPoint = self.getPointFromRowColumn(row: 0, column: column)
        // Get row and column of where this token should be placed after animation
        var endPoint = self.getPointFromRowColumn(row: row, column: column)
        // Token should start its animation above the grid
        startPoint.y -= 100
        
        // Modify view size based off of the specific's grid cell size
        let sizeOffset: CGFloat = self.cellWidth/3.5
        let size = CGFloat(self.cellWidth) - sizeOffset
        // offset the points based off of the size of the token
        startPoint.y += sizeOffset / 2
        startPoint.x += sizeOffset / 2
        endPoint.x += sizeOffset / 2
        endPoint.y += sizeOffset / 2
        
        // Set the views position and size based off of above calculated offsets
        view.frame.origin = startPoint
        view.frame.size = CGSize(width: size, height: size)
        
        self.addView(row: row, column: column, view: view)
        
        // Start animation to move token down
        var counter = 1
        let loopUntil = Int(endPoint.y) - Int(startPoint.y)
        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) {timer in
            view.frame.origin.y = CGFloat(CGFloat(counter)+CGFloat(startPoint.y))
            if counter == loopUntil {
                timer.invalidate()
            }
            counter += 1
        }

    }
}
