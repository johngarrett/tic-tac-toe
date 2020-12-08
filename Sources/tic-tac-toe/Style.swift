import HyperSwift

enum Style {
    enum Color {
        static let text = CSSColor("#f8f8ff")
        static let background = CSSColor("#262335")
        static let tileBackground = CSSColor("#503c52")
        static let tileBorder = CSSColor("#454060")
        static let primaryPlayer = CSSColor("#ffbb6c")
        static let secondaryPlayer = CSSColor("#d4896a")
    }
    enum Font {
        static let headerSize = CSSUnit(4, .em)
        static let family = "monospace"
    }
}
