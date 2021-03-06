//
//  BoardModel.swift
//  Imitate_Threes
//
//  Created by 任岐鸣 on 2016/10/10.
//  Copyright © 2016年 Ned. All rights reserved.
//

import UIKit

class BoardModel: NSObject {
    
    enum direction {
        case up
        case down
        case left
        case right
        case none
    }
    
    typealias finishClosure = (Void) -> Void
    typealias arrayClosure = (Array<Array<Bool>>) -> Void
    typealias loseClosure = (Int) -> Void
    
    var doAdded:finishClosure?
    var doMoved:arrayClosure?
    var doLosed:loseClosure?
    var doEvaluated:finishClosure?
    
    var leftMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    var rightMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    var upMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    var downMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    var addedPosition = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    
    var newChesses = [1,2]
    
    var board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    
    var movedLine = Array<Int>()
    var movedCol = Array<Int>()
    var addedLine = Array<Int>()
    var addedCol = Array<Int>()
    
    var moveDirection:direction = .none
    
    func initBoard() {
        for _ in 1...6 {
            let line = Int(arc4random() % 4)
            let row = Int(arc4random() % 4)
            if board[line][row] == 0 {
                board[line][row] = arc4random() % 2 == 0 ? 1 : 2
            }
        }
        evaluateBoard()
    }
    
    func resetBoard() {
        board = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
        for _ in 1...6 {
            let line = Int(arc4random() % 4)
            let row = Int(arc4random() % 4)
            if board[line][row] == 0 {
                board[line][row] = arc4random() % 2 == 0 ? 1 : 2
            }
        }
        leftMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        rightMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        upMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        downMovableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        addedPosition = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        
        newChesses = [1,2]
        
        movedLine = Array<Int>()
        movedCol = Array<Int>()
        addedLine = Array<Int>()
        addedCol = Array<Int>()
        evaluateBoard()
    }
    
    func move(direction:direction) {
        switch direction {
        case .down:
            moveDown()
        case .left:
            moveLeft()
        case .right:
            moveRight()
        case .up:
            moveUp()
        default:
            break;
        }
        moveDirection = direction
        doMoved?(addedPosition)
    }
    
    func addNewChess() {
        if addChess() {
            print("chess add")
        } else {
            print("cant add")
        }
        movedCol = []
        movedLine = []
        addedLine = []
        addedCol = []
        
        evaluateBoard()
        doAdded?()
    }
    
    private func canAdd(a:Int,b:Int) -> Bool {
        if (a == 1 && b == 2) || (a == 2 && b == 1) {
            //            print("a:\(a),b:\(b),=\(a+b)")
            return true
        } else if a != 1 && a != 2 && b != 2 && b != 1 && a == b {
            //            print("a:\(a),b:\(b),=\(a+b)")
            return true
        } else {
            //            print("a:\(a),b:\(b),CANT")
            return false
        }
    }
    
    private func canMove(a:Int,b:Int) -> Bool {
        if (a == 1 && b == 2) || (a == 2 && b == 1) {
            //            print("a:\(a),b:\(b),=\(a+b)")
            return true
        } else if (a != 1 && a != 2 && b != 2 && b != 1 && a == b) {
            //            print("a:\(a),b:\(b),=\(a+b)")
            return true
        } else if (a == 0 && b != 0) || (a != 0 && b == 0) {
            //            print("a:\(a),b:\(b),CANT")
            return true
        } else {
            return false
        }
    }
    
    private func addChess() -> Bool {
        guard hasSpace() else {
            return false
        }
        
        var location = 0
        switch moveDirection {
        case .left,.up:
            location = 3
        case .right,.down:
            location = 0
        case .none:
            return false
        }
        
        if !addedLine.isEmpty {
            newChess(line: addedLine.random()!, col: location)
            return true
        } else if !addedCol.isEmpty {
            newChess(line: location, col: addedCol.random()!)
            return true
        } else if !movedLine.isEmpty {
            
            newChess(line: movedLine.random()!, col: location)
            return true
        } else if !movedCol.isEmpty {
            
            newChess(line: location, col: movedCol.random()!)
            return true
        }
        return false
    }
    
    private func newChess(line:Int,col:Int) {
        print("want to add new:\(newChesses)")
        if board[line][col] == 0 {
            board[line][col] = newChesses[Int(arc4random() % UInt32(newChesses.count))]
        }
    }
    
    func getAmountOf(number:Int) -> Int {
        var n = 0
        for i in 0...3 {
            for j in 0...3 {
                if board[i][j] == number {
                    n += 1
                }
            }
        }
        return n
    }
    
    private func moveUp() {
        for col in 0...3 {
            var plus = false
            for line in 0...2 {
                if !plus {
                    if canAdd(a: board[line][col], b: board[line+1][col]) {
                        board[line][col] += board[line+1][col]
                        board[line+1][col] = 0
                        addedPosition[line][col] = true
                        plus = true
                        if !addedCol.contains(col) {
                            addedCol.append(col)
                        }
                    }
                }
                if board[line][col] == 0 {
                    board[line][col] = board[line+1][col]
                    board[line+1][col] = 0
                    if !movedCol.contains(col) {
                        movedCol.append(col)
                    }
                }
            }
        }
    }
    
    private func moveDown() {
        for col in 0...3 {
            var plus = false
            for line in 0...2 {
                let actualLine = 3-line
                if !plus {
                    if canAdd(a: board[actualLine][col], b: board[actualLine-1][col]) {
                        board[actualLine][col] += board[actualLine-1][col]
                        addedPosition[actualLine][col] = true
                        board[actualLine-1][col] = 0
                        plus = true
                        if !addedCol.contains(col) {
                            addedCol.append(col)
                        }
                    }
                }
                if board[actualLine][col] == 0 {
                    board[actualLine][col] = board[actualLine-1][col]
                    board[actualLine-1][col] = 0
                    if !movedCol.contains(col) {
                        movedCol.append(col)
                    }
                }
            }
        }
    }
    
    private func moveLeft() {
        for line in 0...3 {
            var plus = false
            for col in 0...2 {
                if !plus {
                    if canAdd(a: board[line][col], b: board[line][col+1]) {
                        board[line][col] += board[line][col+1]
                        addedPosition[line][col] = true
                        board[line][col+1] = 0
                        plus = true
                        if !addedLine.contains(line) {
                            addedLine.append(line)
                        }
                    }
                }
                if board[line][col] == 0 {
                    board[line][col] = board[line][col+1]
                    board[line][col+1] = 0
                    if !movedLine.contains(line) {
                        movedLine.append(line)
                    }
                }
            }
        }
    }
    
    private func moveRight() {
        for line in 0...3 {
            var plus = false
            for col in 0...2 {
                let actualCol = 3-col
                if !plus {
                    if canAdd(a: board[line][actualCol], b: board[line][actualCol-1]) {
                        board[line][actualCol] += board[line][actualCol-1]
                        addedPosition[line][actualCol] = true
                        board[line][actualCol-1] = 0
                        plus = true
                        if !addedLine.contains(line) {
                            addedLine.append(line)
                        }
                    }
                }
                if board[line][actualCol] == 0 {
                    board[line][actualCol] = board[line][actualCol-1]
                    board[line][actualCol-1] = 0
                    if !movedLine.contains(line) {
                        movedLine.append(line)
                    }
                }
            }
        }
    }
    
    private func hasSpace() -> Bool {
        for line in board {
            for chess in line {
                if chess == 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func printBoard () {
        for sub in board {
            print(sub)
        }
    }
    
    func evaluateBoard() {
        
        let evaluteGroup = DispatchGroup()
        
        let queueMovableUp = DispatchQueue(label: "up")
        queueMovableUp.async(group:evaluteGroup) {
            self.upMovableChesses = self.getMovableChesses(moveDirection: .up)
        }
        
        let queueMovableDown = DispatchQueue(label: "down")
        queueMovableDown.async(group: evaluteGroup) {
            self.downMovableChesses = self.getMovableChesses(moveDirection: .down)
        }
        
        let queueMovableLeft = DispatchQueue(label: "left")
        queueMovableLeft.async(group: evaluteGroup) {
            self.leftMovableChesses = self.getMovableChesses(moveDirection: .left)
        }
        
        let queueMovableRight = DispatchQueue(label: "right")
        queueMovableRight.async(group: evaluteGroup) {
            self.rightMovableChesses = self.getMovableChesses(moveDirection: .right)
        }
        
        let nextChess = DispatchQueue(label: "next")
        nextChess.async(group: evaluteGroup) {
            let chessesAvaliable = [1,2,3,6,12,24,48,96,192,384,768,1536,3072]
            self.newChesses = []
            let numberOf1 = self.getAmountOf(number: 1)
            let numberOf2 = self.getAmountOf(number: 2)
            
            let biggest = self.findBiggest()
            
            if biggest <= 24 {
                let rnd = arc4random() % 3 + 1
                switch rnd {
                case 1:
                    if numberOf1 >= 3 && numberOf2 < 3 {
                        self.newChesses = [[2,3].random()!]
                    } else if numberOf2 >= 3 && numberOf1 < 3 {
                        self.newChesses = [[1,3].random()!]
                    } else {
                        self.newChesses = [[1,2,3].random()!]
                    }
                    
                case 2:
                    if numberOf1 >= 3 && numberOf2 < 3 {
                        self.newChesses = [2,3]
                    } else if numberOf2 >= 3 && numberOf1 < 3 {
                        self.newChesses = [1,3]
                    } else {
                        self.newChesses = [3]
                    }
                case 3:
                    if numberOf1 >= 3 && numberOf2 < 3 {
                        self.newChesses = [2,3]
                    } else if numberOf2 >= 3 && numberOf1 < 3 {
                        self.newChesses = [1,3]
                    } else {
                        self.newChesses = [1,2,3]
                    }
                default:
                    break
                }
            } else {
                let position = chessesAvaliable.index(of: biggest / 8)!
                let subHighAvaliable = chessesAvaliable.subArray(fromIndex: 3,toIndex: position)
                var rnd = arc4random() % 4 + 1
                switch rnd {
                case 1,2:
                    let count = self.newChesses.count
                    while self.newChesses.count == count {
                        let new = subHighAvaliable.random()!
                        if !self.newChesses.contains(new) {
                            self.newChesses.append(new)
                        }
                    }
                case 3,4:
                    break
                default:
                    break
                }
                
                rnd = arc4random() % 2 + 1
                switch rnd {
                case 1:
                    if numberOf1 >= 3 && numberOf2 < 3 {
                        self.newChesses.append([2,3].random()!)
                    } else if numberOf2 >= 3 && numberOf1 < 3 {
                        self.newChesses.append([1,3].random()!)
                    } else {
                        self.newChesses.append([1,2,3].random()!)
                    }
                    
                case 2:
                    if numberOf1 >= 3 && numberOf2 < 3 {
                        self.newChesses.append(contentsOf: [2,3])
                    } else if numberOf2 >= 3 && numberOf1 < 3 {
                        self.newChesses = (contentsOf: [1,3])
                    } else {
                        let new = [1,2,3].random()!
                        if !self.newChesses.contains(new) {
                            self.newChesses.append(new)
                        }
                    }
                default:
                    break
                }
                
            }
            self.newChesses.sort()
            print("just make new:\(self.newChesses)")
            self.doEvaluated?()
        }
        printBoard()
        evaluteGroup.notify(queue: DispatchQueue.global()) {
            if !self.movable() {
                print("cant\(Thread.current)")
                self.doLosed!(self.getScore())
            } else {
                print("movable")
            }
        }
    }
    
    func getMovableChesses(moveDirection:direction) -> Array<Array<Bool>> {
        var movableChesses = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
        
        switch moveDirection {
        case .up:
            for col in 0...3 {
                let movableCol = colMovable(moveD: .up,numCol: col)
                for line in 0...3 {
                    movableChesses[line][col] = movableCol[line]
                }
            }
        case .down:
            for col in 0...3 {
                let movableCol = colMovable(moveD: .down,numCol: col)
                for line in 0...3 {
                    movableChesses[line][col] = movableCol[line]
                }
            }
        case .left:
            for line in 0...3 {
                movableChesses[line] = lineMovable(num: line,moveD: .left)
            }
        case .right:
            for line in 0...3 {
                movableChesses[line] = lineMovable(num: line,moveD: .right)
            }
        default:
            break
        }
        return movableChesses
    }
    
    private func lineMovable(num:Int,moveD:direction) -> Array<Bool> {
        var movableChesses = [false,false,false,false]
        
        switch moveD {
        case .left:
            movableChesses[0] = false
            for col in 1...3 {
                movableChesses[col] = canMove(a: board[num][col - 1], b: board[num][col])
                if movableChesses[col] {
                    for afterCol in col...3 {
                        movableChesses[afterCol] = true
                    }
                    if col == 3 && board[num][col] == 0 {
                        movableChesses[col] = false
                    }
                    break
                }
            }
        case .right:
            movableChesses[3] = false
            for col in 0...2 {
                let actualCol = 2 - col
                movableChesses[actualCol] = canMove(a: board[num][actualCol + 1], b: board[num][actualCol])
                if movableChesses[actualCol] {
                    for beforeCol in 0...actualCol {
                        movableChesses[beforeCol] = true
                    }
                    if actualCol == 0 && board[num][actualCol] == 0 {
                        movableChesses[actualCol] = false
                    }
                    break
                }
            }
        default:
            break
        }
        return movableChesses
    }
    
    private func colMovable(moveD:direction,numCol:Int) -> Array<Bool> {
        var movableChesses = [false,false,false,false]
        
        switch moveD {
        case .up:
            movableChesses[0] = false
            for line in 1...3 {
                movableChesses[line] = canMove(a: board[line-1][numCol], b: board[line][numCol])
                if movableChesses[line] {
                    for afterCol in line...3 {
                        movableChesses[afterCol] = true
                    }
                    if line == 3 && board[line][numCol] == 0 {
                        movableChesses[line] = false
                    }
                    break
                }
            }
        case .down:
            for line in 0...2 {
                movableChesses[3] = false
                let actualLine = 2-line
                movableChesses[actualLine] = canMove(a: board[actualLine][numCol], b: board[actualLine+1][numCol])
                if movableChesses[actualLine] {
                    for beforeCol in 0...actualLine {
                        movableChesses[beforeCol] = true
                    }
                    if actualLine == 0 && board[actualLine][numCol] == 0 {
                        movableChesses[actualLine] = false
                    }
                    break
                }
            }
        default:
            break
        }
        return movableChesses
    }
    
    func resetAdded() {
        addedPosition = Array(repeatElement(Array(repeatElement(false, count: 4)), count: 4))
    }
    
    func getScore() -> Int {
        var scoreDic:Dictionary<Double,Double> = [:]
        for k in 1...20 {
            scoreDic[Double(3)*pow(2.0, Double(k-1))] = pow(3.0, Double(k))
        }
        var score:Double = 0.0
        for i in 0...3 {
            for j in 0...3 {
                let chessPoint = Double(board[i][j])
                if chessPoint >= 3 {
                    score += scoreDic[chessPoint]!
                    print("Point:\(scoreDic[chessPoint])")
                }
            }
        }
        return Int(score)
    }
    
    func movable() -> Bool {
        for i in 0...3 {
            for j in 0...3 {
                if leftMovableChesses[i][j]||rightMovableChesses[i][j]||upMovableChesses[i][j]||downMovableChesses[i][j] {
                    return true
                }
            }
        }
        return false
    }
    
    func findBiggest() -> Int {
        var biggest = 0
        for i in 0...3 {
            for j in 0...3 {
                biggest = max(board[i][j],biggest)
            }
        }
        return biggest
    }
}

