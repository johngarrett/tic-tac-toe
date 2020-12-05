import HyperSwift
import JavaScriptKit

let document = JSObject.global.document

let currentPlayer = "X"
var div = document.createElement("div")

func button(with id: String) -> HTMLElement {
    Button(id: id) {
        Header(.header2) { "X" }
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

func onClickHandler(id: String) -> JSClosure {
    JSClosure {_ in
        print(id)
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

let trackedReferences = buttons.map { ($0.id, onClickHandler(id: $0.id)) }

for (id, handler) in trackedReferences {
    var element = document.getElementById(id)
    element.onclick = .function(handler)
}
