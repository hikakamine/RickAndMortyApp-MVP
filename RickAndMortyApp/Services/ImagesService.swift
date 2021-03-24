import Foundation

protocol ImagesLoader {

    func getImage(forURL url: URL,
                  completionHandler: @escaping (Data) -> Void)
}

class ImagesService: ImagesLoader {

    func getImage(forURL url: URL,
                  completionHandler: @escaping (Data) -> Void) {
        
    }
}
