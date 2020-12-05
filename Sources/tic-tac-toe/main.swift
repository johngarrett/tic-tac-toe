import HyperSwift
import JavaScriptKit

let document = JSObject.global.document

let currentPlayer = "X"
var div = document.createElement("div")

func button(with id: String) -> HTMLElement {
    Button(id: id) {
        Header(.header2) { "" }
            .add(style: .init("font-size", "4em"))
            .add(style: .init("font-family", "monospace"))
    }
    .borderRadius(16)
    .padding(10)
    .backgroundColor(CSSColor("black"))
    .color(CSSColor("white"))
    .width(100, .percent)
    .height(100, .percent)
}

let buttons = (1...9).map {
    button(with: "tile-\($0)")
}

let header = HStack(id: "header", align: .center) {
    Header(.header1) { "Current Player: \(currentPlayer)" }
}

let board = Div(id: "board") {
    buttons
}
.display(.grid)
.width(100, .percent)
.height(100, .percent)
.maxWidth(500)
.add(style: .init("grid-template", "repeat(3, 1fr) / repeat(3, 1fr)"))
.add(style: .init("place-items", "center"))

let game = Game()

func onClickHandler(index: Int, id: String) -> JSClosure {
    JSClosure {_ in
        game.occupyTile(at: index)
    }
}

func disableAllButtons() {
    buttons.forEach {
        document.getElementById($0.id).object?.disabled = true.jsValue()
    }
}

div.innerHTML = Div {
    header
    board
}
.display(.flex)
.flexWrap(.wrap)
.justifyContent(.spaceBetween)
.alignItems(.center)
.render()
.jsValue()

_ = document.body.appendChild(div)

let trackedReferences = buttons.enumerated().map {
    ($0.element.id, onClickHandler(index: $0.offset, id: $0.element.id))
}

for (id, handler) in trackedReferences {
     document.getElementById(id).object?.onclick = .function(handler)
}

game.didUpdate = {
    for (index, button) in buttons.enumerated() {
        let state = game.trackedTiles[index]
        var ref = document.getElementById(button.id)
        switch state {
        case .unoccupied:
            print("unoccupied")
        case .occupied(let player):
            print("occupied by \(player)")
            ref.firstChild.innerHTML = player.jsValue()
            ref.disabled = true.jsValue()
        }
        
    }
    
    
    guard game.status == .inProgress else {
        var subtext: String = ""
        if case GameStatus.won(let player, let combinations) = game.status {
            buttons.enumerated().filter({ combinations.contains($0.offset) }).forEach {
                document.getElementById($0.element.id).object?.style.backgroundColor = "green"
            }
            subtext = "Player \(player) won!"
        } else {
            subtext = "tie"
        }
        
        disableAllButtons()
        document.getElementById("header").object?.innerHTML = VStack(align: .center) {
            Header(.header1) { "Game Over!" }
            Header(.header3) { subtext }
        }.render().jsValue()

        return
    }
   
    document.getElementById("header").object?.firstChild.innerHTML = "Current Player: \(game.currentPlayer)".jsValue()
}
