import Foundation

extension String {
    var makeHttps: String {
        let i = self.index(self.startIndex, offsetBy: 4)
        var newString = self
        newString.insert("s", at: i)
        return newString
    }
}
