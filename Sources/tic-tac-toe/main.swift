import HyperSwift
import JavaScriptKit

enum Style {
    enum Color {
        static let text = CSSColor("#f8f8ff")
        static let background = CSSColor("#262335")
        static let tileBackground = CSSColor("#503c52")
        static let tileBorder = CSSColor("#454060")
        static let player1 = CSSColor("#ffbb6c")
        static let player2 = CSSColor("#d4896a")
    }
    enum Font {
        static let headerSize = CSSUnit(4, .em)
        static let family = "monospace"
    }
}

let document = JSObject.global.document
let currentPlayer = "X"

func button(with id: String) -> HTMLElement {
    Button(id: id) {
        Header(.h2) { "" }
            .font(size: Style.Font.headerSize, family: Style.Font.family)
    }
    .border(4, .solid, color: Style.Color.tileBorder)
    .borderRadius(16)
    .padding(10)
    .backgroundColor(Style.Color.background)
    .color(Style.Color.text)
    .width(100, .percent)
    .height(100, .percent)
}

let buttons = (1...9).map {
    button(with: "tile-\($0)")
}

let header = VStack(id: "header", align: .center) {
    HStack(justify: .spaceBetween) {
        Div { "X" }
            .backgroundColor(Style.Color.player1)
            .padding(10, for: .horizontal)
            .borderRadius(8)
            .font(weight: "bold", size: CSSUnit(14))
            .color(Style.Color.text)
        Div { "O" }
            .backgroundColor(Style.Color.player2)
            .padding(5)
            .borderRadius(8)
            .color(Style.Color.text)
            .font(weight: "bold", size: CSSUnit(14))
            .padding(10, for: .horizontal)
    }
    Header(.h1) { "Current Player: \(currentPlayer)" }
        .color(Style.Color.text)
}
.add(style: CSSStyle("flex-grow", "1"))

let board = Div(id: "board") {
    buttons
}
.display(.grid)
.width(100, .percent)
.height(100, .percent)
.maxWidth(500)
.gridTemplate("repeat(3, 1fr) / repeat(3, 1fr)")
.gridGap(5)
.placeItems(.center)
.add(style: CSSStyle("flex-grow", "1"))

let game = Game()

func onClickHandler(index: Int, id: String) -> JSClosure {
    JSClosure {_ in
        game.occupyTile(at: index)
    }
}

document.body.object?.innerHTML = Div {
    header
    board
}
.display(.flex)
.flexWrap(.wrap)
.justifyContent(.spaceBetween)
.backgroundColor(Style.Color.background)
.padding(15)
.color(Style.Color.text)
.alignItems(.center)
.font(family: "monospace")
.render()
.jsValue()

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
        if case .occupied(let player) = state {
            ref.className = "player1-tile"
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
        let startOverButton = Button(id: "restart") { "Start Over" }
            .padding(10, for: .horizontal)
            .backgroundColor(Style.Color.tileBorder)
            .color(Style.Color.text)
            .borderRadius(8)
            .font(weight: .medium, size: CSSUnit(16), family: "monospace")
        buttons.forEach {
            document.getElementById($0.id).object?.disabled = true.jsValue()
        }
        
        document.getElementById("header").object?.innerHTML = VStack(align: .center) {
            Header(.h1) { "Game Over!" }
            Header(.h3) { subtext }
                .padding(bottom: 15)
            startOverButton
        }
        .render()
        .jsValue()

        return
    }
   
    document.getElementById("header").object?.lastChild.innerHTML = "Current Player: \(game.currentPlayer)".jsValue()
}

document.body.object?.style.margin = 0
