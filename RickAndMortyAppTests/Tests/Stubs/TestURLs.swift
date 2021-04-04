import Foundation

final class TestURLs {

    final class CharactersData {
        static let test: [URL: (Data, HTTPURLResponse)] = [characterUrl: (characterData, characterResponse)]

        static let characterUrl: URL = URL(string: "https://rickandmortyapi.com/api/character")!
        static let characterData: Data = bundleData(forResource: "CharactersPage1",
                                                    ofType: ".json")
        static let characterResponse: HTTPURLResponse = HTTPURLResponse(url: characterUrl,
                                                                        statusCode: 200,
                                                                        httpVersion: "HTTP/1.1",
                                                                        headerFields: nil)!
    }

    final class InvalidURL {
        static let test: [URL: (Data, HTTPURLResponse)] = [invalidUrl: (invalidData, invalidResponse)]

        static let invalidUrl: URL = URL(string: "https://rickandmortyapi.com/api/characters")!
        static let invalidData: Data = bundleData(forResource: "Error404",
                                                  ofType: ".json")
        static let invalidResponse: HTTPURLResponse = HTTPURLResponse(url: invalidUrl,
                                                                      statusCode: 404,
                                                                      httpVersion: "HTTP/1.1",
                                                                      headerFields: nil)!
    }

    final class SingleCharacterData {
        static let test: [URL: (Data, HTTPURLResponse)] = [singleCharacterUrl: (singleCharacterData, singleCharacterResponse)]

        static let singleCharacterUrl: URL = URL(string: "https://rickandmortyapi.com/api/character/1")!
        static let singleCharacterData: Data = bundleData(forResource: "Character1",
                                                          ofType: ".json")
        static let singleCharacterResponse: HTTPURLResponse = HTTPURLResponse(url: singleCharacterUrl,
                                                                              statusCode: 200,
                                                                              httpVersion: "HTTP/1.1",
                                                                              headerFields: nil)!
    }

    final class ImageData {
        static let test: [URL: (Data, HTTPURLResponse)] = [imageUrl: (imageData, imageResponse)]

        static let imageUrl: URL = URL(string: "https://rickandmortyapi.com/api/character/avatar/00.jpeg")!
        static let imageData: Data = bundleData(forResource: "00",
                                                ofType: ".jpeg")
        static let imageResponse: HTTPURLResponse = HTTPURLResponse(url: imageUrl,
                                                                    statusCode: 200,
                                                                    httpVersion: "HTTP/1.1",
                                                                    headerFields: nil)!
    }

    private static func bundleData(forResource resource: String,
                           ofType type: String) -> Data {
        let path = Bundle(for: TestURLs.self).url(forResource: resource, withExtension: type)!
        return try! Data(contentsOf: path)
    }
}
