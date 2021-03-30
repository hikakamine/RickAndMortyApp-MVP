import Foundation

final fileprivate class WrappedKey<T: Hashable>: NSObject {
    let key: T
    init(_ key: T) {
        self.key = key
    }
    override var hash: Int { key.hashValue }
    override func isEqual(_ object: Any?) -> Bool {
        guard let value = object as? WrappedKey else {
            return false
        }
        return value.key == self.key
    }
}

final fileprivate class WrappedEntry<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

final class Cache<Key: Hashable, Entry> {

    private let nscache = NSCache<WrappedKey<Key>, WrappedEntry<Entry>>()

    var name: String {
        get {
            nscache.name
        }
        set {
            nscache.name = newValue
        }
    }

    func insert(_ value: Entry,
                forKey key: Key) {
        nscache.setObject(WrappedEntry(value),
                          forKey: WrappedKey<Key>(key))
    }

    func getValue(forKey key: Key) -> Entry? {
        return nscache.object(forKey: WrappedKey<Key>(key))?.value
    }

    func removeValue(forKey key: Key) {
        nscache.removeObject(forKey: WrappedKey<Key>(key))
    }
}
