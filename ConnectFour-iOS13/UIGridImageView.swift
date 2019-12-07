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
        
        // offset correction to put Token views in the middle of the grid cell
        let offset: CGFloat = 10.0
        let x:CGFloat = (CGFloat(column) * cellWidth) + offset
        let y:CGFloat = (CGFloat(row) * cellHeight) + offset
        return CGPoint(x:x, y:y)
    }

}
