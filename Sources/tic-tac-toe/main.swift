import HyperSwift
import JavaScriptKit

let document = JSObject.global.document

var div = document.createElement("div")

let board = VStack(id: "board") {
    [
        HStack(justify: .spaceBetween) {
            Button("ttt-button", id: "b", children: [RawHTML("0")])
            Button("ttt-button", id: "b", children: [RawHTML("1")])
            Button("ttt-button", id: "b", children: [RawHTML("2")])
        },
        HStack(justify: .spaceBetween) {
            Button("ttt-button", id: "b", children: [RawHTML("3")])
            Button("ttt-button", id: "b", children: [RawHTML("4")])
            Button("ttt-button", id: "b", children: [RawHTML("5")])
        },
        HStack(justify: .spaceBetween) {
            Button("ttt-button", id: "b", children: [RawHTML("6")])
            Button("ttt-button", id: "b", children: [RawHTML("7")])
            Button("ttt-button", id: "b", children: [RawHTML("8")])
        }
    ]
}
div.innerHTML = board.render().jsValue()

_ = document.body.appendChild(div)
