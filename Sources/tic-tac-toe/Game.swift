import Foundation
import HyperSwift

enum TileState: Equatable {
    case unoccupied, occupied(Player)
}

enum GameStatus: Equatable {
    case inProgress
    case tie, won(Player, Set<Int>)
}

struct Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    let identifier: String
    let color: CSSColor
    func occupiedTiles(from tiles: [TileState]) -> Set<Int> {
        Set(tiles.enumerated().filter { $0.element == .occupied(self) }.map { $0.offset })
    }
}

struct Game {
    typealias updateCallback = (_ status: GameStatus, _ currentPlayer: Player) -> Void
    let primaryPlayer: Player
    let secondaryPlayer: Player
    var status: GameStatus = .inProgress
    var currentPlayer: Player
    var trackedTiles: [TileState]
    private let winningCombinations = [
        Set([0, 1, 2]),
        Set([3, 4, 5]),
        Set([6, 7, 8]),
        Set([0, 4, 8]),
        Set([2, 4, 6]),
        Set([0, 3, 6]),
        Set([1, 4, 7]),
        Set([2, 5, 8])
    ]
    var didUpdate: updateCallback
    
    init(onUpdate callback: @escaping updateCallback) {
        status = .inProgress
        primaryPlayer = Player(identifier: "X", color: Style.Color.primaryPlayer)
        secondaryPlayer = Player(identifier: "O", color: Style.Color.secondaryPlayer)
        currentPlayer = primaryPlayer
        trackedTiles = Array(repeating: TileState.unoccupied, count: 9)
        didUpdate = callback
    }
}

extension Game {
    mutating func occupyTile(at index: Int) {
        trackedTiles[index] = TileState.occupied(currentPlayer)
        currentPlayer = currentPlayer == primaryPlayer ? secondaryPlayer : primaryPlayer
        checkForWinner()
        didUpdate(status, currentPlayer)
    }
    
    private mutating func checkForWinner() {
        let primaryTiles = primaryPlayer.occupiedTiles(from: trackedTiles)
        let secondaryTiles = secondaryPlayer.occupiedTiles(from: trackedTiles)
        
        for combination in winningCombinations {
            if combination == primaryTiles.intersection(combination) {
                status = .won(primaryPlayer, combination)
            }
            if combination == secondaryTiles.intersection(combination) {
                status = .won(secondaryPlayer, combination)
            }
        }
        
        if primaryTiles.count + secondaryTiles.count == 9 {
            status = .tie
        }
    }
}
