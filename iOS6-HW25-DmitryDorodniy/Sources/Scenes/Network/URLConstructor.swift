import Foundation

class URLConstructor {

    func getUrl(name: String?, value: String?) -> String {
        var components = URLComponents()
        components.scheme = "https"
        print(components)
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/comics"
        components.queryItems = [URLQueryItem(name: "format", value: "comic"),
                                 URLQueryItem(name: "hasDigitalIssue", value: "true"),
                                 URLQueryItem(name: "orderBy", value: "focDate"),
                                 URLQueryItem(name: name ?? "", value: value),
                                 URLQueryItem(name: "limit", value: "40"),
                                 URLQueryItem(name: "ts", value: "1"),
                                 URLQueryItem(name: "apikey", value: "7e1b58c9e3967cddad472e676e668a4e"),
                                 URLQueryItem(name: "hash", value: "56ea6ee528ff5b2a8724f7a312bcc6f6")]
        let url = components.url?.absoluteString ?? ""
        print(url)
        return url
    }
}
