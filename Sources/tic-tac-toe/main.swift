import HyperSwift
import JavaScriptKit

let document = JSObject.global.document
let game = Game()
let tiles = (1...9).map { createTile(with: "tile-\($0)") }

let trackedReferences = tiles.enumerated().map { offset, element in
    (element.id, onClickHandler(index: offset, id: element.id))
}

document.body.object?.innerHTML = generateBody().jsValue()

trackedReferences.forEach { id, handler in
     document.getElementById(id).object?.onclick = .function(handler)
}

let customCSS = """
.losing-tile {
    opacity: 35%;
}
.\(game.primaryPlayer.identifier)-tile {
    color: \(Style.Color.primaryPlayer);
}
.\(game.secondaryPlayer.identifier)-tile {
    color: \(Style.Color.secondaryPlayer);
}
body {
    margin: 0px;
    padding: 0px;
}
"""

var style = document.createElement("style")
style.innerHTML = (CSSStyleSheet.generateStyleSheet() + customCSS).jsValue()
_ = document.head.appendChild(style)


game.didUpdate = { status, currentPlayer in
    // update occupied tiles
    tiles.enumerated().forEach { index, tile in
        let state = game.trackedTiles[index]
        var ref = document.getElementById(tile.id)
        if case .occupied(let player) = state {
            _ = ref.classList.add("\(player.identifier)-tile")
            ref.firstChild.innerHTML = player.identifier.jsValue()
            ref.disabled = true.jsValue()
        }
    }
    
    guard status == .inProgress else {
        var subtext: String = ""
        if case GameStatus.won(let player, let combinations) = game.status {
            tiles.enumerated().filter({ !combinations.contains($0.offset) }).forEach {
                _ = document.getElementById($0.element.id).object?.classList.add("losing-tile")
            }
            subtext = "Player \(player.identifier) won!"
        } else {
            subtext = "tie"
        }
        
        tiles.forEach { document.getElementById($0.id).object?.disabled = true.jsValue() }
        
        document.getElementById("header-pane").object?.innerHTML = VStack(align: .center) {
            Header(.h1) { "Game Over!" }
            Header(.h3) { subtext }
                .padding(bottom: 15)
        }
        .render()
        .jsValue()
        
        return
    }
   
    document.getElementById("header-pane").object?.lastChild.innerHTML = createCurrentPlayerStatus(from: currentPlayer).render().jsValue()
}

func generateBody() -> String {
    Div {
        header
        board
    }
    .display(.flex)
    .flexWrap(.wrap)
    .justifyContent(.spaceBetween)
    .backgroundColor(Style.Color.background)
    .color(Style.Color.text)
    .alignItems(.center)
    .font(family: "monospace")
    .height(100, .percent)
    .width(100, .percent)
    .render()
}

func onClickHandler(index: Int, id: String) -> JSClosure {
    JSClosure {_ in
        game.occupyTile(at: index)
    }
}
