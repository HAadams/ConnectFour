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
    
}
