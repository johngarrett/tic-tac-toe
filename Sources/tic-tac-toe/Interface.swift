import HyperSwift

let header = VStack(id: "header-pane", align: .center) {
    createCurrentPlayerStatus(from: game.currentPlayer)
}
.flexGrow(1)

let board = Div("board") {
    tiles
}
.display(.grid)
.maxWidth(800)
.width(100, .percent)
.height(80, .percent)
.gridTemplate("auto auto auto / auto auto auto")
.gridGap(5)
.padding(10)
.placeItems(.center)
.flexGrow(1)

func createCurrentPlayerStatus(from player: Player) -> HTMLElement {
    Header(.h1) { "\(player.identifier)'s turn" }
        .color(Style.Color.text)
}

func createTile(with id: String) -> HTMLElement {
    Button("tile", id: id) {
        Header(.h2, cssClass: "title") { "⠀" }
            .font(size: Style.Font.headerSize, family: Style.Font.family)
            .padding(0)
            .margin(0)
    }
    .border(4, .solid, color: Style.Color.tileBorder)
    .borderRadius(16)
    .padding(10)
    .color(Style.Color.text)
    .backgroundColor(Style.Color.background)
    .width(100, .percent)
    .height(100, .percent)
}
