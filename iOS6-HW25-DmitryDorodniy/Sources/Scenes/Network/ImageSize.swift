import Foundation

enum ImageSize {
    case small
    case portrait

    var set: String {
        switch self {
        case .small:
            return "/standard_small."
        case .portrait:
            return "/portrait_uncanny."
        }
    }
}
