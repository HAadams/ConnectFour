//
//  ViewController.swift
//  ConnectFour-iOS13
//
//  Created by Hussein Adams on 12/6/19.
//  Copyright © 2019 Hussein Adams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gridView: UIView!
    var imageViewGrid: GridImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGridView()
    }

    func setupGridView() {
        imageViewGrid = GridImageView(frame: CGRect(origin: gridView.bounds.origin, size: gridView.bounds.size))
        imageViewGrid!.image = #imageLiteral(resourceName: "Grid")
        imageViewGrid!.initGrid(columns: 7, rows: 6)

        imageViewGrid!.isUserInteractionEnabled = true
        gridView.addSubview(imageViewGrid!)
    }


}

