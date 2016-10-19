//
//  ScoreCell.swift
//  Imitate_Threes
//
//  Created by 任岐鸣 on 16/10/14.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class ScoreCell: UICollectionViewCell {
    
    var board = [[1,2,3,1],[2,3,1,2],[3,1,2,3],[1,2,3,1]]
    var score = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func setModel(boardScore:ScoreModel) {
        board = boardScore.chessArray
        score = boardScore.score
    }
    
    init(boardScore:ScoreModel, frame:CGRect) {
        super.init(frame: frame)
        board = boardScore.chessArray
        score = boardScore.score
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let gameBoard = BoardView.init(frame: self.frame)
        addSubview(gameBoard)
        gameBoard.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        for i in 0...3 {
            for j in 0...3 {
                gameBoard.chesses[i][j].lastNum = board[i][j]
                gameBoard.chesses[i][j].setNumber(number:board[i][j],added:false,direction: BoardModel.direction.None)
            }
        }
    }
}