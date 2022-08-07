import Foundation

extension String {
    var makeUrlThumb: String {
        let i = self.index(self.startIndex, offsetBy: 4)
        var newString = self
        newString.insert("s", at: i)
        return newString + "/standard_small."
    }

    var makeUrlPortrait: String {
        let i = self.index(self.startIndex, offsetBy: 4)
        var newString = self
        newString.insert("s", at: i)
        return newString + "/portrait_uncanny."
    }

    var makeHttps: String {
        let i = self.index(self.startIndex, offsetBy: 4)
        var newString = self
        newString.insert("s", at: i)
        return newString
    }

}
