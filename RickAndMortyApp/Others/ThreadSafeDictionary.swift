import Foundation

final class ThreadSafeDictionary<Key: Hashable, Entry> {
    private static var label: String {
        get { "\(Bundle.main.bundleIdentifier ?? "bundleIdentifier").tsdictionary" }
    }

    private var dictionary = [Key: Entry]()

    private let accessQueue = DispatchQueue.init(label: label,
                                                 attributes: .concurrent)

    func insert(_ value: Entry,
                forKey key: Key) {
        accessQueue.async(flags: .barrier) {
            self.dictionary[key] = value
        }
    }

    func getValue(forKey key: Key) -> Entry? {
        accessQueue.sync {
            return self.dictionary[key]
        }
    }

    func removeValue(forKey key: Key) {
        accessQueue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
}
