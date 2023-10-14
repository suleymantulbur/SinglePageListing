import Foundation
@propertyWrapper
public final class Dependency<Value> {
    private var value: Value?
    private let manager: DependencyManager
    public init(manager: DependencyManager = .shared) {
        self.manager = manager
    }
    public init(wrappedValue: Value) {
        self.value = wrappedValue
        self.manager = .shared
    }
    public var wrappedValue: Value {
        get {
            if let value = value {
                return value
            } else {
                let value: Value = manager.read(for: Value.self)
                self.value = value
                return value
            }
        }
        set {
            value = newValue
        }
    }
}

