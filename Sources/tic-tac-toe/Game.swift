import Foundation

enum TileState: Equatable {
    case unoccupied, occupied(String)
}

enum GameStatus: Equatable {
    case inProgress
    case tie, won(String, Set<Int>)
}

class Game {
    var status: GameStatus
    var currentPlayer: String
    var trackedTiles: [TileState]
    var didUpdate: (() -> Void)?
    
    init() {
        status = .inProgress
        currentPlayer = "X"
        trackedTiles = Array(repeating: TileState.unoccupied, count: 9)
    }
    
    func occupyTile(at index: Int) {
        trackedTiles[index] = TileState.occupied(currentPlayer)
        currentPlayer = currentPlayer == "X" ? "O" : "X"
        checkForWinner()
        didUpdate?()
    }
    
    /*
     1 2 3
     4 5 6
     7 8 9
     */
    private func checkForWinner() {
        let xTiles = Set(trackedTiles.enumerated().filter { $0.element == .occupied("X") }.map { $0.offset })
        let yTiles = Set(trackedTiles.enumerated().filter { $0.element == .occupied("O") }.map { $0.offset })
        
        print(xTiles)
        print(yTiles)
        
        let winningCombinations = [
            Set([0, 1, 2]),
            Set([3, 4, 5]),
            Set([6, 7, 8]),
            Set([0, 4, 8]),
            Set([2, 4, 6]),
            Set([0, 3, 6]),
            Set([1, 4, 7]),
            Set([2, 5, 8])
        ]
        
        for combination in winningCombinations {
            if combination == xTiles.intersection(combination) {
                status = GameStatus.won("X", combination)
            }
            if combination == yTiles.intersection(combination) {
                status = GameStatus.won("O", combination)
            }
        }
    }
}
